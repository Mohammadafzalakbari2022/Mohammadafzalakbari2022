import { Injectable } from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import { LicenseService } from '../license/license.service';
import type { UserRow } from '../shop/shop-registry.service';
import type { PrideAccessPayload } from './jwt-payload.interface';
import type { LoginResponseBody } from './auth.types';

@Injectable()
export class LoginResponseFactory {
  constructor(
    private readonly jwt: JwtService,
    private readonly licenseService: LicenseService,
  ) {}

  async fromUser(user: UserRow): Promise<LoginResponseBody> {
    await this.licenseService.recordTrialStartIfNeeded(user.shop_id);
    const license_snapshot = await this.licenseService.getStatusForShop(
      user.shop_id,
    );
    const payload: PrideAccessPayload = {
      sub: user.id,
      shop_id: user.shop_id,
      username: user.username,
      is_shop_owner: user.is_shop_owner,
    };
    const access_token = await this.jwt.signAsync(payload);
    return {
      access_token,
      refresh_token: null,
      license_snapshot,
      user: {
        id: user.id,
        shop_id: user.shop_id,
        username: user.username,
        is_shop_owner: user.is_shop_owner,
      },
    };
  }
}
