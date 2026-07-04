import {
  BadRequestException,
  ConflictException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { createHash, randomUUID, timingSafeEqual } from 'crypto';

import { PrismaService } from '../prisma/prisma.service';

export type ShopRow = { id: string; name: string };

export type UserRow = {
  id: string;
  shop_id: string;
  username: string;
  password_hash: Buffer;
  is_shop_owner: boolean;
  deleted_at: string | null;
};

function sha256Hex(password: string): string {
  return createHash('sha256').update(password, 'utf8').digest('hex');
}

function safeEqualPassword(password: string, hashHex: string): boolean {
  const digest = createHash('sha256').update(password, 'utf8').digest();
  let stored: Buffer;
  try {
    stored = Buffer.from(hashHex, 'hex');
  } catch {
    return false;
  }
  if (digest.length !== stored.length) return false;
  return timingSafeEqual(digest, stored);
}

export type ShopRegistrationContact = {
  whatsapp: string;
  email?: string;
  address: string;
};

/** Best-effort Afghan / international digits for developer contact records. */
function normalizeContactWhatsapp(raw: string): string {
  let digits = raw.replace(/\D/g, '');
  if (digits.startsWith('00')) digits = digits.slice(2);
  if (digits.startsWith('0') && digits.length >= 9) {
    digits = `93${digits.slice(1)}`;
  } else if (digits.length === 9 && !digits.startsWith('93')) {
    digits = `93${digits}`;
  }
  return digits;
}

function parseRegistrationContact(
  contact: ShopRegistrationContact,
): { whatsapp: string; email: string | null; address: string } {
  const whatsapp = normalizeContactWhatsapp(contact.whatsapp.trim());
  if (whatsapp.length < 9) {
    throw new BadRequestException('contact_whatsapp is required');
  }
  const address = contact.address.trim();
  if (address.length < 3) {
    throw new BadRequestException('contact_address is required');
  }
  const emailRaw = contact.email?.trim() ?? '';
  let email: string | null = null;
  if (emailRaw.length > 0) {
    if (!/^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(emailRaw)) {
      throw new BadRequestException('contact_email is invalid');
    }
    email = emailRaw;
  }
  return { whatsapp, email, address };
}

function toUserRow(u: {
  id: string;
  shopId: string;
  username: string;
  passwordHash: string;
  isShopOwner: boolean;
  deletedAt: Date | null;
}): UserRow {
  return {
    id: u.id,
    shop_id: u.shopId,
    username: u.username,
    password_hash: Buffer.from(u.passwordHash, 'hex'),
    is_shop_owner: u.isShopOwner,
    deleted_at: u.deletedAt?.toISOString() ?? null,
  };
}

/** Shops + users in Postgres (`plan-04`). */
@Injectable()
export class ShopRegistryService {
  constructor(private readonly prisma: PrismaService) {}

  async verifyLogin(
    shopIdRaw: string | undefined,
    username: string,
    password: string,
  ): Promise<UserRow | null> {
    const u = username.trim();
    const s = shopIdRaw?.trim() ?? '';
    const active = await this.prisma.shopUser.findMany({
      where: {
        username: u,
        deletedAt: null,
        ...(s ? { shopId: s } : {}),
      },
    });
    if (!s && active.length > 1) {
      throw new BadRequestException('shop_id is required for this username');
    }
    const row = active[0];
    if (!row || !safeEqualPassword(password, row.passwordHash)) return null;
    const shop = await this.prisma.shop.findUnique({ where: { id: row.shopId } });
    if (!shop || shop.disabledAt) return null;
    return toUserRow(row);
  }

  async createShopWithOwner(
    shopName: string,
    ownerUsername: string,
    ownerPassword: string,
    contact: ShopRegistrationContact,
  ): Promise<{ shop: ShopRow; user: UserRow }> {
    const name = shopName.trim();
    const ou = ownerUsername.trim();
    if (!name) throw new BadRequestException('shop_name is required');
    if (!ou) throw new BadRequestException('owner_username is required');
    if (!ownerPassword) throw new BadRequestException('owner_password is required');
    if (ownerPassword.trim().length < 6) throw new BadRequestException('owner_password must be at least 6 characters');
    const { whatsapp, email, address } = parseRegistrationContact(contact);

    const shopId = randomUUID();
    const now = new Date();
    const trialEnd = new Date(now.getTime());
    trialEnd.setUTCDate(trialEnd.getUTCDate() + 15);

    const result = await this.prisma.$transaction(async (tx) => {
      const shop = await tx.shop.create({
        data: {
          id: shopId,
          name,
          contactWhatsapp: whatsapp,
          contactEmail: email,
          contactAddress: address,
        },
      });
      const user = await tx.shopUser.create({
        data: {
          id: randomUUID(),
          shopId,
          username: ou,
          passwordHash: sha256Hex(ownerPassword),
          isShopOwner: true,
        },
      });
      await tx.shopLicense.create({
        data: {
          shopId,
          statusStored: 'trial_active',
          expiresAt: trialEnd,
          trialStartedAt: now,
        },
      });
      return { shop, user };
    });

    return {
      shop: { id: result.shop.id, name: result.shop.name },
      user: toUserRow(result.user),
    };
  }

  async listActiveUsers(shopId: string): Promise<UserRow[]> {
    const rows = await this.prisma.shopUser.findMany({
      where: { shopId, deletedAt: null },
      orderBy: { username: 'asc' },
    });
    return rows.map(toUserRow);
  }

  async countActiveUsers(shopId: string): Promise<number> {
    return this.prisma.shopUser.count({
      where: { shopId, deletedAt: null },
    });
  }

  async addMemberUser(
    shopId: string,
    username: string,
    plainPassword: string,
  ): Promise<UserRow> {
    const un = username.trim();
    if (!un) throw new BadRequestException('username is required');
    if (!plainPassword) throw new BadRequestException('password is required');
    if (plainPassword.trim().length < 6) throw new BadRequestException('password must be at least 6 characters');
    const existing = await this.prisma.shopUser.findFirst({
      where: { shopId, username: un, deletedAt: null },
    });
    if (existing) {
      throw new ConflictException('username already exists in this shop');
    }
    const user = await this.prisma.shopUser.create({
      data: {
        id: randomUUID(),
        shopId,
        username: un,
        passwordHash: sha256Hex(plainPassword),
        isShopOwner: false,
      },
    });
    return toUserRow(user);
  }

  /** Verifies the current password for a shop user (e.g. self-service change). */
  async verifyUserPassword(
    shopId: string,
    userId: string,
    plainPassword: string,
  ): Promise<boolean> {
    const row = await this.prisma.shopUser.findFirst({
      where: { id: userId, shopId, deletedAt: null },
    });
    if (!row) return false;
    return safeEqualPassword(plainPassword, row.passwordHash);
  }

  async getUser(shopId: string, userId: string): Promise<UserRow | undefined> {
    const u = await this.prisma.shopUser.findFirst({
      where: { id: userId, shopId },
    });
    if (!u) return undefined;
    return toUserRow(u);
  }

  async softDeleteUser(shopId: string, userId: string): Promise<void> {
    const u = await this.getUser(shopId, userId);
    if (!u) throw new NotFoundException('user not found');
    if (u.is_shop_owner) {
      throw new ForbiddenException('owner account cannot be deleted');
    }
    await this.prisma.shopUser.update({
      where: { id: userId },
      data: { deletedAt: new Date() },
    });
  }

  /** Used by developer password-reset flow (`plan-18`). */
  async setUserPasswordPlain(
    shopId: string,
    userId: string,
    plainPassword: string,
  ): Promise<void> {
    const row = await this.prisma.shopUser.findFirst({
      where: { id: userId, shopId, deletedAt: null },
    });
    if (!row) throw new NotFoundException('user not found');
    if (!plainPassword || plainPassword.trim().length < 6) {
      throw new BadRequestException('password must be at least 6 characters');
    }
    await this.prisma.shopUser.update({
      where: { id: userId },
      data: { passwordHash: sha256Hex(plainPassword) },
    });
  }
}
