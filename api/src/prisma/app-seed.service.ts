import { createHash, randomUUID } from 'crypto';

import { Injectable, Logger, OnModuleInit } from '@nestjs/common';

import { PrismaService } from './prisma.service';

function sha256Hex(password: string): string {
  return createHash('sha256').update(password, 'utf8').digest('hex');
}

/**
 * Idempotent dev / `PRIDE_AUTH_SEED` bootstrap after migrations (`plan-04`).
 */
@Injectable()
export class AppSeedService implements OnModuleInit {
  private readonly log = new Logger(AppSeedService.name);

  constructor(private readonly prisma: PrismaService) {}

  async onModuleInit(): Promise<void> {
    await this.run();
  }

  async run(): Promise<void> {
    const nodeEnv = process.env.NODE_ENV ?? 'development';
    const raw = process.env.PRIDE_AUTH_SEED?.trim();
    const effective =
      raw && raw.length > 0
        ? raw
        : nodeEnv !== 'production'
          ? 'dev|owner|changeme'
          : '';
    if (!effective) {
      this.log.log('PRIDE_AUTH_SEED unset in production — skipping dev seed');
      return;
    }

    const parts = effective.split('|').map((s) => s.trim());
    if (parts.length === 3) {
      const [shopId, username, password] = parts;
      if (!shopId || !username || !password) return;
      await this.ensureShopWithOwner(shopId, shopId, username, password);
      return;
    }
    if (parts.length === 4) {
      const [shopId, shopName, username, password] = parts;
      if (!shopId || !shopName || !username || !password) return;
      await this.ensureShopWithOwner(shopId, shopName, username, password);
      return;
    }
    throw new Error(
      'PRIDE_AUTH_SEED must be "shop_id|username|password" or "shop_id|shop_name|username|password"',
    );
  }

  private async ensureShopWithOwner(
    shopId: string,
    shopName: string,
    ownerUsername: string,
    ownerPassword: string,
  ): Promise<void> {
    const now = new Date();
    const trialEnd = new Date(now.getTime());
    trialEnd.setUTCDate(trialEnd.getUTCDate() + 15);

    await this.prisma.$transaction(async (tx) => {
      await tx.shop.upsert({
        where: { id: shopId },
        create: { id: shopId, name: shopName },
        update: { name: shopName },
      });
      const existing = await tx.shopUser.findFirst({
        where: { shopId, username: ownerUsername, deletedAt: null },
      });
      if (!existing) {
        await tx.shopUser.create({
          data: {
            id: randomUUID(),
            shopId,
            username: ownerUsername,
            passwordHash: sha256Hex(ownerPassword),
            isShopOwner: true,
          },
        });
      }
      const lic = await tx.shopLicense.findUnique({ where: { shopId } });
      if (!lic) {
        await tx.shopLicense.create({
          data: {
            shopId,
            statusStored: 'trial_active',
            expiresAt: trialEnd,
            trialStartedAt: now,
          },
        });
      }
    });
    this.log.log(`Seeded shop "${shopId}" (owner ${ownerUsername})`);
  }
}
