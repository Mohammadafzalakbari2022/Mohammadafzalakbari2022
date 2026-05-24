import { BadRequestException, Injectable } from '@nestjs/common';
import { randomUUID } from 'crypto';

import { PrismaService } from '../prisma/prisma.service';

@Injectable()
export class P2pService {
  constructor(private readonly prisma: PrismaService) {}

  async sendSignal(fromShopId: string, body: unknown) {
    if (!body || typeof body !== 'object' || Array.isArray(body)) {
      throw new BadRequestException('body must be an object');
    }
    const m = body as Record<string, unknown>;
    const toShopId = String(m.to_shop_id ?? m.toShopId ?? '').trim();
    const sessionId = String(m.session_id ?? m.sessionId ?? '').trim();
    const payloadType = String(m.payload_type ?? m.payloadType ?? '').trim();
    const payload = m.payload;

    if (!toShopId || !sessionId || !payloadType) {
      throw new BadRequestException(
        'to_shop_id, session_id, and payload_type are required',
      );
    }
    if (payload === undefined || payload === null) {
      throw new BadRequestException('payload is required');
    }

    await this.prisma.p2pSignalMessage.create({
      data: {
        id: randomUUID(),
        toShopId,
        fromShopId,
        sessionId,
        payloadType,
        payload: payload as object,
      },
    });

    return { ok: true };
  }

  async pollInbox(shopId: string, sessionId?: string) {
    const sid = sessionId?.trim();
    const rows = await this.prisma.p2pSignalMessage.findMany({
      where: {
        toShopId: shopId,
        consumedAt: null,
        ...(sid ? { sessionId: sid } : {}),
      },
      orderBy: { createdAt: 'asc' },
      take: 100,
    });

    if (rows.length > 0) {
      const ids = rows.map((r) => r.id);
      await this.prisma.p2pSignalMessage.updateMany({
        where: { id: { in: ids } },
        data: { consumedAt: new Date() },
      });
    }

    return {
      messages: rows.map((r) => ({
        id: r.id,
        from_shop_id: r.fromShopId,
        session_id: r.sessionId,
        payload_type: r.payloadType,
        payload: r.payload,
        created_at: r.createdAt.toISOString(),
      })),
    };
  }
}
