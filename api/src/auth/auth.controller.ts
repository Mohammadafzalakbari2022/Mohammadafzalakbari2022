import { Body, Controller, HttpCode, Post } from '@nestjs/common';

import { AuthService } from './auth.service';
import type { LoginRequestBody, LoginResponseBody } from './auth.types';

@Controller('auth')
export class AuthController {
  constructor(private readonly authService: AuthService) {}

  /** `plan-04` — online login (JWT access token). */
  @Post('login')
  @HttpCode(200)
  async login(
    @Body() body: LoginRequestBody,
  ): Promise<LoginResponseBody> {
    return this.authService.login(body ?? ({} as LoginRequestBody));
  }
}
