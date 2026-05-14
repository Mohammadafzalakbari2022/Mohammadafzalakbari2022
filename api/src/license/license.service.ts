import { BadRequestException, Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';
import { licenseStatusDtoFromRow } from './license-status.helper';
import type { LicenseStatusDto } from './license.types';

/**
 * Per-shop license rows in Postgres (`plan-04` / `plan-06`).
 */
@Injectable()
export class LicenseService {
  constructor(private readonly prisma: PrismaService) {}

  async getStatusForShop(shopId: string, now: Date = new Date()): Promise<LicenseStatusDto> {
    const row = await this.prisma.shopLicense.findUnique({ where: { shopId } });
    if (!row) {
      const created = await this.bootstrapTrialLicense(shopId, now);
      return licenseStatusDtoFromRow(created, now);
    }
    return licenseStatusDtoFromRow(
      { statusStored: row.statusStored, expiresAt: row.expiresAt },
      now,
    );
  }

  /** First successful login may start trial clock (`plan-04` trial rule). */
  async recordTrialStartIfNeeded(shopId: string, now: Date = new Date()): Promise<void> {
    const row = await this.prisma.shopLicense.findUnique({ where: { shopId } });
    if (!row || row.trialStartedAt != null) return;
    const trialEnd = new Date(now.getTime());
    trialEnd.setUTCDate(trialEnd.getUTCDate() + 15);
    await this.prisma.shopLicense.update({
      where: { shopId },
      data: {
        trialStartedAt: now,
        expiresAt: trialEnd,
        statusStored: 'trial_active',
      },
    });
  }

  private async bootstrapTrialLicense(
    shopId: string,
    now: Date,
  ): Promise<{ statusStored: string; expiresAt: Date }> {
    const trialEnd = new Date(now.getTime());
    trialEnd.setUTCDate(trialEnd.getUTCDate() + 15);
    const created = await this.prisma.shopLicense.create({
      data: {
        shopId,
        statusStored: 'trial_active',
        expiresAt: trialEnd,
        trialStartedAt: now,
      },
    });
    return { statusStored: created.statusStored, expiresAt: created.expiresAt };
  }

  /** `POST /license/redeem` — non-empty code sets paid `active` +365d (stub until real codes). */
  async redeemForShop(
    shopId: string,
    code: string,
    now: Date = new Date(),
  ): Promise<LicenseStatusDto> {
    const trimmed = code?.trim() ?? '';
    if (!trimmed) {
      throw new BadRequestException('activation code is required');
    }
    const exp = new Date(now.getTime());
    exp.setUTCDate(exp.getUTCDate() + 365);
    await this.prisma.shopLicense.upsert({
      where: { shopId },
      create: {
        shopId,
        statusStored: 'active',
        expiresAt: exp,
        trialStartedAt: now,
      },
      update: {
        statusStored: 'active',
        expiresAt: exp,
      },
    });
    return this.getStatusForShop(shopId, now);
  }
}
