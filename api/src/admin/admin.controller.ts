import {
  Body,
  Controller,
  ForbiddenException,
  Get,
  HttpCode,
  HttpStatus,
  Post,
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

  /** `GET /admin/audit-log` — placeholder for developer portal (`plan-18`). */
  @Get('audit-log')
  @UseGuards(JwtAuthGuard)
  auditLog(@Req() req: Request & { user: PrideAccessPayload }) {
    if (!this.admin.isDeveloperSub(req.user.sub)) {
      throw new ForbiddenException();
    }
    return { schema_version: 1, rows: [] };
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
}
