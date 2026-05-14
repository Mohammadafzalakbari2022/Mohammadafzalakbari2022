import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { SyncService } from './sync.service';

@Controller('sync')
export class SyncController {
  constructor(private readonly sync: SyncService) {}

  @Post('push')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async push(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: unknown,
  ) {
    const shopId = req.user.shop_id;
    const mutations = this.sync.validateMutations(body);
    return this.sync.push(shopId, mutations);
  }

  @Get('pull')
  @UseGuards(JwtAuthGuard)
  async pull(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('cursor') cursor?: string,
  ) {
    const shopId = req.user.shop_id;
    return this.sync.pull(shopId, cursor);
  }
}
