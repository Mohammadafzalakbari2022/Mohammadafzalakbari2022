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
import { ShopRegistryService } from './shop-registry.service';
import { ShopUserLimitsService } from './shop-user-limits.service';

@Controller('shop')
export class ShopUsersController {
  constructor(
    private readonly registry: ShopRegistryService,
    private readonly userLimits: ShopUserLimitsService,
  ) {}

  private ownerOrThrow(req: Request): PrideAccessPayload {
    const u = (req as Request & { user?: PrideAccessPayload }).user;
    if (!u?.is_shop_owner) throw new ForbiddenException('owner only');
    return u;
  }

  @Get('user-limits')
  @UseGuards(JwtAuthGuard)
  async limits(@Req() req: Request) {
    const u = (req as Request & { user?: PrideAccessPayload }).user;
    if (!u?.shop_id) throw new ForbiddenException('unauthorized');
    return this.userLimits.getLimitsForShop(u.shop_id, u.is_shop_owner);
  }

  @Get('users')
  @UseGuards(JwtAuthGuard)
  async list(@Req() req: Request) {
    const u = (req as Request & { user?: PrideAccessPayload }).user;
    if (!u?.shop_id) throw new ForbiddenException('unauthorized');
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
    await this.userLimits.assertCanAddUser(u.shop_id);
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
