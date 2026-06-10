import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
  UnauthorizedException,
} from '@nestjs/common';
import { randomBytes, randomUUID } from 'crypto';

import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { licenseStatusDtoFromRow } from '../license/license-status.helper';
import { PrismaService } from '../prisma/prisma.service';
import type { LicenseSnapshotStatus } from '../license/license.types';
import { PasswordResetService } from '../shop/password-reset.service';
import { resolveMaxUsers } from '../shop/shop-user-limits.helper';
import { ShopUserLimitsService } from '../shop/shop-user-limits.service';
import { ShopRegistryService } from '../shop/shop-registry.service';

/** Comma-separated JWT `sub` values that count as developer (`plan-18`). */
@Injectable()
export class AdminService {
  constructor(
    private readonly prisma: PrismaService,
    private readonly passwordResets: PasswordResetService,
    private readonly shopRegistry: ShopRegistryService,
    private readonly shopUserLimits: ShopUserLimitsService,
  ) {}

  isDeveloperSub(sub: string): boolean {
    const raw = process.env.PRIDE_DEVELOPER_IDS ?? '';
    const ids = raw
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
    return ids.includes(sub);
  }

  /**
   * Developer portal access: JWT `sub` in PRIDE_DEVELOPER_IDS, or
   * `shop_id|username` entries in PRIDE_DEVELOPER_USERS (comma-separated).
   */
  isDeveloper(user: PrideAccessPayload): boolean {
    if (this.isDeveloperSub(user.sub)) return true;
    const raw = process.env.PRIDE_DEVELOPER_USERS ?? '';
    for (const part of raw.split(',')) {
      const t = part.trim();
      if (!t) continue;
      const i = t.indexOf('|');
      if (i <= 0) continue;
      const shopId = t.slice(0, i).trim();
      const username = t.slice(i + 1).trim();
      if (shopId === user.shop_id && username === user.username) return true;
    }
    return false;
  }

  /** Changes password for the authenticated user (developer portal only). */
  async changeDeveloperOwnPassword(
    user: PrideAccessPayload,
    currentPassword: string,
    newPassword: string,
  ): Promise<void> {
    if (!this.isDeveloper(user)) {
      throw new ForbiddenException();
    }
    const trimmed = newPassword?.trim() ?? '';
    if (trimmed.length < 6) {
      throw new BadRequestException('new_password must be at least 6 characters');
    }
    const ok = await this.shopRegistry.verifyUserPassword(
      user.shop_id,
      user.sub,
      currentPassword,
    );
    if (!ok) {
      throw new UnauthorizedException('current_password invalid');
    }
    await this.shopRegistry.setUserPasswordPlain(user.shop_id, user.sub, trimmed);
    await this.appendAudit(user.sub, 'admin.me_password_change', {});
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
      contact_whatsapp: string | null;
      contact_email: string | null;
      contact_address: string | null;
      created_at: string;
      user_count: number;
      license_status: string;
      license_expires_at: string | null;
      trial_started_at: string | null;
      disabled_at: string | null;
      max_users: number;
      effective_max_users: number;
      users: Array<{
        id: string;
        username: string;
        is_shop_owner: boolean;
        deleted_at: string | null;
        has_password: boolean;
      }>;
    }>
  > {
    const now = new Date();
    const rows = await this.prisma.shop.findMany({
      orderBy: { name: 'asc' },
      include: {
        license: true,
        users: { orderBy: { username: 'asc' } },
      },
    });
    const out: Array<{
      id: string;
      name: string;
      contact_whatsapp: string | null;
      contact_email: string | null;
      contact_address: string | null;
      created_at: string;
      user_count: number;
      license_status: string;
      license_expires_at: string | null;
      trial_started_at: string | null;
      disabled_at: string | null;
      max_users: number;
      effective_max_users: number;
      users: Array<{
        id: string;
        username: string;
        is_shop_owner: boolean;
        deleted_at: string | null;
        has_password: boolean;
      }>;
    }> = [];
    for (const s of rows) {
      const activeUsers = s.users.filter((u) => u.deletedAt == null);
      const user_count = activeUsers.length;
      let license_status = 'none';
      let license_expires_at: string | null = null;
      let trial_started_at: string | null = null;
      let effectiveStatus: LicenseSnapshotStatus = 'expired';
      if (s.license) {
        const dto = licenseStatusDtoFromRow(
          { statusStored: s.license.statusStored, expiresAt: s.license.expiresAt },
          now,
        );
        license_status = dto.status;
        effectiveStatus = dto.status;
        license_expires_at = dto.expires_at;
        trial_started_at = s.license.trialStartedAt?.toISOString() ?? null;
      }
      const effectiveMax = resolveMaxUsers(effectiveStatus, s.maxUsers);
      out.push({
        id: s.id,
        name: s.name,
        contact_whatsapp: s.contactWhatsapp,
        contact_email: s.contactEmail,
        contact_address: s.contactAddress,
        created_at: s.createdAt.toISOString(),
        user_count,
        license_status,
        license_expires_at,
        trial_started_at,
        disabled_at: s.disabledAt?.toISOString() ?? null,
        max_users: s.maxUsers,
        effective_max_users: effectiveMax,
        users: s.users.map((u) => ({
          id: u.id,
          username: u.username,
          is_shop_owner: u.isShopOwner,
          deleted_at: u.deletedAt?.toISOString() ?? null,
          has_password: u.passwordHash.trim().length > 0,
        })),
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

  /** Direct password set for any active shop user (no pending request required). */
  async setShopUserPassword(
    developerSub: string,
    shopId: string,
    userId: string,
    newPassword: string,
  ): Promise<{ shop_id: string; user_id: string; username: string }> {
    const sid = shopId?.trim() ?? '';
    const uid = userId?.trim() ?? '';
    const pw = newPassword?.trim() ?? '';
    if (!sid || !uid) {
      throw new BadRequestException('shop_id and user_id are required');
    }
    if (pw.length < 6) {
      throw new BadRequestException('new_password must be at least 6 characters');
    }
    const user = await this.prisma.shopUser.findFirst({
      where: { id: uid, shopId: sid, deletedAt: null },
    });
    if (!user) {
      throw new NotFoundException('user not found');
    }
    await this.shopRegistry.setUserPasswordPlain(sid, uid, pw);
    await this.appendAudit(developerSub, 'password_reset.direct', {
      shop_id: sid,
      user_id: uid,
      username: user.username,
    });
    return {
      shop_id: sid,
      user_id: uid,
      username: user.username,
    };
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

  async disableShop(developerSub: string, shopId: string) {
    const row = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!row) throw new NotFoundException('shop not found');
    await this.prisma.shop.update({
      where: { id: shopId },
      data: { disabledAt: new Date() },
    });
    await this.appendAudit(developerSub, 'shop.disable', { shop_id: shopId });
    return { ok: true };
  }

  async enableShop(developerSub: string, shopId: string) {
    const row = await this.prisma.shop.findUnique({ where: { id: shopId } });
    if (!row) throw new NotFoundException('shop not found');
    await this.prisma.shop.update({
      where: { id: shopId },
      data: { disabledAt: null },
    });
    await this.appendAudit(developerSub, 'shop.enable', { shop_id: shopId });
    return { ok: true };
  }

  async setShopMaxUsers(developerSub: string, shopId: string, maxUsersRaw: unknown) {
    const next = await this.shopUserLimits.setPaidShopMaxUsers(
      shopId,
      Number(maxUsersRaw),
    );
    await this.appendAudit(developerSub, 'shop.set_max_users', {
      shop_id: shopId,
      max_users: next,
    });
    return { ok: true, max_users: next };
  }

  async extendShopLicense(
    developerSub: string,
    shopId: string,
    addDaysRaw: unknown,
  ) {
    const addDays = Math.min(Math.max(Number(addDaysRaw) || 0, 1), 3650);
    const lic = await this.prisma.shopLicense.findUnique({ where: { shopId } });
    if (!lic) throw new NotFoundException('license not found for shop');
    const now = new Date();
    const base = lic.expiresAt.getTime() > now.getTime() ? lic.expiresAt : now;
    const next = new Date(base.getTime() + addDays * 86_400_000);
    await this.prisma.shopLicense.update({
      where: { shopId },
      data: { expiresAt: next, statusStored: 'active' },
    });
    await this.appendAudit(developerSub, 'shop.extend_license', {
      shop_id: shopId,
      add_days: addDays,
      new_expires_at: next.toISOString(),
    });
    return { ok: true, expires_at: next.toISOString() };
  }
}
