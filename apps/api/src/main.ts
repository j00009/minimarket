
  import 'dotenv/config';
  import { ValidationPipe } from '@nestjs/common';
  import { NestFactory } from '@nestjs/core';
  import { DocumentBuilder, SwaggerModule } from '@nestjs/swagger';
  import { AppModule } from './app.module';

  async function bootstrap() {
    const app = await NestFactory.create(AppModule);

    const apiPort = process.env.PORT ?? 3000;

    const allowedOrigins = [
      `http://localhost:${process.env.FRONTEND_PORT ?? 5173}`,
      `http://127.0.0.1:${process.env.FRONTEND_PORT ?? 5173}`,
      process.env.FRONTEND_URL,
    ].filter((origin): origin is string => Boolean(origin));

    app.enableCors({
      origin: allowedOrigins,
      methods: ['GET', 'POST', 'PATCH', 'DELETE', 'OPTIONS'],
      allowedHeaders: ['Content-Type', 'Authorization'],
    });

    app.useGlobalPipes(
      new ValidationPipe({
        whitelist: true,
        transform: true,
      }),
    );

    app.setGlobalPrefix('api');

    const swaggerConfig = new DocumentBuilder()
      .setTitle('Minimarket API')
      .setDescription(
        'Documentacion de la API para auth, usuarios, categorias, proveedores, productos, movimientos y ventas.',
      )
      .setVersion('1.0')
      .addServer(
        process.env.API_URL ?? `http://localhost:${apiPort}`,
        'API server',
      )
      .addTag('health')
      .addTag('categorias')
      .addTag('proveedores')
      .addTag('productos')
      .addTag('movimientos')
      .addTag('ventas')
      .addTag('auth')
      .addTag('usuarios')
      .addBearerAuth()
      .build();

    const swaggerDocument = SwaggerModule.createDocument(app, swaggerConfig);

    SwaggerModule.setup('docs', app, swaggerDocument);

    await app.listen(apiPort, '0.0.0.0');

    console.log(`Minimarket API disponible en el puerto ${apiPort}`);
  }

  bootstrap();
