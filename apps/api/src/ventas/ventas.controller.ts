import { Controller, Get, Post, Body, Param, ParseIntPipe, Delete, UseGuards } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiForbiddenResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { VentasService } from './ventas.service';
import { CreateVentaDto } from './dto/create-venta.dto';
import { ErrorResponseDto, VentaResponseDto } from '../docs/openapi-dtos';
import { CurrentUser } from '../auth/current-user.decorator';
import { AuthUser, ROLES } from '../auth/roles';
import { JwtAuthGuard } from '../auth/jwt.guard';
import { Roles } from '../auth/roles.decorator';

@Controller('ventas')
@ApiTags('ventas')
@ApiBearerAuth()
@UseGuards(JwtAuthGuard) // Activa la validación del token JWT para todas las rutas de este controlador
export class VentasController {
  constructor(private readonly ventasService: VentasService) {}

  @Post()
  @ApiOperation({ summary: 'Crear venta' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiCreatedResponse({ description: 'Venta creada y stock descontado', type: VentaResponseDto })
  @ApiBadRequestResponse({ description: 'Stock insuficiente o datos invalidos', type: ErrorResponseDto })
  @ApiNotFoundResponse({ description: 'Producto no encontrado', type: ErrorResponseDto })
  create(@Body() dto: CreateVentaDto, @CurrentUser() user: AuthUser) {
    return this.ventasService.create(dto, user);
  }

  @Get()
  @ApiOperation({ summary: 'Listar ventas' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiOkResponse({ description: 'Listado de ventas ordenadas por fecha descendente', type: [VentaResponseDto] })
  findAll(@CurrentUser() user: AuthUser) {
    return this.ventasService.findAll(user);
  }

  @Get('admin/all')
  @Roles(ROLES.SUPER_ADMIN, ROLES.ADMIN)
  @ApiOperation({ summary: 'Listar TODAS las ventas de todos los usuarios (solo ADMIN/SUPER_ADMIN)' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiForbiddenResponse({ description: 'El usuario autenticado no tiene rol ADMIN o SUPER_ADMIN', type: ErrorResponseDto })
  @ApiOkResponse({ description: 'Listado de ventas de todos los usuarios, ordenadas por fecha descendente', type: [VentaResponseDto] })
  findAllAdmin() {
    return this.ventasService.findAllAdmin();
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener venta por ID' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Venta encontrada', type: VentaResponseDto })
  @ApiNotFoundResponse({ description: 'Venta no encontrada', type: ErrorResponseDto })
  findOne(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: AuthUser) {
    return this.ventasService.findOne(id, user);
  }

  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar venta y restaurar stock' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Venta eliminada y stock restaurado', type: VentaResponseDto })
  @ApiNotFoundResponse({ description: 'Venta no encontrada', type: ErrorResponseDto })
  remove(@Param('id', ParseIntPipe) id: number, @CurrentUser() user: AuthUser) {
    return this.ventasService.remove(id, user);
  }
}