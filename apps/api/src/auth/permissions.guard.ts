import { CanActivate, ExecutionContext, ForbiddenException, Injectable } from '@nestjs/common';
import { Reflector } from '@nestjs/core';
import { PERMISSIONS_KEY } from './permissions.decorator';
import { AuthUser, PermisoUsuario } from './roles';

@Injectable()
export class PermissionsGuard implements CanActivate {
  constructor(private readonly reflector: Reflector) {}

  canActivate(context: ExecutionContext): boolean {
    const permissions = this.reflector.getAllAndOverride<PermisoUsuario[]>(
      PERMISSIONS_KEY,
      [context.getHandler(), context.getClass()],
    );

    // If the metadata is not present on handler or class, this guard is opt-in.
    if (typeof permissions === 'undefined') return true;

    // If metadata is present but empty, consider it as no restrictions.
    if (!permissions?.length) return true;

    const user = context.switchToHttp().getRequest().user as AuthUser | undefined;
    if (user && permissions.every((permission) => user.permisos?.includes(permission))) return true;
    throw new ForbiddenException('No tiene permisos para esta accion');
  }
}
