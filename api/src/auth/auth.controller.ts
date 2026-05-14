import { Body, Controller, HttpCode, Post } from '@nestjs/common';

import { PasswordResetService } from '../shop/password-reset.service';
import { AuthService } from './auth.service';
import type { LoginRequestBody, LoginResponseBody } from './auth.types';

@Controller('auth')
export class AuthController {
  constructor(
    private readonly authService: AuthService,
    private readonly passwordResets: PasswordResetService,
  ) {}

  /** `plan-04` — online login (JWT access token). */
  @Post('login')
  @HttpCode(200)
  async login(
    @Body() body: LoginRequestBody,
  ): Promise<LoginResponseBody> {
    return this.authService.login(body ?? ({} as LoginRequestBody));
  }

  /**
   * Queue a password reset for support / developer portal (`plan-18`).
   * Always returns 200 when JSON is valid (no user enumeration).
   */
  @Post('password-reset-request')
  @HttpCode(200)
  async passwordResetRequest(
    @Body() body: { shop_id?: string; username?: string },
  ): Promise<{ ok: true }> {
    await this.passwordResets.createRequest(
      body?.shop_id ?? '',
      body?.username ?? '',
    );
    return { ok: true };
  }
}
