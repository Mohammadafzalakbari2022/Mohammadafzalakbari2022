import {
  Body,
  Controller,
  Delete,
  ForbiddenException,
  Get,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { LicenseService } from '../license/license.service';
import { ShopRegistryService } from './shop-registry.service';

@Controller('shop')
export class ShopUsersController {
  constructor(
    private readonly registry: ShopRegistryService,
    private readonly license: LicenseService,
  ) {}

  private ownerOrThrow(req: Request): PrideAccessPayload {
    const u = (req as Request & { user?: PrideAccessPayload }).user;
    if (!u?.is_shop_owner) throw new ForbiddenException('owner only');
    return u;
  }

  private async assertCanAddUser(shopId: string): Promise<void> {
    const st = (await this.license.getStatusForShop(shopId)).status;
    if (st === 'expired') throw new ForbiddenException('license expired');
    const max = st === 'trial_active' ? 2 : 5;
    if ((await this.registry.countActiveUsers(shopId)) >= max) {
      throw new ForbiddenException(`user limit reached (${max})`);
    }
  }

  @Get('users')
  @UseGuards(JwtAuthGuard)
  async list(@Req() req: Request) {
    const u = this.ownerOrThrow(req);
    const rows = await this.registry.listActiveUsers(u.shop_id);
    return rows.map((x) => ({
      id: x.id,
      shop_id: x.shop_id,
      username: x.username,
      is_shop_owner: x.is_shop_owner,
    }));
  }

  @Post('users')
  @UseGuards(JwtAuthGuard)
  async add(
    @Req() req: Request,
    @Body() body: { username?: string; password?: string },
  ) {
    const u = this.ownerOrThrow(req);
    await this.assertCanAddUser(u.shop_id);
    const created = await this.registry.addMemberUser(
      u.shop_id,
      body.username ?? '',
      body.password ?? '',
    );
    return {
      id: created.id,
      shop_id: created.shop_id,
      username: created.username,
      is_shop_owner: created.is_shop_owner,
    };
  }

  @Delete('users/:userId')
  @UseGuards(JwtAuthGuard)
  async remove(@Req() req: Request, @Param('userId') userId: string) {
    const u = this.ownerOrThrow(req);
    await this.registry.softDeleteUser(u.shop_id, userId);
    return { ok: true };
  }
}
