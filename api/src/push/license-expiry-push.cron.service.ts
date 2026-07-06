import { Injectable, Logger } from '@nestjs/common';
import { Cron } from '@nestjs/schedule';

import { licenseStatusDtoFromRow } from '../license/license-status.helper';
import { PrismaService } from '../prisma/prisma.service';
import { PushDispatchService } from './push-dispatch.service';

const REMINDER_DAYS = 7;

function utcDayString(d: Date): string {
  return d.toISOString().slice(0, 10);
}

function daysBetweenCeil(from: Date, to: Date): number {
  const ms = to.getTime() - from.getTime();
  return Math.max(0, Math.ceil(ms / 86_400_000));
}

@Injectable()
export class LicenseExpiryPushCronService {
  private readonly logger = new Logger(LicenseExpiryPushCronService.name);

  constructor(
    private readonly prisma: PrismaService,
    private readonly pushDispatch: PushDispatchService,
  ) {}

  /** 09:00 UTC daily — license dates are day-granularity; avoids noisy hourly runs. */
  @Cron('0 9 * * *')
  async remindExpiringLicenses(): Promise<number> {
    return this.runReminders();
  }

  /** Shared by in-process cron (local) and Vercel Cron HTTP route. */
  async runReminders(): Promise<number> {
    let reminded = 0;
    const now = new Date();
    const dayUtc = utcDayString(now);
    const horizon = new Date(now.getTime() + REMINDER_DAYS * 86_400_000);

    const rows = await this.prisma.shopLicense.findMany({
      where: {
        expiresAt: { gt: now, lte: horizon },
        shop: { disabledAt: null },
      },
      include: { shop: { select: { id: true, name: true } } },
    });

    for (const row of rows) {
      const dto = licenseStatusDtoFromRow(
        { statusStored: row.statusStored, expiresAt: row.expiresAt },
        now,
      );
      if (dto.status === 'expired') continue;

      const existing = await this.prisma.licenseExpiryPushDay.findFirst({
        where: { shopId: row.shopId, dayUtc },
      });
      if (existing) continue;

      const daysLeft = daysBetweenCeil(now, row.expiresAt);
      const shopName = row.shop.name.trim() || row.shopId;
      const title = 'License expiring soon';
      const body = `${shopName}: license expires in ${daysLeft} day(s) (${row.expiresAt.toISOString().slice(0, 10)} UTC). Open the app to renew.`;

      const r = await this.pushDispatch.sendToShop(row.shopId, title, body, {
        type: 'license_expiring',
        shop_id: row.shopId,
        expires_at: row.expiresAt.toISOString(),
        days_remaining: String(daysLeft),
      });

      if (r.reason === 'fcm_not_configured') {
        this.logger.debug('FCM not configured; skip license reminder dedup');
        continue;
      }

      try {
        await this.prisma.licenseExpiryPushDay.create({
          data: { shopId: row.shopId, dayUtc },
        });
        reminded += 1;
      } catch (e) {
        this.logger.warn(`license expiry dedup insert failed for ${row.shopId}: ${e}`);
      }
    }
    return reminded;
  }
}
