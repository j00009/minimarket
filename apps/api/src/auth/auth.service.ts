import { Injectable, UnauthorizedException } from '@nestjs/common';
import { UsuariosService } from '../usuarios/usuarios.service';
import { CreateUsuarioDto } from '../usuarios/dto/create-usuario.dto';
import { LoginDto } from './dto/login.dto';
import { SignUpDto } from './dto/signup.dto';
import { PasswordService } from './password.service';
import { TokenService } from './token.service';
import { AuthUser, ROLES } from './roles';
import { PrismaService } from '../prisma/prisma.service';
import * as crypto from 'crypto';

@Injectable()
export class AuthService {
  constructor(
    private readonly usuariosService: UsuariosService,
    private readonly passwordService: PasswordService,
    private readonly tokenService: TokenService,
    private readonly prisma: PrismaService,
  ) {}

  private async issueTokens(usuarioId: number, userPayload: AuthUser, replacesJti?: string) {
    // 1. Emitir access token
    const access_token = this.tokenService.sign(userPayload);

    // 2. Emitir refresh token con JTI
    const jti = crypto.randomUUID();
    const refresh_token = await this.tokenService.signRefresh(usuarioId, jti);

    // 3. Hash con SHA-256 (el refresh token es un JWT largo de alta entropia,
    // no una contrasena: no necesita el hashing lento de bcrypt, y bcrypt
    // ademas trunca la entrada a 72 bytes, lo que perderia parte del token).
    const tokenHash = crypto.createHash('sha256').update(refresh_token).digest('hex');

    // 4. Expiracion (7 dias desde hoy)
    const expiresAt = new Date();
    expiresAt.setDate(expiresAt.getDate() + 7);

    // 5. Guardar en BD
    await this.prisma.refreshToken.create({
      data: {
        id: jti,
        tokenHash,
        expiresAt,
        usuarioId,
      },
    });

    // 6. Si este token reemplaza a uno anterior (rotacion en /auth/refresh),
    // dejamos trazabilidad de la cadena de rotacion.
    if (replacesJti) {
      await this.prisma.refreshToken.update({
        where: { id: replacesJti },
        data: { replacedByTokenId: jti },
      });
    }

    return { access_token, refresh_token, user: userPayload };
  }

  async login(dto: LoginDto) {
    const usuario = await this.usuariosService.findByEmail(dto.email);

    if (!usuario || !usuario.activo) throw new UnauthorizedException('Credenciales invalidas');

    const passwordOk = await this.passwordService.verify(dto.password, usuario.passwordHash);
    if (!passwordOk) throw new UnauthorizedException('Credenciales invalidas');

    const userPayload = this.toAuthUser(usuario);

    return this.issueTokens(usuario.id, userPayload);
  }

  async signup(dto: SignUpDto) {
    const createDto: CreateUsuarioDto = {
      nombre: dto.nombre,
      email: dto.email,
      password: dto.password,
      rol: ROLES.VENDEDOR, // VENDEDOR = USER
    };

    const nuevoUsuario = await this.usuariosService.create(createDto, {
      sub: 0,
      email: '',
      nombre: 'signup',
      rol: ROLES.VENDEDOR,
      permisos: [],
    });

    // BUG QUE TENIAS: usuariosService.create() devuelve un objeto YA
    // APLANADO (rol como string, no como { codigo: string }). toAuthUser()
    // espera el shape crudo de Prisma (usuario.rol.codigo anidado), que es
    // lo que devuelve findByEmail()/findById(). Por eso hacia falta un
    // mapeo distinto aqui, sin pasar por toAuthUser().
    const userPayload: AuthUser = {
      sub: nuevoUsuario.id,
      email: nuevoUsuario.email,
      nombre: nuevoUsuario.nombre,
      rol: nuevoUsuario.rol,
      permisos: nuevoUsuario.permisos,
    };

    return this.issueTokens(nuevoUsuario.id, userPayload);
  }

  async me(user: AuthUser) {
    const usuario = await this.usuariosService.findById(user.sub);

    if (!usuario || !usuario.activo) throw new UnauthorizedException('Debe iniciar sesion');
    return this.toAuthUser(usuario);
  }

  // Usa este mapeo SOLO con registros crudos de Prisma que traen
  // include: { rol: { include: { permisos: ... } } } (findByEmail, findById).
  private toAuthUser(usuario: any): AuthUser {
    return {
      sub: usuario.id,
      email: usuario.email,
      nombre: usuario.nombre,
      rol: usuario.rol.codigo,
      permisos: usuario.rol.permisos.map((rolPermiso: any) => rolPermiso.permiso.codigo),
    };
  }

  async refresh(refreshToken: string) {
    // 1. Verificar firma y expiracion
    const { sub, jti } = await this.tokenService.verifyRefresh(refreshToken);

    // 2. Buscar en BD y verificar que no este revocado / expirado / de otro usuario
    const storedToken = await this.prisma.refreshToken.findUnique({ where: { id: jti } });
    if (
      !storedToken ||
      storedToken.revoked ||
      storedToken.usuarioId !== sub ||
      storedToken.expiresAt.getTime() < Date.now()
    ) {
      throw new UnauthorizedException('Refresh token invalido o revocado');
    }

    // 2b. Comprobar que el token recibido corresponde al hash guardado.
    // El JTI ya prueba que el JWT fue firmado por nosotros, pero comparar
    // el hash es lo que realmente detecta un refresh token reutilizado o
    // reconstruido con datos de otra fuente (ej. filtracion de BD sin el
    // secreto, o un JTI adivinado): si alguien logra forjar un token con
    // el mismo jti pero contenido distinto, el hash no calzaria.
    const tokenHash = crypto.createHash('sha256').update(refreshToken).digest('hex');
    const hashesMatch =
      tokenHash.length === storedToken.tokenHash.length &&
      crypto.timingSafeEqual(Buffer.from(tokenHash), Buffer.from(storedToken.tokenHash));
    if (!hashesMatch) {
      throw new UnauthorizedException('Refresh token invalido o revocado');
    }

    // 3. Rotacion: revocar el token anterior (replacedByTokenId se completa
    // en issueTokens() una vez que sabemos el jti del nuevo token)
    await this.prisma.refreshToken.update({
      where: { id: jti },
      data: { revoked: true },
    });

    // 4. Emitir nuevos tokens, enlazando la cadena de rotacion
    const usuario = await this.usuariosService.findById(sub);
    if (!usuario || !usuario.activo) throw new UnauthorizedException('Debe iniciar sesion');

    return this.issueTokens(sub, this.toAuthUser(usuario), jti);
  }

  async logout(usuarioId: number, refreshToken: string) {
    // BUG QUE TENIAS: update({ where: { id: jti, usuarioId } }) explota con
    // P2025 si el token no existe o es de otro usuario (Prisma no encuentra
    // el registro y lanza, no devuelve null). Buscamos primero con
    // findUnique y decidimos nosotros que hacer, sin dejar que el error de
    // Prisma se escape sin control.
    let jti: string | undefined;
    try {
      ({ jti } = await this.tokenService.verifyRefresh(refreshToken));
    } catch {
      // token invalido/expirado: igual respondemos ok, sin filtrar detalles.
      return { ok: true };
    }

    const storedToken = await this.prisma.refreshToken.findUnique({ where: { id: jti } });
    if (storedToken && storedToken.usuarioId === usuarioId && !storedToken.revoked) {
      await this.prisma.refreshToken.update({
        where: { id: jti },
        data: { revoked: true },
      });
    }

    // Siempre { ok: true }, exista o no el token, sea o no de este usuario.
    return { ok: true };
  }
}