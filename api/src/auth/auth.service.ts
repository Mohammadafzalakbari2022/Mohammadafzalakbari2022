import {
  BadRequestException,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';

import { ShopRegistryService } from '../shop/shop-registry.service';
import type { LoginRequestBody, LoginResponseBody } from './auth.types';
import { LoginResponseFactory } from './login-response.factory';

@Injectable()
export class AuthService {
  constructor(
    private readonly shopRegistry: ShopRegistryService,
    private readonly loginResponse: LoginResponseFactory,
  ) {}

  async login(body: LoginRequestBody): Promise<LoginResponseBody> {
    const username = body.username?.trim() ?? '';
    const password = body.password ?? '';
    const shopIdRaw = body.shop_id?.trim() ?? '';

    if (!username || !password) {
      throw new BadRequestException('username and password are required');
    }

    const user = await this.shopRegistry.verifyLogin(
      shopIdRaw.length > 0 ? shopIdRaw : undefined,
      username,
      password,
    );
    if (!user) {
      throw new UnauthorizedException('Invalid shop, username, or password');
    }
    return this.loginResponse.fromUser(user);
  }

  /** Self-service password change for the signed-in shop user. */
  async changePassword(
    shopId: string,
    userId: string,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    const current = currentPassword ?? '';
    const next = newPassword ?? '';
    if (!current || !next) {
      throw new BadRequestException(
        'current_password and new_password are required',
      );
    }
    if (next.length < 6) {
      throw new BadRequestException('new_password must be at least 6 characters');
    }
    const ok = await this.shopRegistry.verifyUserPassword(
      shopId,
      userId,
      current,
    );
    if (!ok) {
      throw new UnauthorizedException('current password is incorrect');
    }
    await this.shopRegistry.setUserPasswordPlain(shopId, userId, next);
  }
}
