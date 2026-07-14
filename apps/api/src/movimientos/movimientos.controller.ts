import { Controller, Get, Post, Body, Param, ParseIntPipe, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { MovimientosService } from './movimientos.service';
import { CreateMovimientoDto } from './dto/create-movimiento.dto';
import { ErrorResponseDto, MovimientoResponseDto } from '../docs/openapi-dtos';

@Controller('movimientos')
@ApiTags('movimientos')
@ApiBearerAuth()
export class MovimientosController {
  constructor(private readonly movimientosService: MovimientosService) {}

  @Post()
  @ApiOperation({ summary: 'Crear movimiento de stock' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiCreatedResponse({ description: 'Movimiento creado y stock actualizado', type: MovimientoResponseDto })
  @ApiBadRequestResponse({ description: 'Stock insuficiente o datos invalidos', type: ErrorResponseDto })
  @ApiNotFoundResponse({ description: 'Producto no encontrado', type: ErrorResponseDto })
  create(@Body() dto: CreateMovimientoDto) {
    return this.movimientosService.create(dto);
  }

  @Get()
  @ApiOperation({ summary: 'Listar movimientos de stock' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiQuery({ name: 'productoId', required: false, type: Number, description: 'Filtra por producto', example: 1 })
  @ApiOkResponse({ description: 'Listado de movimientos ordenados por fecha descendente', type: [MovimientoResponseDto] })
  findAll(@Query('productoId') productoId?: string) {
    return this.movimientosService.findAll(productoId ? +productoId : undefined);
  }

  @Get(':id')
  @ApiOperation({ summary: 'Obtener movimiento por ID' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Movimiento encontrado', type: MovimientoResponseDto })
  @ApiNotFoundResponse({ description: 'Movimiento no encontrado', type: ErrorResponseDto })
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.movimientosService.findOne(id);
  }
}
