import {
  Body,
  Controller,
  HttpCode,
  Post,
  Req,
  UnauthorizedException,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { PasswordResetService } from '../shop/password-reset.service';
import { AuthService } from './auth.service';
import type { LoginRequestBody, LoginResponseBody } from './auth.types';
import { JwtAuthGuard } from './jwt-auth.guard';
import type { PrideAccessPayload } from './jwt-payload.interface';

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

  /** Change password for the authenticated user (all shop members). */
  @Post('change-password')
  @UseGuards(JwtAuthGuard)
  @HttpCode(200)
  async changePassword(
    @Req() req: Request,
    @Body()
    body: { current_password?: string; new_password?: string },
  ): Promise<{ ok: true }> {
    const u = (req as Request & { user?: PrideAccessPayload }).user;
    if (!u?.sub || !u.shop_id) {
      throw new UnauthorizedException();
    }
    await this.authService.changePassword(
      u.shop_id,
      u.sub,
      body?.current_password ?? '',
      body?.new_password ?? '',
    );
    return { ok: true };
  }
}
