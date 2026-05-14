import {
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
import { AdminService } from './admin.service';

@Controller('admin')
export class AdminController {
  constructor(private readonly admin: AdminService) {}

  /** `GET /admin/me` — developer gate (`plan-18`). */
  @Get('me')
  @UseGuards(JwtAuthGuard)
  me(@Req() req: Request & { user: PrideAccessPayload }) {
    return { is_developer: this.admin.isDeveloperSub(req.user.sub) };
  }

  /** `GET /admin/audit-log` — developer-only (`plan-18`). */
  @Get('audit-log')
  @UseGuards(JwtAuthGuard)
  async auditLog(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('limit') limitRaw?: string,
  ) {
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
      throw new ForbiddenException();
    }
    return this.admin.revokeActivationCode(req.user.sub, id);
  }

  /** `GET /admin/password-reset-requests` — pending queue (`plan-18`). */
  @Get('password-reset-requests')
  @UseGuards(JwtAuthGuard)
  async passwordResetRequests(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloperSub(req.user.sub)) {
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
    if (!this.admin.isDeveloperSub(req.user.sub)) {
      throw new ForbiddenException();
    }
    const pw = body?.new_password ?? '';
    await this.admin.resolvePasswordReset(req.user.sub, id, pw);
    return { ok: true };
  }
}
