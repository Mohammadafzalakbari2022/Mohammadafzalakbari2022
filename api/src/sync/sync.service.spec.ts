import { BadRequestException, HttpException, NotFoundException } from '@nestjs/common';

import { LicenseService } from '../license/license.service';
import { PrismaService } from '../prisma/prisma.service';
import { SyncService } from './sync.service';

describe('SyncService', () => {
  function makeLicense(status: 'trial_active' | 'expired' | 'active') {
    return {
      getStatusForShop: jest.fn().mockResolvedValue({
        status,
        expires_at: new Date().toISOString(),
        server_now: new Date().toISOString(),
        last_successful_check_at: new Date().toISOString(),
      }),
    } as unknown as LicenseService;
  }

  afterEach(() => {
    jest.restoreAllMocks();
  });

  it('validateMutations accepts empty array', () => {
    const prisma = { $transaction: jest.fn() } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    expect(sync.validateMutations({ mutations: [] })).toEqual([]);
  });

  it('validateMutations rejects invalid entity_type', () => {
    const prisma = { $transaction: jest.fn() } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    expect(() =>
      sync.validateMutations({
        mutations: [
          {
            internal_id: 'a',
            entity_type: 'spaceship',
            operation: 'upsert',
            client_updated_at: new Date().toISOString(),
            data: {},
          },
        ],
      }),
    ).toThrow(BadRequestException);
  });

  it('validateMutations rejects bad cursor parse in pull', async () => {
    const prisma = {
      shop: { findUnique: jest.fn().mockResolvedValue({ lastMutationRevision: 0 }) },
    } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    await expect(sync.pull('dev', 'not-a-number')).rejects.toThrow(BadRequestException);
  });

  it('denies sync when license is expired', async () => {
    const lic = makeLicense('expired');
    const prisma = { $transaction: jest.fn() } as unknown as PrismaService;
    const sync = new SyncService(lic, prisma);
    await expect(sync.push('dev', [])).rejects.toThrow(HttpException);
  });

  it('push with empty mutations does not call transaction body for inserts', async () => {
    let lastRev = 3;
    const tx = {
      shop: {
        findUnique: jest.fn().mockResolvedValue({ lastMutationRevision: lastRev }),
        update: jest.fn(),
      },
      shopSyncMutation: { create: jest.fn() },
    };
    const prisma = {
      $transaction: jest.fn(async (fn: (t: typeof tx) => Promise<number>) => fn(tx)),
    } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    const r = await sync.push('shop-a', []);
    expect(r.results).toEqual([]);
    expect(r.next_cursor).toBe('3');
    expect(tx.shopSyncMutation.create).not.toHaveBeenCalled();
  });

  it('push persists mutations and advances next_cursor', async () => {
    const tx = {
      shop: {
        findUnique: jest.fn().mockResolvedValue({ lastMutationRevision: 1 }),
        update: jest.fn().mockResolvedValue({}),
      },
      shopSyncMutation: {
        create: jest.fn().mockResolvedValue({}),
      },
    };
    const prisma = {
      $transaction: jest.fn(async (fn: (t: typeof tx) => Promise<number>) => fn(tx)),
    } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    const iso = new Date().toISOString();
    const r = await sync.push('shop-a', [
      {
        internal_id: 'o1',
        entity_type: 'order',
        operation: 'upsert',
        client_updated_at: iso,
        data: { x: 1 },
      },
      {
        internal_id: 'o2',
        entity_type: 'order',
        operation: 'delete',
        client_updated_at: iso,
      },
    ]);
    expect(r.next_cursor).toBe('3');
    expect(r.results).toHaveLength(2);
    expect(tx.shopSyncMutation.create).toHaveBeenCalledTimes(2);
    expect(tx.shop.update).toHaveBeenCalledWith({
      where: { id: 'shop-a' },
      data: { lastMutationRevision: 3 },
    });
  });

  it('pull maps stored rows to change DTOs', async () => {
    const createdAt = new Date('2026-01-02T03:04:05.000Z');
    const prisma = {
      shop: {
        findUnique: jest.fn().mockResolvedValue({ lastMutationRevision: 2 }),
      },
      shopSyncMutation: {
        findMany: jest.fn().mockResolvedValue([
          {
            revision: 1,
            internalId: 'a',
            entityType: 'order',
            operation: 'upsert',
            createdAt,
            payload: { k: 1 },
          },
          {
            revision: 2,
            internalId: 'b',
            entityType: 'customer',
            operation: 'delete',
            createdAt,
            payload: null,
          },
        ]),
      },
    } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    const r = await sync.pull('shop-a', '0');
    expect(r.changes).toHaveLength(2);
    expect(r.changes[0]).toMatchObject({
      internal_id: 'a',
      entity_type: 'order',
      operation: 'upsert',
      data: { k: 1 },
    });
    expect(r.changes[1]).toMatchObject({
      internal_id: 'b',
      entity_type: 'customer',
      operation: 'delete',
      data: {},
    });
    expect(r.next_cursor).toBe('2');
  });

  it('push throws when shop is missing', async () => {
    const tx = {
      shop: { findUnique: jest.fn().mockResolvedValue(null), update: jest.fn() },
      shopSyncMutation: { create: jest.fn() },
    };
    const prisma = {
      $transaction: jest.fn(async (fn: (t: typeof tx) => Promise<number>) => fn(tx)),
    } as unknown as PrismaService;
    const sync = new SyncService(makeLicense('trial_active'), prisma);
    await expect(
      sync.push('missing', [
        {
          internal_id: 'x',
          entity_type: 'task',
          operation: 'upsert',
          client_updated_at: new Date().toISOString(),
          data: {},
        },
      ]),
    ).rejects.toThrow(NotFoundException);
  });
});
