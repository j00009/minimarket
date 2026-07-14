import { Body, Controller, Get, Post, UseGuards } from '@nestjs/common';
import {
  ApiBadRequestResponse,
  ApiBearerAuth,
  ApiOkResponse,
  ApiOperation,
  ApiUnauthorizedResponse,
  ApiTags,
} from '@nestjs/swagger';
import { CurrentUser } from './current-user.decorator';
import { Public } from './public.decorator';
import { AuthService } from './auth.service';
import { LoginDto } from './dto/login.dto';
import { SignUpDto } from './dto/signup.dto';
import { RefreshTokenDto } from './dto/refresh-token.dto';
import { AuthUser } from './roles';
import { AuthUserDto, ErrorResponseDto, LoginResponseDto } from '../docs/openapi-dtos';

@Controller('auth')
@ApiTags('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  @Public()
  @Post('signup')
  @ApiOperation({ summary: 'Registrar un nuevo usuario publico' })
  @ApiOkResponse({ description: 'Usuario registrado correctamente', type: AuthUserDto })
  @ApiBadRequestResponse({ description: 'Datos invalidos', type: ErrorResponseDto })
  signup(@Body() dto: SignUpDto) {
    return this.authService.signup(dto);
  }

  @Public()
  @Post('login')
  @ApiOperation({ summary: 'Iniciar sesion' })
  @ApiOkResponse({ description: 'Sesion iniciada correctamente', type: LoginResponseDto })
  @ApiBadRequestResponse({ description: 'Datos invalidos', type: ErrorResponseDto })
  @ApiUnauthorizedResponse({ description: 'Credenciales invalidas', type: ErrorResponseDto })
  login(@Body() dto: LoginDto) {
    return this.authService.login(dto);
  }

  @Get('me')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Obtener usuario autenticado' })
  @ApiOkResponse({ description: 'Usuario autenticado actual', type: AuthUserDto })
  @ApiUnauthorizedResponse({ description: 'Token invalido o sesion expirada', type: ErrorResponseDto })
  me(@CurrentUser() user: AuthUser) {
    return this.authService.me(user);
  }

  @Public()
  @Post('refresh')
  @ApiOperation({ summary: 'Renovar access y refresh token (rotacion)' })
  @ApiOkResponse({ description: 'Nuevos access_token y refresh_token emitidos', type: LoginResponseDto })
  @ApiUnauthorizedResponse({ description: 'Refresh token invalido, expirado o revocado', type: ErrorResponseDto })
  refresh(@Body() dto: RefreshTokenDto) {
    return this.authService.refresh(dto.refresh_token);
  }

  @Post('logout')
  @ApiBearerAuth()
  @ApiOperation({ summary: 'Cerrar sesion revocando el refresh token' })
  @ApiOkResponse({ description: 'Sesion cerrada', schema: { example: { ok: true } } })
  @ApiUnauthorizedResponse({ description: 'Token invalido o sesion expirada', type: ErrorResponseDto })
  logout(@CurrentUser() user: AuthUser, @Body() dto: RefreshTokenDto) {
    return this.authService.logout(user.sub, dto.refresh_token);
  }
}

