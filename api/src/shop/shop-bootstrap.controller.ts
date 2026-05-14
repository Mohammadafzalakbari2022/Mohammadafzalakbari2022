import { Body, Controller, HttpCode, Post } from '@nestjs/common';

import { LoginResponseFactory } from '../auth/login-response.factory';
import { ShopRegistryService } from './shop-registry.service';

@Controller('shop')
export class ShopBootstrapController {
  constructor(
    private readonly registry: ShopRegistryService,
    private readonly loginResponse: LoginResponseFactory,
  ) {}

  /** `plan-04` — `POST /shop/create` (returns same shape as login). */
  @Post('create')
  @HttpCode(200)
  async create(
    @Body()
    body: {
      shop_name?: string;
      owner_username?: string;
      owner_password?: string;
    },
  ) {
    const { user } = await this.registry.createShopWithOwner(
      body.shop_name ?? '',
      body.owner_username ?? '',
      body.owner_password ?? '',
    );
    return this.loginResponse.fromUser(user);
  }
}
