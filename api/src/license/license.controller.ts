import {
  Body,
  Controller,
  Get,
  HttpCode,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { BillingService } from '../billing/billing.service';
import { LicenseService } from './license.service';
import { LicenseStatusDto } from './license.types';

@Controller('license')
export class LicenseController {
  constructor(
    private readonly licenseService: LicenseService,
    private readonly billing: BillingService,
  ) {}

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

  /** Published Hesab Pay billing instructions for all shop users. */
  @Get('billing-info')
  @UseGuards(JwtAuthGuard)
  billingInfo(
    @Query('locale') locale?: string,
  ) {
    return this.billing.getPublishedBillingInfo(locale);
  }

  /** Owner submits Hesab Pay payment proof. */
  @Post('payment-claims')
  @HttpCode(200)
  @UseGuards(JwtAuthGuard)
  submitPaymentClaim(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body()
    body: {
      plan_tier?: unknown;
      transaction_id?: unknown;
      payer_phone?: unknown;
      notes?: unknown;
    },
  ) {
    return this.billing.submitPaymentClaim(req.user, body ?? {});
  }

  /** Owner views own shop payment claim history. */
  @Get('payment-claims')
  @UseGuards(JwtAuthGuard)
  listPaymentClaims(@Req() req: Request & { user: PrideAccessPayload }) {
    this.billing.assertOwner(req.user);
    return this.billing.listShopPaymentClaims(req.user.shop_id);
  }
}
