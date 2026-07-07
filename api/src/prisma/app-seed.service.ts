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
    if (process.env.VERCEL) {
      void this.run().catch((error) => {
        this.log.error(`Auth seed failed on Vercel cold start: ${String(error)}`);
      });
      return;
    }
    await this.run();
  }

  async run(): Promise<void> {
    await this.prisma.ensureConnected();
    const nodeEnv = process.env.NODE_ENV ?? 'development';
    const raw = process.env.PRIDE_AUTH_SEED?.trim();
    const effective = raw && raw.length > 0 ? raw : '';
    if (!effective) {
      this.log.log('PRIDE_AUTH_SEED unset in production — skipping auth shop seed');
    } else {
      const parts = effective.split('|').map((s) => s.trim());
      if (parts.length === 3) {
        const [shopId, username, password] = parts;
        if (!shopId || !username || !password) {
          await this.ensureOperatorFromEnv();
          return;
        }
        await this.ensureShopWithOwner(shopId, shopId, username, password);
      } else if (parts.length === 4) {
        const [shopId, shopName, username, password] = parts;
        if (!shopId || !shopName || !username || !password) {
          await this.ensureOperatorFromEnv();
          return;
        }
        await this.ensureShopWithOwner(shopId, shopName, username, password);
      } else {
        throw new Error(
          'PRIDE_AUTH_SEED must be "shop_id|username|password" or "shop_id|shop_name|username|password"',
        );
      }
    }

    await this.ensureOperatorFromEnv();
    await this.ensureDefaultBillingConfig();
  }

  /** Singleton Hesab Pay billing profile row (`subscription_billing_config`). */
  private async ensureDefaultBillingConfig(): Promise<void> {
    await this.prisma.subscriptionBillingConfig.upsert({
      where: { id: 'default' },
      create: {
        id: 'default',
        paymentSteps: {},
        activationDeliverySteps: {},
        cashPaymentNote: {},
        isPublished: false,
      },
      update: {},
    });
  }

  /**
   * Optional `PRIDE_OPERATOR_SEED=shop_id|username|password` — non-owner user for
   * developer portal when paired with `PRIDE_DEVELOPER_USERS=shop_id|username`.
   * Runs after `PRIDE_AUTH_SEED` so the shop exists.
   */
  private async ensureOperatorFromEnv(): Promise<void> {
    const raw = process.env.PRIDE_OPERATOR_SEED?.trim();
    if (!raw) return;
    const p = raw.split('|').map((s) => s.trim());
    if (p.length !== 3) {
      this.log.warn(
        'PRIDE_OPERATOR_SEED must be "shop_id|username|password" — skipping operator seed',
      );
      return;
    }
    const [shopId, username, password] = p;
    if (!shopId || !username || !password) return;

    const shop = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!shop) {
      this.log.warn(
        `PRIDE_OPERATOR_SEED: shop "${shopId}" not found — create it with PRIDE_AUTH_SEED first`,
      );
      return;
    }

    const existing = await this.prisma.shopUser.findFirst({
      where: { shopId, username, deletedAt: null },
    });
    if (existing) {
      this.log.log(`Operator seed: user "${username}" already exists in shop "${shopId}"`);
      return;
    }

    await this.prisma.shopUser.create({
      data: {
        id: randomUUID(),
        shopId,
        username,
        passwordHash: sha256Hex(password),
        isShopOwner: false,
      },
    });
    this.log.log(
      `Seeded operator user "${username}" in shop "${shopId}" — set PRIDE_DEVELOPER_USERS=${shopId}|${username} (or add user id to PRIDE_DEVELOPER_IDS)`,
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
