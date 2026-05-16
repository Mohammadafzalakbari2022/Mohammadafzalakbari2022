import { Injectable } from '@nestjs/common';

import { PrismaService } from '../prisma/prisma.service';
import { FcmPushService } from './fcm-push.service';

@Injectable()
export class PushDispatchService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly fcm: FcmPushService,
  ) {}

  /**
   * Sends an FCM notification+data payload to every stored device token for the shop.
   */
  async sendToShop(
    shopId: string,
    title: string,
    body: string,
    data?: Record<string, unknown>,
  ): Promise<{
    ok: boolean;
    reason: 'sent' | 'no_tokens' | 'fcm_not_configured';
    successCount: number;
    failureCount: number;
  }> {
    if (!this.fcm.isConfigured()) {
      return {
        ok: false,
        reason: 'fcm_not_configured',
        successCount: 0,
        failureCount: 0,
      };
    }
    const rows = await this.prisma.shopPushToken.findMany({
      where: { shopId },
      select: { token: true },
    });
    const tokens = [...new Set(rows.map((r) => r.token.trim()).filter((t) => t.length > 8))];
    if (tokens.length === 0) {
      return { ok: true, reason: 'no_tokens', successCount: 0, failureCount: 0 };
    }
    const flat: Record<string, string> = {};
    if (data) {
      for (const [k, v] of Object.entries(data)) {
        flat[k] = typeof v === 'string' ? v : JSON.stringify(v);
      }
    }
    const { successCount, failureCount } = await this.fcm.sendMulticast(
      tokens,
      title,
      body,
      Object.keys(flat).length ? flat : undefined,
    );
    return { ok: true, reason: 'sent', successCount, failureCount };
  }
}
