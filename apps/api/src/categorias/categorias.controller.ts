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
import { CategoriasService } from './categorias.service';
import { CreateCategoriaDto } from './dto/create-categoria.dto';
import { UpdateCategoriaDto } from './dto/update-categoria.dto';
import { CategoriaDetailDto, CategoriaListItemDto, CategoriaResponseDto, ErrorResponseDto } from '../docs/openapi-dtos';
import { Public } from '../auth/public.decorator';

@Controller('categorias')
@ApiTags('categorias')
export class CategoriasController {
  constructor(private readonly categoriasService: CategoriasService) {}

  @Post()
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Crear categoria' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiCreatedResponse({ description: 'Categoria creada', type: CategoriaResponseDto })
  @ApiBadRequestResponse({ description: 'Datos invalidos', type: ErrorResponseDto })
  @ApiConflictResponse({ description: 'La categoria ya existe', type: ErrorResponseDto })
  create(@Body() dto: CreateCategoriaDto) {
    return this.categoriasService.create(dto);
  }

  @Public()
  @Get()
  @ApiOperation({ summary: 'Listar categorias' })
  @ApiQuery({ name: 'nombre', required: false, description: 'Filtra por nombre', example: 'bebidas' })
  @ApiOkResponse({ description: 'Listado de categorias ordenadas por nombre', type: [CategoriaListItemDto] })
  findAll(@Query('nombre') nombre?: string) {
    return this.categoriasService.findAll(nombre);
  }

  @Public()
  @Get(':id')
  @ApiOperation({ summary: 'Obtener categoria por ID' })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Categoria encontrada con productos asociados', type: CategoriaDetailDto })
  @ApiNotFoundResponse({ description: 'Categoria no encontrada', type: ErrorResponseDto })
  findOne(@Param('id', ParseIntPipe) id: number) {
    return this.categoriasService.findOne(id);
  }

  @ApiBearerAuth()
  @Patch(':id')
  @ApiOperation({ summary: 'Actualizar categoria' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Categoria actualizada', type: CategoriaResponseDto })
  @ApiBadRequestResponse({ description: 'Datos invalidos', type: ErrorResponseDto })
  @ApiNotFoundResponse({ description: 'Categoria no encontrada', type: ErrorResponseDto })
  update(@Param('id', ParseIntPipe) id: number, @Body() dto: UpdateCategoriaDto) {
    return this.categoriasService.update(id, dto);
  }

  @ApiBearerAuth()
  @Delete(':id')
  @ApiOperation({ summary: 'Eliminar categoria' })
  @ApiUnauthorizedResponse({ description: 'Token ausente o invalido', type: ErrorResponseDto })
  @ApiParam({ name: 'id', type: Number, example: 1 })
  @ApiOkResponse({ description: 'Categoria eliminada', type: CategoriaResponseDto })
  @ApiNotFoundResponse({ description: 'Categoria no encontrada', type: ErrorResponseDto })
  @ApiConflictResponse({ description: 'No se puede eliminar si tiene productos asociados', type: ErrorResponseDto })
  remove(@Param('id', ParseIntPipe) id: number) {
    return this.categoriasService.remove(id);
  }
}
