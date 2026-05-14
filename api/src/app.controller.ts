import { Controller, Get } from '@nestjs/common';
import { AppService } from './app.service';

/** Afghan Pride API (plan-04). */
@Controller()
export class AppController {
  constructor(private readonly appService: AppService) {}

  @Get()
  getHello(): string {
    return this.appService.getHello();
  }

  /** Used by the Flutter app (`GET {API_BASE_URL}/health`). */
  @Get('health')
  health(): { status: string; service: string } {
    return { status: 'ok', service: 'pride-api' };
  }
}
