import { Injectable, UnauthorizedException } from '@nestjs/common';
import { ConfigService } from '@nestjs/config';
import { PassportStrategy } from '@nestjs/passport';
import { ExtractJwt, Strategy } from 'passport-jwt';
import { PrismaService } from '../prisma/prisma.service';
import { AuthUser } from './roles';

type JwtPayload = { sub: number; email: string; rol: string };

@Injectable()
export class JwtStrategy extends PassportStrategy(Strategy) {
  constructor(
    configService: ConfigService,
    private readonly prisma: PrismaService,
  ) {
    super({
      jwtFromRequest: ExtractJwt.fromAuthHeaderAsBearerToken(),
      ignoreExpiration: false,
      // IMPORTANTE: mismo secreto (y mismo fallback) que usa JwtModule en
      // auth.module.ts. Si estos dos valores llegaran a divergir, la firma
      // del access token nunca validaria aqui y CUALQUIER endpoint protegido
      // devolveria 401 aunque el token sea "valido" a ojos de quien lo emitio.
      secretOrKey: configService.get<string>('JWT_SECRET', 'secretKey_minimarket_2026'),
    });
  }

  async validate(payload: JwtPayload) {
    // Nota: aunque el payload ya trae email/rol (para cumplir con el
    // formato exigido), igual resolvemos el usuario contra la BD en cada
    // request. Es mas trabajo, pero evita servir accesos con datos
    // desactualizados si el rol/permisos cambiaron o si el usuario fue
    // desactivado despues de emitido el token.
     console.log('[JwtStrategy] payload recibido:', payload);
    const usuario = await this.prisma.usuario.findUnique({
      where: { id: payload.sub },
      include: { rol: { include: { permisos: { include: { permiso: true } } } } },
    });

    if (!usuario || !usuario.activo) throw new UnauthorizedException('Debe iniciar sesion');

    return {
      sub: usuario.id,
      email: usuario.email,
      nombre: usuario.nombre,
      rol: usuario.rol.codigo,
      permisos: usuario.rol.permisos.map((p) => p.permiso.codigo),
    };
  }
}