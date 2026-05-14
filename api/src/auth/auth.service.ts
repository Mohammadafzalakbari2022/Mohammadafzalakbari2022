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
}
