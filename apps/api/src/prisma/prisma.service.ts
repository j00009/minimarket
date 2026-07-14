import { Injectable, OnModuleInit, OnModuleDestroy } from '@nestjs/common';
import { Prisma, PrismaClient } from '@prisma/client';
import { PrismaPg } from '@prisma/adapter-pg';

@Injectable()
export class PrismaService implements OnModuleInit, OnModuleDestroy {
  private client!: PrismaClient;

  get categoria() { return this.client.categoria; }
  get proveedor() { return this.client.proveedor; }
  get producto() { return this.client.producto; }
  get venta() { return this.client.venta; }
  get detalleVenta() { return this.client.detalleVenta; }
  get movimiento() { return this.client.movimiento; }
  get usuario() { return this.client.usuario; }
  get rol() { return this.client.rol; }
  get permiso() { return this.client.permiso; }
  get rolPermiso() { return this.client.rolPermiso; }
  get refreshToken() { return this.client.refreshToken; } 

  async $queryRaw<T = unknown>(query: Prisma.Sql): Promise<T> {
    return this.client.$queryRaw<T>(query);
  }

  async $transaction<T>(fn: (tx: any) => Promise<T>): Promise<T> {
    return this.client.$transaction(fn);
  }

  async onModuleInit() {
    const adapter = new PrismaPg({ connectionString: process.env.DATABASE_URL });
    this.client = new PrismaClient({ adapter });
    await this.client.$connect();
  }

  async onModuleDestroy() {
    await this.client.$disconnect();
  }
}
