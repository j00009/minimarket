import { Injectable, BadRequestException, NotFoundException } from '@nestjs/common';
import { PrismaService } from '../prisma/prisma.service';
import { CreateVentaDto } from './dto/create-venta.dto';
import { PasswordService } from '../auth/password.service';
import { AuthUser, ROLES } from '../auth/roles';

@Injectable()
export class VentasService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly passwordService: PasswordService,
  ) { }

  async create(dto: CreateVentaDto, user: AuthUser) {
    let total = 0;
    let descuentoTotal = 0;
    const detallesData: any[] = [];
    let tieneStockInsuficiente = false;

    for (const detalle of dto.detalles) {
      const producto = await this.prisma.producto.findUnique({
        where: { id: detalle.productoId },
        include: { categoria: true },
      });
      if (!producto) throw new NotFoundException(`Producto #${detalle.productoId} no encontrado`);
      const stockInsuficiente = producto.stock < detalle.cantidad;
      if (stockInsuficiente) tieneStockInsuficiente = true;

      const descuento = Math.min(producto.descuento + producto.categoria.descuento, 100);
      const precioFinal = +(producto.precio * (1 - descuento / 100)).toFixed(2);
      const subtotal = +(precioFinal * detalle.cantidad).toFixed(2);
      const descuentoMonto = +(producto.precio * (descuento / 100) * detalle.cantidad).toFixed(2);

      total += subtotal;
      descuentoTotal += descuentoMonto;

      detallesData.push({
        productoId: detalle.productoId,
        cantidad: detalle.cantidad,
        precioUnit: producto.precio,
        descuento,
        subtotal,
        stockInsuficiente,
        producto,
      });
    }

    const autorizador = tieneStockInsuficiente
      ? await this.validarAutorizacionStockInsuficiente(dto)
      : null;

    return this.prisma.$transaction(async (tx) => {
      const venta = await tx.venta.create({
        data: {
          total: +total.toFixed(2),
          descuentoTotal: +descuentoTotal.toFixed(2),
          metodoPago: dto.metodoPago ?? 'EFECTIVO',
          tieneStockInsuficiente,
          userId: user.sub, // Ajustado a la propiedad 'userId' del esquema migrado
          autorizadoPorId: autorizador?.id,
          motivoAutorizacion: tieneStockInsuficiente ? dto.motivoAutorizacion?.trim() : undefined,
          detalles: {
            create: detallesData.map(({ producto, ...d }) => d),
          },
        },
        include: { detalles: { include: { producto: true } } },
      });

      for (const d of detallesData) {
        await tx.producto.update({
          where: { id: d.productoId },
          data: { stock: { decrement: d.cantidad } },
        });
        await tx.movimiento.create({
          data: {
            productoId: d.productoId,
            tipo: 'SALIDA',
            cantidad: d.cantidad,
            motivo: `Venta #${venta.id}`,
            stockAntes: d.producto.stock,
            stockDespues: d.producto.stock - d.cantidad,
          },
        });
      }

      return venta;
    });
  }

  async findAll(user: AuthUser) {
    return this.prisma.venta.findMany({
      where: { userId: user.sub },
      include: { detalles: { include: { producto: { select: { nombre: true } } } } },
      orderBy: { createdAt: 'desc' },
    });
  }

  // Sin filtro por userId a proposito: solo se llega aqui si RolesGuard ya
  // valido que el usuario tiene rol ADMIN o SUPER_ADMIN (ver @Roles en el
  // controller). Muestra las ventas de TODOS los usuarios.
  async findAllAdmin() {
    return this.prisma.venta.findMany({
      include: {
        detalles: { include: { producto: { select: { nombre: true } } } },
        user: { select: { id: true, nombre: true, email: true } },
      },
      orderBy: { createdAt: 'desc' },
    });
  }

  async findOne(id: number, user: AuthUser) {
    const venta = await this.prisma.venta.findFirst({
      where: { id, userId: user.sub },
      include: { detalles: { include: { producto: true } } },
    });
    if (!venta) throw new NotFoundException(`Venta #${id} no encontrada`);
    return venta;
  }

  async remove(id: number, user: AuthUser) {
    const venta = await this.findOne(id, user);

    return this.prisma.$transaction(async (tx) => {
      for (const detalle of venta.detalles) {
        await tx.producto.update({
          where: { id: detalle.productoId },
          data: { stock: { increment: detalle.cantidad } },
        });
      }

      await tx.movimiento.deleteMany({
        where: { motivo: `Venta #${id}` },
      });

      await tx.detalleVenta.deleteMany({
        where: { ventaId: id },
      });

      return tx.venta.delete({
        where: { id },
      });
    });
  }

  private async validarAutorizacionStockInsuficiente(dto: CreateVentaDto) {
    const pin = dto.pinAutorizacion?.trim();
    const motivo = dto.motivoAutorizacion?.trim();

    if (!motivo) {
      throw new BadRequestException('Debe informar un motivo para autorizar stock insuficiente.');
    }

    if (!pin) {
      throw new BadRequestException('PIN de autorización inválido.');
    }

    const usuariosConPin = await this.prisma.usuario.findMany({
      where: {
        activo: true,
        pinAutorizacionHash: { not: null },
      },
      include: { rol: true },
    });

    for (const usuario of usuariosConPin) {
      if (!usuario.pinAutorizacionHash) continue;
      const pinOk = await this.passwordService.verify(pin, usuario.pinAutorizacionHash);
      if (!pinOk) continue;

      const rolAutorizado = [ROLES.SUPER_ADMIN, ROLES.ADMIN, ROLES.SUPERVISOR].includes(usuario.rol.codigo as any);
      if (!rolAutorizado) {
        throw new BadRequestException('El usuario no tiene permiso para autorizar stock insuficiente.');
      }

      return usuario;
    }

    throw new BadRequestException('PIN de autorización inválido.');
  }
  
}