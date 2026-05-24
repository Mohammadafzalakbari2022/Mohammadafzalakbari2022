import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';

export interface PublicCatalogItemDto {
  internal_id: string;
  shop_id: string;
  design_name: string;
  designer_shop_name: string;
  notes: string | null;
  shared_at: string;
}

@Injectable()
export class CatalogService {
  constructor(private readonly prisma: PrismaService) {}

  async getSharingEnabled(shopId: string): Promise<boolean> {
    const row = await this.prisma.shopCatalogSettings.findUnique({
      where: { shopId },
    });
    return row?.sharingEnabled ?? false;
  }

  async setSharingEnabled(shopId: string, sharingEnabled: boolean) {
    await this.prisma.shopCatalogSettings.upsert({
      where: { shopId },
      create: { shopId, sharingEnabled },
      update: { sharingEnabled },
    });
    return { ok: true, sharing_enabled: sharingEnabled };
  }

  async listPublicCatalog(callerShopId: string): Promise<{
    schema_version: number;
    catalog_sharing_default: boolean;
    items: PublicCatalogItemDto[];
  }> {
    const enabled = await this.getSharingEnabled(callerShopId);
    if (!enabled) {
      throw new ForbiddenException({
        error: 'catalog_sharing_disabled',
        message: 'Enable catalog sharing for your shop to browse the public directory.',
      });
    }

    const rows = await this.prisma.publicCatalogEntry.findMany({
      where: { unpublishedAt: null },
      orderBy: { sharedAt: 'desc' },
      take: 500,
    });

    return {
      schema_version: 1,
      catalog_sharing_default: true,
      items: rows.map((r) => ({
        internal_id: r.internalId,
        shop_id: r.shopId,
        design_name: r.designName,
        designer_shop_name: r.designerShopName,
        notes: r.notes,
        shared_at: r.sharedAt.toISOString(),
      })),
    };
  }

  /** Unauthenticated stub default for clients without JWT (legacy). */
  async publicCatalogStub() {
    const sharingOff = process.env.CATALOG_SHARING_DEFAULT === 'false';
    return {
      schema_version: 1,
      items: [] as PublicCatalogItemDto[],
      catalog_sharing_default: !sharingOff,
    };
  }

  async setItemShared(
    shopId: string,
    internalId: string,
    body: unknown,
  ): Promise<{ ok: true }> {
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      throw new BadRequestException('body must be an object');
    }
    const m = body as Record<string, unknown>;
    const shared = m.shared;
    if (typeof shared !== 'boolean') {
      throw new BadRequestException('shared must be a boolean');
    }

    if (!shared) {
      await this.prisma.publicCatalogEntry.updateMany({
        where: { shopId, internalId, unpublishedAt: null },
        data: { unpublishedAt: new Date() },
      });
      return { ok: true };
    }

    const designName = String(m.design_name ?? m.designName ?? '').trim();
    const designerShopName = String(
      m.designer_shop_name ?? m.designerShopName ?? '',
    ).trim();
    const notesRaw = m.notes;
    const notes =
      notesRaw == null || notesRaw === ''
        ? null
        : String(notesRaw).trim().slice(0, 2000);

    if (!designName) {
      throw new BadRequestException('design_name is required when shared=true');
    }

    const shop = await this.prisma.shop.findUnique({
      where: { id: shopId },
      select: { name: true },
    });
    if (!shop) {
      throw new NotFoundException('shop not found');
    }

    const label =
      designerShopName.length > 0 ? designerShopName : shop.name.trim() || shopId;

    await this.prisma.publicCatalogEntry.upsert({
      where: { shopId_internalId: { shopId, internalId } },
      create: {
        shopId,
        internalId,
        designName,
        designerShopName: label,
        notes,
        sharedAt: new Date(),
        unpublishedAt: null,
      },
      update: {
        designName,
        designerShopName: label,
        notes,
        sharedAt: new Date(),
        unpublishedAt: null,
      },
    });

    return { ok: true };
  }
}
