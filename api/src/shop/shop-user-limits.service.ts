import { ForbiddenException, Injectable, NotFoundException } from '@nestjs/common';

import { LicenseService } from '../license/license.service';
import type { LicenseSnapshotStatus } from '../license/license.types';
import { PrismaService } from '../prisma/prisma.service';
import { ShopRegistryService } from './shop-registry.service';
import {
  clampPaidShopMaxUsers,
  isTrialLicenseStatus,
  resolveMaxUsers,
  SHOP_USER_LIMIT_PAID_DEFAULT,
} from './shop-user-limits.helper';

export type ShopUserLimitsDto = {
  license_status: LicenseSnapshotStatus;
  max_users: number;
  active_count: number;
  can_add: boolean;
  is_trial: boolean;
};

@Injectable()
export class ShopUserLimitsService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly license: LicenseService,
    private readonly registry: ShopRegistryService,
  ) {}

  async getLimitsForShop(
    shopId: string,
    isShopOwner: boolean,
  ): Promise<ShopUserLimitsDto> {
    const shop = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!shop) throw new NotFoundException('shop not found');

    const lic = await this.license.getStatusForShop(shopId);
    const activeCount = await this.registry.countActiveUsers(shopId);
    const maxUsers = resolveMaxUsers(lic.status, shop.maxUsers);
    const isTrial = isTrialLicenseStatus(lic.status);

    return {
      license_status: lic.status,
      max_users: maxUsers,
      active_count: activeCount,
      can_add:
        isShopOwner &&
        lic.status !== 'expired' &&
        maxUsers > 0 &&
        activeCount < maxUsers,
      is_trial: isTrial,
    };
  }

  async assertCanAddUser(shopId: string): Promise<void> {
    const lic = await this.license.getStatusForShop(shopId);
    if (lic.status === 'expired') {
      throw new ForbiddenException('license expired');
    }
    const shop = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!shop) throw new NotFoundException('shop not found');

    const max = resolveMaxUsers(lic.status, shop.maxUsers);
    const count = await this.registry.countActiveUsers(shopId);
    if (count >= max) {
      throw new ForbiddenException(`user limit reached (${max})`);
    }
  }

  /** Paid shops only; returns clamped value written to DB. */
  async setPaidShopMaxUsers(shopId: string, requested: number): Promise<number> {
    const lic = await this.license.getStatusForShop(shopId);
    if (lic.status !== 'active') {
      throw new ForbiddenException(
        'max_users can only be changed for paid (active) shops',
      );
    }
    const shop = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!shop) throw new NotFoundException('shop not found');

    const next = clampPaidShopMaxUsers(requested);
    const activeCount = await this.registry.countActiveUsers(shopId);
    if (next < activeCount) {
      throw new ForbiddenException(
        `max_users (${next}) cannot be less than active users (${activeCount})`,
      );
    }
    await this.prisma.shop.update({
      where: { id: shopId },
      data: { maxUsers: next },
    });
    return next;
  }

  defaultPaidMaxUsers(): number {
    return SHOP_USER_LIMIT_PAID_DEFAULT;
  }
}
