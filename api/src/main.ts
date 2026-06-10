import { NestFactory } from '@nestjs/core';
import { NestExpressApplication } from '@nestjs/platform-express';
import { AppModule } from './app.module';

async function bootstrap() {
  const app = await NestFactory.create<NestExpressApplication>(AppModule);
  // Billing settings image is base64 in JSON (up to ~1.4 MB for a 1 MB image).
  app.useBodyParser('json', { limit: '2mb' });
  app.enableCors({ origin: true });
  const port = Number(process.env.PORT) || 3000;
  await app.listen(port, '0.0.0.0');
}
bootstrap();
