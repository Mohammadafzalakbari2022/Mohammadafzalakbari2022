import {
  BadRequestException,
  Body,
  Controller,
  HttpCode,
  HttpStatus,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import { randomUUID } from 'crypto';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { PrismaService } from '../prisma/prisma.service';

const ALLOWED_PLATFORMS = new Set(['android', 'ios', 'web', 'unknown']);

@Controller('devices')
export class DevicesController {
  constructor(private readonly prisma: PrismaService) {}

  /** Register or replace push notification token for the current JWT user (`plan-22`). */
  @Post('push-token')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async registerPushToken(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: unknown,
  ) {
    const shopId = req.user.shop_id;
    const userId = req.user.sub;
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      throw new BadRequestException('body must be an object');
    }
    const m = body as Record<string, unknown>;
    const token = String(m.token ?? m.fcm_token ?? '').trim();
    const platformRaw = String(m.platform ?? 'unknown').trim().toLowerCase();
    const platform = ALLOWED_PLATFORMS.has(platformRaw)
      ? platformRaw
      : 'unknown';
    if (!token) {
      throw new BadRequestException('token is required');
    }
    await this.prisma.shopPushToken.upsert({
      where: {
        shopId_userId_platform: { shopId, userId, platform },
      },
      create: {
        id: randomUUID(),
        shopId,
        userId,
        platform,
        token,
      },
      update: { token },
    });
    return { ok: true };
  }
}
