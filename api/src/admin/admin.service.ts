import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { randomBytes, randomUUID } from 'crypto';

import { licenseStatusDtoFromRow } from '../license/license-status.helper';
import { PrismaService } from '../prisma/prisma.service';
import { PasswordResetService } from '../shop/password-reset.service';

/** Comma-separated JWT `sub` values that count as developer (`plan-18`). */
@Injectable()
export class AdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly passwordResets: PasswordResetService,
  ) {}

  isDeveloperSub(sub: string): boolean {
    const raw = process.env.PRIDE_DEVELOPER_IDS ?? '';
    const ids = raw
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
    return ids.includes(sub);
  }

  async appendAudit(
    developerSub: string,
    action: string,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    await this.prisma.adminAuditLog.create({
      data: {
        id: randomUUID(),
        developerSub,
        action,
        payload: payload === undefined ? undefined : (payload as object),
      },
    });
  }

  listAuditLog(limit = 100) {
    const take = Math.min(Math.max(limit, 1), 500);
    return this.prisma.adminAuditLog.findMany({
      orderBy: { createdAt: 'desc' },
      take,
    });
  }

  async getStats(now: Date = new Date()) {
    const shopCount = await this.prisma.shop.count();
    const shops = await this.prisma.shop.findMany({ include: { license: true } });
    let trialActive = 0;
    let paidActive = 0;
    let expired = 0;
    for (const s of shops) {
      if (!s.license) {
        trialActive += 1;
        continue;
      }
      const dto = licenseStatusDtoFromRow(
        {
          statusStored: s.license.statusStored,
          expiresAt: s.license.expiresAt,
        },
        now,
      );
      if (dto.status === 'trial_active') trialActive += 1;
      else if (dto.status === 'active') paidActive += 1;
      else expired += 1;
    }
    return {
      schema_version: 1,
      shop_count: shopCount,
      license_trial_active: trialActive,
      license_paid_active: paidActive,
      license_expired: expired,
    };
  }

  async listShopsSummary(): Promise<
    Array<{
      id: string;
      name: string;
      user_count: number;
      license_status: string;
      license_expires_at: string | null;
    }>
  > {
    const now = new Date();
    const rows = await this.prisma.shop.findMany({
      orderBy: { name: 'asc' },
      include: { license: true },
    });
    const out: Array<{
      id: string;
      name: string;
      user_count: number;
      license_status: string;
      license_expires_at: string | null;
    }> = [];
    for (const s of rows) {
      const user_count = await this.prisma.shopUser.count({
        where: { shopId: s.id, deletedAt: null },
      });
      let license_status = 'none';
      let license_expires_at: string | null = null;
      if (s.license) {
        const dto = licenseStatusDtoFromRow(
          { statusStored: s.license.statusStored, expiresAt: s.license.expiresAt },
          now,
        );
        license_status = dto.status;
        license_expires_at = dto.expires_at;
      }
      out.push({
        id: s.id,
        name: s.name,
        user_count,
        license_status,
        license_expires_at,
      });
    }
    return out;
  }

  listPendingPasswordResets() {
    return this.passwordResets.listPending();
  }

  async resolvePasswordReset(
    developerSub: string,
    requestId: string,
    newPassword: string,
  ) {
    await this.passwordResets.resolveRequest(requestId, newPassword);
    await this.appendAudit(developerSub, 'password_reset.resolve', {
      request_id: requestId,
    });
  }

  listActivationCodes() {
    return this.prisma.activationCode.findMany({
      orderBy: { createdAt: 'desc' },
    });
  }

  private async generateUniqueActivationCode(): Promise<string> {
    for (let i = 0; i < 24; i += 1) {
      const candidate = `PRIDE-${randomBytes(5).toString('hex').toUpperCase()}`;
      const clash = await this.prisma.activationCode.findUnique({
        where: { code: candidate },
      });
      if (!clash) return candidate;
    }
    throw new BadRequestException('could not generate unique activation code');
  }

  async createActivationCode(
    developerSub: string,
    body: {
      plan_days?: unknown;
      max_uses?: unknown;
      assigned_shop_id?: unknown;
      expires_at?: unknown;
    },
  ) {
    const planDays = Math.min(
      Math.max(Number(body.plan_days) || 365, 1),
      3650,
    );
    const maxUses = Math.min(Math.max(Number(body.max_uses) || 1, 1), 10_000);
    const assigned =
      typeof body.assigned_shop_id === 'string' && body.assigned_shop_id.trim()
        ? body.assigned_shop_id.trim()
        : null;
    let expiresAt: Date | null = null;
    if (typeof body.expires_at === 'string' && body.expires_at.trim()) {
      const d = new Date(body.expires_at);
      if (Number.isNaN(d.getTime())) {
        throw new BadRequestException('expires_at must be a valid ISO date');
      }
      expiresAt = d;
    }
    const code = await this.generateUniqueActivationCode();
    const id = randomUUID();
    await this.prisma.activationCode.create({
      data: {
        id,
        code,
        status: 'active',
        maxUses,
        usesCount: 0,
        planDays,
        expiresAt,
        assignedShopId: assigned,
      },
    });
    await this.appendAudit(developerSub, 'activation_code.create', {
      id,
      code,
      plan_days: planDays,
      max_uses: maxUses,
    });
    return { id, code, plan_days: planDays, max_uses: maxUses, status: 'active' };
  }

  async revokeActivationCode(developerSub: string, id: string) {
    const row = await this.prisma.activationCode.findUnique({ where: { id } });
    if (!row) {
      throw new NotFoundException('activation code not found');
    }
    await this.prisma.activationCode.update({
      where: { id },
      data: { status: 'revoked' },
    });
    await this.appendAudit(developerSub, 'activation_code.revoke', {
      id,
      code: row.code,
    });
    return { ok: true };
  }
}
