import { Body, Controller, HttpCode, Post } from '@nestjs/common';

import { AuthService } from './auth.service';
import type { LoginRequestBody, LoginResponseBody } from './auth.types';

/**
 * `plan-04` — `POST /shop/join` (shop bootstrap).
 * In-memory MVP: same contract as `POST /auth/login` (shop-scoped username + password).
 * When invite- or code-based join is specified in plans, extend here without changing login.
 */
@Controller('shop')
export class ShopJoinController {
  constructor(private readonly authService: AuthService) {}

  @Post('join')
  @HttpCode(200)
  async join(
    @Body() body: LoginRequestBody,
  ): Promise<LoginResponseBody> {
    return this.authService.login(body ?? ({} as LoginRequestBody));
  }
}
