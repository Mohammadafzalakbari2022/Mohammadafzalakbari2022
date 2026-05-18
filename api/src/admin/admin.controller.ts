import {
  BadRequestException,
  Body,
  Controller,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Param,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { BillingService } from '../billing/billing.service';
import { PushDispatchService } from '../push/push-dispatch.service';
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(
    private readonly admin: AdminService,
    private readonly pushDispatch: PushDispatchService,
    private readonly billing: BillingService,
  ) {}

  /** `GET /admin/me` — developer gate (`plan-18`). */
  @Get('me')
  @UseGuards(JwtAuthGuard)
  me(@Req() req: Request & { user: PrideAccessPayload }) {
    return { is_developer: this.admin.isDeveloper(req.user) };
  }

  /** `POST /admin/me/password` — change own password (developer portal only). */
  @Post('me/password')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async changeMyPassword(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: { current_password?: string; new_password?: string },
  ): Promise<{ ok: true }> {
    await this.admin.changeDeveloperOwnPassword(
      req.user,
      body?.current_password ?? '',
      body?.new_password ?? '',
    );
    return { ok: true };
  }

  /** `GET /admin/audit-log` — developer-only (`plan-18`). */
  @Get('audit-log')
  @UseGuards(JwtAuthGuard)
  async auditLog(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('limit') limitRaw?: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const parsed = Number(limitRaw ?? '100');
    const limit = Number.isFinite(parsed) ? parsed : 100;
    const rows = await this.admin.listAuditLog(limit);
    return {
      schema_version: 2,
      rows: rows.map((r) => ({
        id: r.id,
        developer_sub: r.developerSub,
        action: r.action,
        payload: r.payload,
        created_at: r.createdAt.toISOString(),
      })),
    };
  }

  /** `GET /admin/stats` — developer-only aggregate counts (`plan-18`). */
  @Get('stats')
  @UseGuards(JwtAuthGuard)
  async stats(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.getStats();
  }

  /** `POST /admin/report` — developer-only JSON echo for tooling. */
  @Post('report')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  report(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: unknown,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const echo =
      body === null || typeof body !== 'object' || Array.isArray(body)
        ? {}
        : (body as Record<string, unknown>);
    return { ok: true, echo };
  }

  /** `GET /admin/shops` — developer-only shop directory (`plan-18`). */
  @Get('shops')
  @UseGuards(JwtAuthGuard)
  async shops(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return {
      schema_version: 1,
      shops: await this.admin.listShopsSummary(),
    };
  }

  /** `GET /admin/activation-codes` — developer-only (`plan-18`). */
  @Get('activation-codes')
  @UseGuards(JwtAuthGuard)
  async activationCodes(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const rows = await this.admin.listActivationCodes();
    return {
      schema_version: 1,
      rows: rows.map((r) => ({
        id: r.id,
        code: r.code,
        status: r.status,
        max_uses: r.maxUses,
        uses_count: r.usesCount,
        plan_days: r.planDays,
        expires_at: r.expiresAt?.toISOString() ?? null,
        assigned_shop_id: r.assignedShopId,
        created_at: r.createdAt.toISOString(),
        redeemed_at: r.redeemedAt?.toISOString() ?? null,
        last_redeemed_shop_id: r.lastRedeemedShopId,
      })),
    };
  }

  /** `POST /admin/activation-codes` — create (`plan-18`). */
  @Post('activation-codes')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async createActivationCode(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body()
    body: {
      plan_days?: unknown;
      max_uses?: unknown;
      assigned_shop_id?: unknown;
      expires_at?: unknown;
    },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.createActivationCode(req.user.sub, body ?? {});
  }

  /** `POST /admin/activation-codes/:id/revoke` — revoke (`plan-18`). */
  @Post('activation-codes/:id/revoke')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async revokeActivationCode(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('id') id: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.revokeActivationCode(req.user.sub, id);
  }

  /** `GET /admin/password-reset-requests` — pending queue (`plan-18`). */
  @Get('password-reset-requests')
  @UseGuards(JwtAuthGuard)
  async passwordResetRequests(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return {
      schema_version: 1,
      rows: await this.admin.listPendingPasswordResets(),
    };
  }

  /** `POST /admin/password-reset-requests/:id/resolve` — set user password and close request. */
  @Post('password-reset-requests/:id/resolve')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async resolvePasswordReset(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('id') id: string,
    @Body() body: { new_password?: string },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const pw = body?.new_password ?? '';
    await this.admin.resolvePasswordReset(req.user.sub, id, pw);
    return { ok: true };
  }

  /** `POST /admin/shops/:shopId/disable` — block logins and sync (`plan-05`). */
  @Post('shops/:shopId/disable')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async disableShop(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('shopId') shopId: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.disableShop(req.user.sub, shopId);
  }

  /** `POST /admin/shops/:shopId/enable` — undo disable. */
  @Post('shops/:shopId/enable')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async enableShop(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('shopId') shopId: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.enableShop(req.user.sub, shopId);
  }

  /** `POST /admin/shops/:shopId/extend-license` — extend paid window (`plan-05`). */
  @Post('shops/:shopId/extend-license')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async extendShopLicense(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('shopId') shopId: string,
    @Body() body: { add_days?: unknown },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.admin.extendShopLicense(req.user.sub, shopId, body?.add_days);
  }

  /** `GET /admin/billing-info` — developer edits global Hesab Pay profile. */
  @Get('billing-info')
  @UseGuards(JwtAuthGuard)
  async getBillingInfo(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('locale') locale?: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.billing.getAdminBillingInfo(locale);
  }

  /** `PUT /admin/billing-info` — upsert singleton billing config. */
  @Post('billing-info')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async putBillingInfo(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: Record<string, unknown>,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.billing.upsertAdminBillingInfo(req.user.sub, body ?? {});
  }

  /** `GET /admin/payment-claims` — developer payment claim queue. */
  @Get('payment-claims')
  @UseGuards(JwtAuthGuard)
  async listPaymentClaims(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('status') status?: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.billing.listAdminPaymentClaims(status);
  }

  /** `GET /admin/payment-claims/:id` */
  @Get('payment-claims/:id')
  @UseGuards(JwtAuthGuard)
  async getPaymentClaim(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('id') id: string,
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.billing.getAdminPaymentClaim(id);
  }

  /** `POST /admin/payment-claims/:id/approve` */
  @Post('payment-claims/:id/approve')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async approvePaymentClaim(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('id') id: string,
    @Body()
    body: {
      activation_code?: unknown;
      auto_create_code?: unknown;
      plan_days?: unknown;
    },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    return this.billing.approvePaymentClaim(req.user.sub, id, body ?? {});
  }

  /** `POST /admin/payment-claims/:id/reject` */
  @Post('payment-claims/:id/reject')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async rejectPaymentClaim(
    @Req() req: Request & { user: PrideAccessPayload },
    @Param('id') id: string,
    @Body() body: { review_notes?: unknown },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const notes = String(body?.review_notes ?? '');
    return this.billing.rejectPaymentClaim(req.user.sub, id, notes);
  }

  /**
   * `POST /admin/push/shop` — send FCM notification to every registered device token
   * for the shop (`plan-22`). Requires `FIREBASE_SERVICE_ACCOUNT_JSON` on the API host.
   */
  @Post('push/shop')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  async pushShop(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body()
    body: {
      shop_id?: unknown;
      title?: unknown;
      body_text?: unknown;
      data?: unknown;
    },
  ) {
    if (!this.admin.isDeveloper(req.user)) {
      throw new ForbiddenException();
    }
    const shopId = String(body.shop_id ?? '').trim();
    const title = String(body.title ?? '').trim();
    const text = String(body.body_text ?? '').trim();
    if (!shopId || !title || !text) {
      throw new BadRequestException('shop_id, title, and body_text are required');
    }
    const data =
      body.data !== undefined &&
      body.data !== null &&
      typeof body.data === 'object' &&
      !Array.isArray(body.data)
        ? (body.data as Record<string, unknown>)
        : undefined;
    const result = await this.pushDispatch.sendToShop(shopId, title, text, data);
    await this.admin.appendAudit(req.user.sub, 'push.shop', {
      shop_id: shopId,
      title,
      body_len: text.length,
      ...result,
    });
    return { schema_version: 1, ...result };
  }
}
