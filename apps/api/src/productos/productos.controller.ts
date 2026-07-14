import { Controller, Get, Post, Body, Patch, Param, Delete, ParseIntPipe, Query } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiConflictResponse,
  ApiCreatedResponse,
  ApiNotFoundResponse,
  ApiOkResponse,
  ApiOperation,
  ApiParam,
  ApiQuery,
  ApiTags,
  ApiUnauthorizedResponse,
} from '@nestjs/swagger';
import { ProductosService } from './productos.service';
import { CreateProductoDto } from './dto/create-producto.dto';
import { UpdateProductoDto } from './dto/update-producto.dto';
import { ErrorResponseDto, ProductoResponseDto, ProductosPaginatedResponseDto } from '../docs/openapi-dtos';
import { Public } from '../auth/public.decorator';

@Controller('productos')
@ApiTags('productos')
export class ProductosController {
  constructor(private readonly productosService: ProductosService) {}

  @Post()
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Crear producto' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiCreatedResponse({ description: 'Producto creado', type: ProductoResponseDto })
  @ApiBadRequestResponse({ description: 'Categoria, proveedor o datos invalidos', type: ErrorResponseDto })
  create(@Body() dto: CreateProductoDto) {
    return this.productosService.create(dto);
  }

  @Public()
  @Get()
  @ApiOperation({ summary: 'Listar productos con busqueda, filtros y paginacion' })
  @ApiQuery({ name: 'q', required: false, description: 'Busca por nombre con pg_trgm, codigo de barra exacto o ID', example: 'coca' })
  @ApiQuery({ name: 'nombre', required: false, description: 'Alias historico de q', example: 'coca' })
  @ApiQuery({ name: 'categoriaId', required: false, type: Number, example: 1 })
  @ApiQuery({ name: 'proveedorId', required: false, type: Number, example: 1 })
  @ApiQuery({ name: 'stockBajo', required: false, type: Boolean, example: false })
  @ApiQuery({ name: 'precioMin', required: false, type: Number, example: 500 })
  @ApiQuery({ name: 'precioMax', required: false, type: Number, example: 15000 })
  @ApiQuery({ name: 'stockMin', required: false, type: Number, example: 1 })
  @ApiQuery({ name: 'stockMax', required: false, type: Number, example: 200 })
  @ApiQuery({ name: 'page', required: false, type: Number, example: 1, description: 'Pagina actual, minimo 1' })
  @ApiQuery({ name: 'limit', required: false, type: Number, example: 48, description: 'Cantidad por pagina, maximo 100' })
  @ApiOkResponse({ description: 'Productos paginados con metadatos', type: ProductosPaginatedResponseDto })
  findAll(
    @Query('q') q?: string,
    @Query('nombre') nombre?: string,
    @Query('categoriaId') categoriaId?: string,
    @Query('proveedorId') proveedorId?: string,
    @Query('stockBajo') stockBajo?: string,
    @Query('precioMin') precioMin?: string,
    @Query('precioMax') precioMax?: string,
    @Query('stockMin') stockMin?: string,
    @Query('stockMax') stockMax?: string,
    @Query('page') page?: string,
    @Query('limit') limit?: string,
  ) {
    return this.productosService.findAll({
      q: q ?? nombre,
      categoriaId: categoriaId ? +categoriaId : undefined,
      proveedorId: proveedorId ? +proveedorId : undefined,
      stockBajo: stockBajo === 'true',
      precioMin: precioMin ? +precioMin : undefined,
      precioMax: precioMax ? +precioMax : undefined,
      stockMin: stockMin ? +stockMin : undefined,
      stockMax: stockMax ? +stockMax : undefined,
      page: page ? +page : undefined,
      limit: limit ? +limit : undefined,
    });
  }

  @Public()
  @Get('alertas/stock-bajo')
  @ApiOperation({ summary: 'Listar productos con stock bajo' })
  @ApiOkResponse({ description: 'Productos cuyo stock es menor o igual al stock minimo', type: [ProductoResponseDto] })
  getStockBajo() {
    return this.productosService.getStockBajo();
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Obtener producto por ID' })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Producto encontrado', type: ProductoResponseDto })
  @ApiNotFoundResponse({ description: 'Producto no encontrado', type: ErrorResponseDto })
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.productosService.findOne(id);
  }

  @ApiBearerAuth()
  @Patch(':id')
  @ApiOperation({ summary: 'Actualizar producto' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Producto actualizado', type: ProductoResponseDto })
  @ApiBadRequestResponse({ description: 'Categoria, proveedor o datos invalidos', type: ErrorResponseDto })
  @ApiNotFoundResponse({ description: 'Producto no encontrado', type: ErrorResponseDto })
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateProductoDto) {
    return this.productosService.update(id, dto);
  }

  @ApiBearerAuth()
  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar producto' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Producto eliminado', type: ProductoResponseDto })
  @ApiNotFoundResponse({ description: 'Producto no encontrado', type: ErrorResponseDto })
  @ApiConflictResponse({ description: 'No se puede eliminar si tiene ventas o movimientos asociados', type: ErrorResponseDto })
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.productosService.remove(id);
  }
}
