import { Body, Controller, Get, HttpCode, Post, Req, UseGuards } from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { LicenseService } from './license.service';
import { LicenseStatusDto } from './license.types';

@Controller('license')
export class LicenseController {
  constructor(private readonly licenseService: LicenseService) {}

  /** Contract: `plan-04` — `GET /license/status` (shop from JWT). */
  @Get('status')
  @UseGuards(JwtAuthGuard)
  status(@Req() req: Request & { user: PrideAccessPayload }): Promise<LicenseStatusDto> {
    return this.licenseService.getStatusForShop(req.user.shop_id);
  }

  /** `plan-04` — `POST /license/redeem` (shop from JWT). */
  @Post('redeem')
  @HttpCode(200)
  @UseGuards(JwtAuthGuard)
  redeem(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: { code?: string },
  ): Promise<LicenseStatusDto> {
    return this.licenseService.redeemForShop(req.user.shop_id, body?.code ?? '');
  }
}
