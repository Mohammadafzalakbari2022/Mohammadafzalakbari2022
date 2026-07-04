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

  /**
   * `POST /license/redeem` — `PRIDE_LEGACY_REDEEM_CODES` (default includes `pilot-2026`)
   * keeps dev/e2e behaviour; otherwise requires a row in `activation_codes`.
   */
  async redeemForShop(
    shopId: string,
    code: string,
    now: Date = new Date(),
  ): Promise<LicenseStatusDto> {
    const trimmed = code?.trim() ?? '';
    if (!trimmed) {
      throw new BadRequestException('activation code is required');
    }

    const legacyRaw = process.env.PRIDE_LEGACY_REDEEM_CODES;
    const legacy = new Set(
      legacyRaw
        .split(',')
        .map((s) => s.trim())
        .filter((s) => s.length > 0),
    );
    if (legacy.has(trimmed)) {
      return this.applyFixedTermActivation(shopId, now, 365);
    }

    await this.prisma.$transaction(async (tx) => {
      const row = await tx.activationCode.findUnique({
        where: { code: trimmed },
      });
      if (!row || row.status === 'revoked' || row.status === 'depleted') {
        throw new BadRequestException('invalid activation code');
      }
      if (row.expiresAt && row.expiresAt.getTime() < now.getTime()) {
        throw new BadRequestException('activation code expired');
      }
      if (row.assignedShopId && row.assignedShopId !== shopId) {
        throw new BadRequestException('activation code not valid for this shop');
      }
      if (row.usesCount >= row.maxUses) {
        throw new BadRequestException('activation code depleted');
      }

      const nextUses = row.usesCount + 1;
      const nextStatus = nextUses >= row.maxUses ? 'depleted' : 'active';

      await tx.activationCode.update({
        where: { id: row.id },
        data: {
          usesCount: nextUses,
          lastRedeemedShopId: shopId,
          redeemedAt: now,
          status: nextStatus,
        },
      });

      const lic = await tx.shopLicense.findUnique({ where: { shopId } });
      const base =
        !lic || lic.expiresAt.getTime() < now.getTime() ? now : lic.expiresAt;
      const newExp = new Date(base.getTime());
      newExp.setUTCDate(newExp.getUTCDate() + row.planDays);

      await tx.shopLicense.upsert({
        where: { shopId },
        create: {
          shopId,
          statusStored: 'active',
          expiresAt: newExp,
          trialStartedAt: now,
        },
        update: {
          statusStored: 'active',
          expiresAt: newExp,
        },
      });
    });

    return this.getStatusForShop(shopId, now);
  }

  private async applyFixedTermActivation(
    shopId: string,
    now: Date,
    days: number,
  ): Promise<LicenseStatusDto> {
    const exp = new Date(now.getTime());
    exp.setUTCDate(exp.getUTCDate() + days);
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
