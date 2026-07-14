import { Injectable, UnauthorizedException } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';
import { ConfigService } from '@nestjs/config';
import { AuthUser } from './roles';

type TokenPayload = AuthUser & {
  iat: number;
  exp: number;
};

@Injectable()
export class TokenService {
  constructor(
    private readonly jwtService: JwtService,
    private readonly configService: ConfigService, // <-- Inyectamos ConfigService
  ) { }

  sign(user: AuthUser) {
    // El payload lleva sub, email y rol (requerido por la rubrica). No
    // incluimos "permisos" para mantener el token liviano; los permisos
    // se resuelven en JwtStrategy.validate() consultando la BD en cada
    // request, lo que además garantiza que un cambio de rol/permisos se
    // refleje de inmediato sin esperar a que expire el token viejo.
    const payload = { sub: user.sub, email: user.email, rol: user.rol };
    return this.jwtService.sign(payload);
  }

  verify(token: string): TokenPayload {
    const parts = token.split('.');
    if (parts.length !== 3) throw new UnauthorizedException('Token invalido');

    try {
      return this.jwtService.verify<TokenPayload>(token);
    } catch (error) {
      if (error instanceof Error && error.name === 'TokenExpiredError') {
        throw new UnauthorizedException('Sesion expirada');
      }
      throw new UnauthorizedException('Token invalido');
    }
  }

  // --- NUEVOS MÉTODOS PARA REFRESH TOKEN ---

  async signRefresh(sub: number, jti: string): Promise<string> {
    const secret = this.configService.get<string>('JWT_REFRESH_SECRET');
    const expiresIn = this.configService.get<number>('JWT_REFRESH_EXPIRES');

    return this.jwtService.signAsync(
      { sub, jti },
      {
        secret,
        expiresIn: Number(expiresIn) // Aseguramos que sea un número
      }
    );
  }

  async verifyRefresh(token: string): Promise<{ sub: number; jti: string }> {
    try {
      const secret = this.configService.get<string>('JWT_REFRESH_SECRET');
      return await this.jwtService.verifyAsync(token, { secret });
    } catch (error) {
      throw new UnauthorizedException('Refresh token invalido o expirado');
    }
  }
}