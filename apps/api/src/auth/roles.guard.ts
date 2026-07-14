import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { ROLES_KEY } from './roles.decorator';
import { AuthUser, RolUsuario } from './roles';

@Injectable()
export class RolesGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const roles = this.reflector.getAllAndOverride<RolUsuario[]>(
      ROLES_KEY,
      [context.getHandler(), context.getClass()],
    );

    // If the metadata is not present on handler or class, this guard is opt-in.
    if (typeof roles === 'undefined') return true;

    // If metadata is present but empty, consider it as no restrictions.
    if (!roles?.length) return true;

    const user = context.switchToHttp().getRequest().user as AuthUser | undefined;
    if (user && roles.includes(user.rol)) return true;
    throw new ForbiddenException('No tiene permisos para esta accion');
  }
}
