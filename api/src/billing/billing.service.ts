import {
  BadRequestException,
  ForbiddenException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import { randomBytes, randomUUID } from 'crypto';
import type { SubscriptionBillingConfig, SubscriptionPaymentClaim } from '@prisma/client';

import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { PrismaService } from '../prisma/prisma.service';
import {
  isPlanTier,
  pickLocaleText,
  planTierToDays,
  type PlanTier,
} from './billing.types';

const BILLING_CONFIG_ID = 'default';
const MAX_PENDING_CLAIMS_PER_SHOP = 3;

@Injectable()
export class BillingService {
  constructor(private readonly prisma: PrismaService) {}

  private auditCallback?: (
    developerSub: string,
    action: string,
    payload?: Record<string, unknown>,
  ) => Promise<void>;

  /** Wired from AdminModule to avoid circular imports. */
  setAuditCallback(
    cb: (
      developerSub: string,
      action: string,
      payload?: Record<string, unknown>,
    ) => Promise<void>,
  ): void {
    this.auditCallback = cb;
  }

  private async audit(
    developerSub: string,
    action: string,
    payload?: Record<string, unknown>,
  ): Promise<void> {
    await this.auditCallback?.(developerSub, action, payload);
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

  private async createActivationCodeForClaim(
    developerSub: string,
    planDays: number,
    assignedShopId: string,
  ): Promise<{ id: string; code: string }> {
    const code = await this.generateUniqueActivationCode();
    const id = randomUUID();
    await this.prisma.activationCode.create({
      data: {
        id,
        code,
        status: 'active',
        maxUses: 1,
        usesCount: 0,
        planDays,
        assignedShopId,
      },
    });
    await this.audit(developerSub, 'activation_code.create', {
      id,
      code,
      plan_days: planDays,
      source: 'payment_claim',
    });
    return { id, code };
  }

  private configToDto(
    row: SubscriptionBillingConfig,
    opts: { publishedOnly: boolean; locale?: string },
  ) {
    const locale = opts.locale;
    return {
      schema_version: 1,
      is_published: row.isPublished,
      hesab_pay_account_name: row.hesabPayAccountName,
      hesab_pay_account_number: row.hesabPayAccountNumber,
      hesab_pay_merchant_id: row.hesabPayMerchantId,
      price_1_year_afn: row.price1YearAfn,
      price_2_year_afn: row.price2YearAfn,
      price_lifetime_afn: row.priceLifetimeAfn,
      payment_steps: pickLocaleText(row.paymentSteps, locale),
      activation_delivery_steps: pickLocaleText(
        row.activationDeliverySteps,
        locale,
      ),
      cash_payment_note: pickLocaleText(row.cashPaymentNote, locale),
      payment_steps_all: row.paymentSteps,
      activation_delivery_steps_all: row.activationDeliverySteps,
      cash_payment_note_all: row.cashPaymentNote,
      whatsapp_e164: row.whatsappE164,
      telegram_handle: row.telegramHandle,
      direct_phone_e164: row.directPhoneE164,
      updated_at: row.updatedAt.toISOString(),
      ...(opts.publishedOnly
        ? {}
        : { updated_by_developer_sub: row.updatedByDeveloperSub }),
    };
  }

  private async getConfigRow() {
    return this.prisma.subscriptionBillingConfig.findUnique({
      where: { id: BILLING_CONFIG_ID },
    });
  }

  async getPublishedBillingInfo(locale?: string) {
    const row = await this.getConfigRow();
    if (!row || !row.isPublished) {
      throw new NotFoundException('billing info not published');
    }
    return this.configToDto(row, { publishedOnly: true, locale });
  }

  /** Empty singleton for first-time setup (no row yet or migration pending). */
  private emptyAdminBillingDto() {
    return {
      schema_version: 1,
      is_published: false,
      hesab_pay_account_name: null,
      hesab_pay_account_number: null,
      hesab_pay_merchant_id: null,
      price_1_year_afn: null,
      price_2_year_afn: null,
      price_lifetime_afn: null,
      payment_steps: '',
      activation_delivery_steps: '',
      cash_payment_note: '',
      payment_steps_all: {},
      activation_delivery_steps_all: {},
      cash_payment_note_all: {},
      whatsapp_e164: null,
      telegram_handle: null,
      direct_phone_e164: null,
      updated_at: null,
      updated_by_developer_sub: null,
    };
  }

  async getAdminBillingInfo(locale?: string) {
    const row = await this.getConfigRow();
    if (!row) {
      return this.emptyAdminBillingDto();
    }
    return this.configToDto(row, { publishedOnly: false, locale });
  }

  async upsertAdminBillingInfo(
    developerSub: string,
    body: Record<string, unknown>,
  ) {
    const parseJsonLocales = (key: string, existing: unknown): object => {
      const v = body[key];
      if (v === undefined) {
        return existing && typeof existing === 'object' && !Array.isArray(existing)
          ? (existing as object)
          : {};
      }
      if (v === null || (typeof v === 'object' && !Array.isArray(v))) {
        return (v ?? {}) as object;
      }
      throw new BadRequestException(`${key} must be a JSON object`);
    };

    const existing = await this.getConfigRow();
    const paymentSteps = parseJsonLocales(
      'payment_steps',
      existing?.paymentSteps,
    );
    const activationDeliverySteps = parseJsonLocales(
      'activation_delivery_steps',
      existing?.activationDeliverySteps,
    );
    const cashPaymentNote = parseJsonLocales(
      'cash_payment_note',
      existing?.cashPaymentNote,
    );

    const strOrNull = (key: string, prev: string | null | undefined) => {
      if (body[key] === undefined) return prev ?? null;
      const s = String(body[key] ?? '').trim();
      return s.length > 0 ? s : null;
    };

    const intOrNull = (key: string, prev: number | null | undefined) => {
      if (body[key] === undefined) return prev ?? null;
      const n = Number(body[key]);
      if (!Number.isFinite(n) || n < 0) {
        throw new BadRequestException(`${key} must be a non-negative number`);
      }
      return Math.floor(n);
    };

    const isPublished =
      body.is_published === undefined
        ? (existing?.isPublished ?? false)
        : Boolean(body.is_published);

    const row = await this.prisma.subscriptionBillingConfig.upsert({
      where: { id: BILLING_CONFIG_ID },
      create: {
        id: BILLING_CONFIG_ID,
        hesabPayAccountName: strOrNull('hesab_pay_account_name', null),
        hesabPayAccountNumber: strOrNull('hesab_pay_account_number', null),
        hesabPayMerchantId: strOrNull('hesab_pay_merchant_id', null),
        price1YearAfn: intOrNull('price_1_year_afn', null),
        price2YearAfn: intOrNull('price_2_year_afn', null),
        priceLifetimeAfn: intOrNull('price_lifetime_afn', null),
        paymentSteps,
        activationDeliverySteps,
        cashPaymentNote,
        whatsappE164: strOrNull('whatsapp_e164', null),
        telegramHandle: strOrNull('telegram_handle', null),
        directPhoneE164: strOrNull('direct_phone_e164', null),
        isPublished,
        updatedByDeveloperSub: developerSub,
      },
      update: {
        hesabPayAccountName: strOrNull(
          'hesab_pay_account_name',
          existing?.hesabPayAccountName,
        ),
        hesabPayAccountNumber: strOrNull(
          'hesab_pay_account_number',
          existing?.hesabPayAccountNumber,
        ),
        hesabPayMerchantId: strOrNull(
          'hesab_pay_merchant_id',
          existing?.hesabPayMerchantId,
        ),
        price1YearAfn: intOrNull('price_1_year_afn', existing?.price1YearAfn),
        price2YearAfn: intOrNull('price_2_year_afn', existing?.price2YearAfn),
        priceLifetimeAfn: intOrNull(
          'price_lifetime_afn',
          existing?.priceLifetimeAfn,
        ),
        paymentSteps,
        activationDeliverySteps,
        cashPaymentNote,
        whatsappE164: strOrNull('whatsapp_e164', existing?.whatsappE164),
        telegramHandle: strOrNull('telegram_handle', existing?.telegramHandle),
        directPhoneE164: strOrNull(
          'direct_phone_e164',
          existing?.directPhoneE164,
        ),
        isPublished,
        updatedByDeveloperSub: developerSub,
      },
    });

    await this.audit(developerSub, 'billing_config.update', {
      is_published: row.isPublished,
    });

    return this.configToDto(row, { publishedOnly: false });
  }

  private priceForTier(
    config: SubscriptionBillingConfig,
    tier: PlanTier,
  ): number {
    switch (tier) {
      case 'one_year':
        return config.price1YearAfn ?? 0;
      case 'two_year':
        return config.price2YearAfn ?? 0;
      case 'lifetime':
        return config.priceLifetimeAfn ?? 0;
      default:
        return 0;
    }
  }

  assertOwner(user: PrideAccessPayload): void {
    if (!user.is_shop_owner) {
      throw new ForbiddenException('owner only');
    }
  }

  async submitPaymentClaim(
    user: PrideAccessPayload,
    body: {
      plan_tier?: unknown;
      transaction_id?: unknown;
      payer_phone?: unknown;
      notes?: unknown;
    },
  ) {
    this.assertOwner(user);
    const tierRaw = String(body.plan_tier ?? '').trim();
    if (!isPlanTier(tierRaw)) {
      throw new BadRequestException(
        'plan_tier must be one_year, two_year, or lifetime',
      );
    }
    const transactionId = String(body.transaction_id ?? '')
      .trim()
      .toUpperCase();
    if (transactionId.length < 4) {
      throw new BadRequestException('transaction_id is required');
    }

    const config = await this.getConfigRow();
    if (!config?.isPublished) {
      throw new BadRequestException('billing is not available yet');
    }

    const pendingCount = await this.prisma.subscriptionPaymentClaim.count({
      where: { shopId: user.shop_id, status: 'pending' },
    });
    if (pendingCount >= MAX_PENDING_CLAIMS_PER_SHOP) {
      throw new BadRequestException(
        'too many pending claims; wait for review or contact support',
      );
    }

    const existing = await this.prisma.subscriptionPaymentClaim.findUnique({
      where: { transactionId },
    });
    if (existing && (existing.status === 'pending' || existing.status === 'approved')) {
      throw new BadRequestException('transaction_id already submitted');
    }

    const payerPhone =
      typeof body.payer_phone === 'string' && body.payer_phone.trim()
        ? body.payer_phone.trim()
        : null;
    const notes =
      typeof body.notes === 'string' && body.notes.trim()
        ? body.notes.trim()
        : null;

    const row = await this.prisma.subscriptionPaymentClaim.create({
      data: {
        shopId: user.shop_id,
        submittedByUserId: user.sub,
        planTier: tierRaw,
        amountAfn: this.priceForTier(config, tierRaw),
        transactionId,
        payerPhone,
        notes,
        status: 'pending',
      },
    });

    return this.claimToDto(row);
  }

  async listShopPaymentClaims(shopId: string) {
    const rows = await this.prisma.subscriptionPaymentClaim.findMany({
      where: { shopId },
      orderBy: { createdAt: 'desc' },
      take: 50,
      include: { linkedActivationCode: true },
    });
    return {
      schema_version: 1,
      rows: rows.map((r) => this.claimToDto(r)),
    };
  }

  async listAdminPaymentClaims(statusFilter?: string) {
    const status =
      statusFilter && statusFilter !== 'all' ? statusFilter.trim() : undefined;
    const rows = await this.prisma.subscriptionPaymentClaim.findMany({
      where: status ? { status } : undefined,
      orderBy: { createdAt: 'desc' },
      take: 200,
      include: { linkedActivationCode: true },
    });
    const shopIds = [...new Set(rows.map((r) => r.shopId))];
    const shops = await this.prisma.shop.findMany({
      where: { id: { in: shopIds } },
      select: { id: true, name: true },
    });
    const shopNames = new Map(shops.map((s) => [s.id, s.name]));
    return {
      schema_version: 1,
      rows: rows.map((r) => ({
        ...this.claimToDto(r),
        shop_name: shopNames.get(r.shopId) ?? r.shopId,
      })),
    };
  }

  async getAdminPaymentClaim(id: string) {
    const row = await this.prisma.subscriptionPaymentClaim.findUnique({
      where: { id },
      include: { linkedActivationCode: true },
    });
    if (!row) throw new NotFoundException('payment claim not found');
    const shop = await this.prisma.shop.findUnique({
      where: { id: row.shopId },
      select: { name: true },
    });
    return {
      schema_version: 1,
      ...this.claimToDto(row),
      shop_name: shop?.name ?? row.shopId,
    };
  }

  private claimToDto(
    row: SubscriptionPaymentClaim & {
      linkedActivationCode?: { code: string } | null;
    },
  ) {
    return {
      id: row.id,
      shop_id: row.shopId,
      submitted_by_user_id: row.submittedByUserId,
      plan_tier: row.planTier,
      amount_afn: row.amountAfn,
      transaction_id: row.transactionId,
      payer_phone: row.payerPhone,
      notes: row.notes,
      status: row.status,
      reviewed_at: row.reviewedAt?.toISOString() ?? null,
      review_notes: row.reviewNotes,
      linked_activation_code_id: row.linkedActivationCodeId,
      activation_code: row.linkedActivationCode?.code ?? null,
      created_at: row.createdAt.toISOString(),
    };
  }

  async approvePaymentClaim(
    developerSub: string,
    id: string,
    body: {
      activation_code?: unknown;
      auto_create_code?: unknown;
      plan_days?: unknown;
    },
  ) {
    const row = await this.prisma.subscriptionPaymentClaim.findUnique({
      where: { id },
    });
    if (!row) throw new NotFoundException('payment claim not found');
    if (row.status !== 'pending') {
      throw new BadRequestException('claim is not pending');
    }

    let codeId = row.linkedActivationCodeId;
    let codeStr: string | null = null;

    const manualCode =
      typeof body.activation_code === 'string'
        ? body.activation_code.trim().toUpperCase()
        : '';
    if (manualCode) {
      const ac = await this.prisma.activationCode.findUnique({
        where: { code: manualCode },
      });
      if (!ac || ac.status !== 'active') {
        throw new BadRequestException('activation_code not found or inactive');
      }
      codeId = ac.id;
      codeStr = ac.code;
    } else if (body.auto_create_code === true || body.auto_create_code === 'true') {
      const planDays =
        Number(body.plan_days) > 0
          ? Math.min(Math.max(Number(body.plan_days), 1), 3650)
          : planTierToDays(row.planTier as PlanTier);
      const created = await this.createActivationCodeForClaim(
        developerSub,
        planDays,
        row.shopId,
      );
      codeId = created.id;
      codeStr = created.code;
    } else {
      throw new BadRequestException(
        'provide activation_code or auto_create_code: true',
      );
    }

    const updated = await this.prisma.subscriptionPaymentClaim.update({
      where: { id },
      data: {
        status: 'approved',
        reviewedAt: new Date(),
        reviewedByDeveloperSub: developerSub,
        linkedActivationCodeId: codeId,
      },
      include: { linkedActivationCode: true },
    });

    await this.audit(developerSub, 'payment_claim.approve', {
      claim_id: id,
      shop_id: row.shopId,
      transaction_id: row.transactionId,
      activation_code: codeStr,
    });

    return this.claimToDto(updated);
  }

  async rejectPaymentClaim(
    developerSub: string,
    id: string,
    reviewNotes: string,
  ) {
    const row = await this.prisma.subscriptionPaymentClaim.findUnique({
      where: { id },
    });
    if (!row) throw new NotFoundException('payment claim not found');
    if (row.status !== 'pending') {
      throw new BadRequestException('claim is not pending');
    }

    const updated = await this.prisma.subscriptionPaymentClaim.update({
      where: { id },
      data: {
        status: 'rejected',
        reviewedAt: new Date(),
        reviewedByDeveloperSub: developerSub,
        reviewNotes: reviewNotes.trim() || null,
      },
      include: { linkedActivationCode: true },
    });

    await this.audit(developerSub, 'payment_claim.reject', {
      claim_id: id,
      shop_id: row.shopId,
      transaction_id: row.transactionId,
    });

    return this.claimToDto(updated);
  }
}
