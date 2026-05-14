import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { randomUUID } from 'crypto';

import { PrismaService } from '../prisma/prisma.service';
import { ShopRegistryService } from './shop-registry.service';

@Injectable()
export class PasswordResetService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly shops: ShopRegistryService,
  ) {}

  /** Idempotent: creates a pending row when the user exists (no user enumeration). */
  async createRequest(shopIdRaw: string, usernameRaw: string): Promise<void> {
    const shopId = shopIdRaw?.trim() ?? '';
    const username = usernameRaw?.trim() ?? '';
    if (!shopId || !username) return;

    const user = await this.prisma.shopUser.findFirst({
      where: { shopId, username, deletedAt: null },
    });
    if (!user) return;

    await this.prisma.passwordResetRequest.deleteMany({
      where: { shopId, userId: user.id, status: 'pending' },
    });
    await this.prisma.passwordResetRequest.create({
      data: {
        id: randomUUID(),
        shopId,
        userId: user.id,
        username: user.username,
        status: 'pending',
      },
    });
  }

  async listPending(): Promise<
    Array<{
      id: string;
      shop_id: string;
      user_id: string;
      username: string;
      created_at: string;
    }>
  > {
    const rows = await this.prisma.passwordResetRequest.findMany({
      where: { status: 'pending' },
      orderBy: { createdAt: 'asc' },
    });
    return rows.map((r) => ({
      id: r.id,
      shop_id: r.shopId,
      user_id: r.userId,
      username: r.username,
      created_at: r.createdAt.toISOString(),
    }));
  }

  async resolveRequest(requestId: string, newPassword: string): Promise<void> {
    const pw = newPassword?.trim() ?? '';
    if (pw.length < 6) {
      throw new BadRequestException('new_password must be at least 6 characters');
    }
    const req = await this.prisma.passwordResetRequest.findUnique({
      where: { id: requestId },
    });
    if (!req || req.status !== 'pending') {
      throw new NotFoundException('request not found or already resolved');
    }
    await this.shops.setUserPasswordPlain(req.shopId, req.userId, pw);
    const now = new Date();
    await this.prisma.passwordResetRequest.update({
      where: { id: requestId },
      data: { status: 'resolved', resolvedAt: now },
    });
  }
}
