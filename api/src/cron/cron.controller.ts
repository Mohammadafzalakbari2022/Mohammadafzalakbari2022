import {
  Controller,
  Get,
  Headers,
  UnauthorizedException,
} from '@nestjs/common';

import { LicenseExpiryPushCronService } from '../push/license-expiry-push.cron.service';

/**
 * Vercel Cron Jobs hit these routes on a schedule (see `api/vercel.json`).
 * Vercel sends `Authorization: Bearer ${CRON_SECRET}` when `CRON_SECRET` is set.
 */
@Controller('api/cron')
export class CronController {
  constructor(
    private readonly licenseExpiryPush: LicenseExpiryPushCronService,
  ) {}

  @Get('license-expiry')
  async licenseExpiry(
    @Headers('authorization') authorization?: string,
  ): Promise<{ ok: true; reminded: number }> {
    const secret = process.env.CRON_SECRET?.trim();
    if (!secret || authorization !== `Bearer ${secret}`) {
      throw new UnauthorizedException();
    }
    const reminded = await this.licenseExpiryPush.runReminders();
    return { ok: true, reminded };
  }
}
