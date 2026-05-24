import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { CatalogService } from './catalog.service';

@Controller('catalog')
export class CatalogController {
  constructor(private readonly catalog: CatalogService) {}

  /** Legacy unauthenticated stub — returns defaults only. */
  @Get('public')
  publicCatalogStub() {
    return this.catalog.publicCatalogStub();
  }

  /** Authenticated public directory (`plan-14`). Requires caller sharing enabled. */
  @Get('public/feed')
  @UseGuards(JwtAuthGuard)
  publicCatalogFeed(@Req() req: Request & { user: PrideAccessPayload }) {
    return this.catalog.listPublicCatalog(req.user.shop_id);
  }

  @Post('share-settings')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async shareSettings(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: unknown,
  ) {
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      return { ok: false, message: 'body must be an object' };
    }
    const m = body as Record<string, unknown>;
    const raw = m.sharing_enabled ?? m.sharingEnabled;
    if (typeof raw !== 'boolean') {
      return { ok: false, message: 'sharing_enabled must be a boolean' };
    }
    return this.catalog.setSharingEnabled(req.user.shop_id, raw);
  }

  @Post('items/:internalId/share')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async shareItem(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('internalId') internalId: string,
    @Body() body: unknown,
  ) {
    return this.catalog.setItemShared(req.user.shop_id, internalId.trim(), body);
  }
}
