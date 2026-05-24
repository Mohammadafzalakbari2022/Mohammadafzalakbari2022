import {
  BadRequestException,
  HttpException,
  HttpStatus,
  Injectable,
  Logger,
  NotFoundException,
} from '@nestjs/common';
import { Prisma } from '@prisma/client';

import { LicenseService } from '../license/license.service';
import { PushDispatchService } from '../push/push-dispatch.service';
import { PrismaService } from '../prisma/prisma.service';
import type {
  SyncChangeRow,
  SyncMutationInput,
  SyncPullResponseBody,
  SyncPushResponseBody,
} from './sync.types';
import { SYNC_ENTITY_TYPES } from './sync.types';

const MAX_MUTATIONS = 500;
const MAX_PULL_ROWS = 500;

@Injectable()
export class SyncService {
  private readonly logger = new Logger(SyncService.name);

  constructor(
    private readonly license: LicenseService,
    private readonly prisma: PrismaService,
    private readonly pushDispatch: PushDispatchService,
  ) {}

  async assertLicenseAllowsSync(shopId: string): Promise<void> {
    const shop = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!shop) {
      throw new NotFoundException('shop not found');
    }
    if (shop.disabledAt) {
      throw new HttpException(
        {
          error: 'shop_disabled',
          message: 'Sync is disabled for this shop.',
        },
        HttpStatus.FORBIDDEN,
      );
    }
    const st = (await this.license.getStatusForShop(shopId)).status;
    if (st === 'expired') {
      throw new HttpException(
        {
          error: 'license_expired',
          message: 'Sync is disabled while the shop license is expired.',
        },
        HttpStatus.FORBIDDEN,
      );
    }
  }

  private parseRevision(cursor: string | undefined): number {
    if (cursor == null || cursor.trim() === '') return 0;
    const n = Number.parseInt(cursor.trim(), 10);
    if (!Number.isFinite(n) || n < 0) {
      throw new BadRequestException('cursor must be a non-negative integer string');
    }
    return n;
  }

  validateMutations(raw: unknown): SyncMutationInput[] {
    if (raw === null || typeof raw !== 'object' || Array.isArray(raw)) {
      throw new BadRequestException('body must be a JSON object');
    }
    const m = (raw as { mutations?: unknown }).mutations;
    if (!Array.isArray(m)) {
      throw new BadRequestException('mutations must be an array');
    }
    if (m.length > MAX_MUTATIONS) {
      throw new BadRequestException(`mutations exceeds limit (${MAX_MUTATIONS})`);
    }
    const out: SyncMutationInput[] = [];
    for (let i = 0; i < m.length; i++) {
      const row = m[i];
      if (row === null || typeof row !== 'object' || Array.isArray(row)) {
        throw new BadRequestException(`mutations[${i}] must be an object`);
      }
      const internal_id = String((row as { internal_id?: unknown }).internal_id ?? '').trim();
      const entity_type = String((row as { entity_type?: unknown }).entity_type ?? '').trim();
      const operation = String((row as { operation?: unknown }).operation ?? '').trim();
      const client_updated_at = String(
        (row as { client_updated_at?: unknown }).client_updated_at ?? '',
      ).trim();
      const data = (row as { data?: unknown }).data;
      if (!internal_id) {
        throw new BadRequestException(`mutations[${i}].internal_id is required`);
      }
      if (!SYNC_ENTITY_TYPES.includes(entity_type as (typeof SYNC_ENTITY_TYPES)[number])) {
        throw new BadRequestException(`mutations[${i}].entity_type is invalid`);
      }
      if (operation !== 'upsert' && operation !== 'delete') {
        throw new BadRequestException(`mutations[${i}].operation must be upsert or delete`);
      }
      if (!client_updated_at) {
        throw new BadRequestException(`mutations[${i}].client_updated_at is required`);
      }
      const t = Date.parse(client_updated_at);
      if (Number.isNaN(t)) {
        throw new BadRequestException(`mutations[${i}].client_updated_at must be ISO-8601`);
      }
      if (
        operation === 'upsert' &&
        (data === undefined ||
          data === null ||
          typeof data !== 'object' ||
          Array.isArray(data))
      ) {
        throw new BadRequestException(`mutations[${i}].data must be an object for upsert`);
      }
      out.push({
        internal_id,
        entity_type,
        operation,
        client_updated_at,
        ...(operation === 'upsert' ? { data: data as Record<string, unknown> } : {}),
      });
    }
    return out;
  }

  private extractOrderPushHint(data: Record<string, unknown> | undefined): string | undefined {
    if (!data) return undefined;
    const name = String(data['customer_snapshot_name'] ?? '').trim();
    if (name.length > 0) return name;
    const ord = String(data['display_order_no'] ?? data['displayOrderNo'] ?? '').trim();
    if (ord.length > 0) return `#${ord}`;
    return undefined;
  }

  private fireNewOrderPushesFireAndForget(
    shopId: string,
    newOrders: { internalId: string; hint?: string }[],
  ): void {
    if (newOrders.length === 0) return;
    void (async () => {
      try {
        const shop = await this.prisma.shop.findUnique({
          where: { id: shopId },
          select: { name: true },
        });
        const label = (shop?.name ?? '').trim() || shopId;
        for (const o of newOrders) {
          const title = 'New order';
          const hint = o.hint?.trim();
          const body =
            hint != null && hint.length > 0
              ? `${label}: new order for ${hint}.`
              : `${label}: new order synced.`;
          await this.pushDispatch.sendToShop(shopId, title, body, {
            type: 'new_order',
            shop_id: shopId,
            order_internal_id: o.internalId,
          });
        }
      } catch (e) {
        this.logger.warn(`new order push failed: ${e}`);
      }
    })();
  }

  private extractNotificationPushHint(
    data: Record<string, unknown> | undefined,
  ): { title?: string; body?: string; type?: string } | null {
    if (!data) return null;
    const title = String(data['title'] ?? '').trim();
    const body = String(data['body'] ?? '').trim();
    const type = String(data['type'] ?? data['kind'] ?? '').trim();
    if (!title && !body) return null;
    return { title: title || 'Notification', body: body || title, type };
  }

  private fireNotificationPushesFireAndForget(
    shopId: string,
    notes: { title: string; body: string; type?: string }[],
  ): void {
    if (notes.length === 0) return;
    void (async () => {
      try {
        for (const n of notes) {
          await this.pushDispatch.sendToShop(shopId, n.title, n.body, {
            type: n.type ?? 'notification',
            shop_id: shopId,
          });
        }
      } catch (e) {
        this.logger.warn(`notification push failed: ${e}`);
      }
    })();
  }

  async push(shopId: string, mutations: SyncMutationInput[]): Promise<SyncPushResponseBody> {
    await this.assertLicenseAllowsSync(shopId);
    const server_now = new Date().toISOString();

    const shop = await this.prisma.shop.findUnique({
      where: { id: shopId },
      select: { lastMutationRevision: true },
    });
    if (!shop) {
      throw new NotFoundException('shop not found');
    }

    if (mutations.length === 0) {
      return {
        server_now,
        results: [],
        next_cursor: String(shop.lastMutationRevision),
      };
    }

    const results: {
      internal_id: string;
      status: 'accepted' | 'conflict' | 'rejected';
      message: string | null;
    }[] = [];
    const newOrders: { internalId: string; hint?: string }[] = [];
    const notificationPushes: { title: string; body: string; type?: string }[] =
      [];

    let cursor = shop.lastMutationRevision;

    for (const x of mutations) {
      if (x.entity_type === 'order' && x.operation === 'upsert') {
        const latest = await this.prisma.shopSyncMutation.findFirst({
          where: { shopId, internalId: x.internal_id, entityType: 'order' },
          orderBy: { revision: 'desc' },
        });
        const clientTs = Date.parse(x.client_updated_at);
        if (
          latest &&
          Number.isFinite(clientTs) &&
          clientTs < latest.clientUpdatedAt.getTime()
        ) {
          results.push({
            internal_id: x.internal_id,
            status: 'conflict',
            message: 'server_has_newer_version',
          });
          continue;
        }
      }

      let isNewOrder = false;
      if (x.entity_type === 'order' && x.operation === 'upsert') {
        const prev = await this.prisma.shopSyncMutation.count({
          where: { shopId, internalId: x.internal_id, entityType: 'order' },
        });
        isNewOrder = prev === 0;
      }

      cursor += 1;
      await this.prisma.shopSyncMutation.create({
        data: {
          shopId,
          revision: cursor,
          internalId: x.internal_id,
          entityType: x.entity_type,
          operation: x.operation,
          clientUpdatedAt: new Date(x.client_updated_at),
          payload:
            x.operation === 'upsert' && x.data
              ? (x.data as Prisma.InputJsonValue)
              : Prisma.DbNull,
        },
      });

      results.push({
        internal_id: x.internal_id,
        status: 'accepted',
        message: null,
      });

      if (isNewOrder) {
        newOrders.push({
          internalId: x.internal_id,
          hint: this.extractOrderPushHint(x.data),
        });
      }

      if (x.entity_type === 'notification' && x.operation === 'upsert') {
        const hint = this.extractNotificationPushHint(x.data);
        if (hint?.title && hint.body) {
          notificationPushes.push({
            title: hint.title,
            body: hint.body,
            type: hint.type,
          });
        }
      }
    }

    await this.prisma.shop.update({
      where: { id: shopId },
      data: { lastMutationRevision: cursor },
    });

    this.fireNewOrderPushesFireAndForget(shopId, newOrders);
    this.fireNotificationPushesFireAndForget(shopId, notificationPushes);

    return {
      server_now,
      results,
      next_cursor: String(cursor),
    };
  }

  async pull(shopId: string, cursorRaw: string | undefined): Promise<SyncPullResponseBody> {
    await this.assertLicenseAllowsSync(shopId);
    const after = this.parseRevision(cursorRaw);
    const server_now = new Date().toISOString();

    const shop = await this.prisma.shop.findUnique({
      where: { id: shopId },
      select: { lastMutationRevision: true },
    });
    if (!shop) {
      throw new NotFoundException('shop not found');
    }

    const rows = await this.prisma.shopSyncMutation.findMany({
      where: { shopId, revision: { gt: after } },
      orderBy: { revision: 'asc' },
      take: MAX_PULL_ROWS,
    });

    const changes: SyncChangeRow[] = rows.map((r) => ({
      internal_id: r.internalId,
      entity_type: r.entityType as SyncChangeRow['entity_type'],
      operation: r.operation as SyncChangeRow['operation'],
      server_updated_at: r.createdAt.toISOString(),
      data:
        r.operation === 'delete'
          ? {}
          : ((r.payload as Record<string, unknown> | null) ?? {}),
    }));

    const tip = shop.lastMutationRevision;
    let next_cursor: string;
    if (rows.length === 0) {
      next_cursor = String(Math.max(tip, after));
    } else if (rows.length >= MAX_PULL_ROWS) {
      next_cursor = String(rows[rows.length - 1]!.revision);
    } else {
      next_cursor = String(Math.max(tip, rows[rows.length - 1]!.revision));
    }

    return {
      server_now,
      changes,
      next_cursor,
    };
  }
}
