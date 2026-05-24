import {
  BadRequestException,
  Injectable,
  NotFoundException,
} from '@nestjs/common';
import type { AppSupportConfig } from '@prisma/client';

import { PrismaService } from '../prisma/prisma.service';

const SUPPORT_CONFIG_ID = 'default';

@Injectable()
export class SupportService {
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

  private async getConfigRow() {
    return this.prisma.appSupportConfig.findUnique({
      where: { id: SUPPORT_CONFIG_ID },
    });
  }

  private configToDto(row: AppSupportConfig, opts: { publishedOnly: boolean }) {
    return {
      schema_version: 1,
      is_published: row.isPublished,
      developer_name: row.developerName,
      developer_title: row.developerTitle,
      developer_bio: row.developerBio,
      support_email: row.supportEmail,
      support_phone: row.supportPhone,
      support_whatsapp: row.supportWhatsapp,
      help_video_url: row.helpVideoUrl,
      updated_at: row.updatedAt.toISOString(),
      ...(opts.publishedOnly
        ? {}
        : { updated_by_developer_sub: row.updatedByDeveloperSub }),
    };
  }

  private emptyAdminDto() {
    return {
      schema_version: 1,
      is_published: false,
      developer_name: null,
      developer_title: null,
      developer_bio: null,
      support_email: null,
      support_phone: null,
      support_whatsapp: null,
      help_video_url: null,
      updated_at: null,
      updated_by_developer_sub: null,
    };
  }

  async getPublishedSupportInfo() {
    const row = await this.getConfigRow();
    if (!row || !row.isPublished) {
      throw new NotFoundException('support info not published');
    }
    return this.configToDto(row, { publishedOnly: true });
  }

  async getAdminSupportInfo() {
    const row = await this.getConfigRow();
    if (!row) return this.emptyAdminDto();
    return this.configToDto(row, { publishedOnly: false });
  }

  private cleanNullableString(v: unknown): string | null {
    if (v === null) return null;
    if (v === undefined) return null;
    const s = String(v).trim();
    return s.length === 0 ? null : s;
  }

  private assertHttpUrlOrNull(v: string | null, field: string) {
    if (v == null) return;
    const t = v.trim();
    if (!/^https?:\/\//i.test(t)) {
      throw new BadRequestException(`${field} must start with http:// or https://`);
    }
  }

  async upsertAdminSupportInfo(
    developerSub: string,
    body: Record<string, unknown>,
  ) {
    const existing = await this.getConfigRow();

    const isPublished =
      body.is_published === undefined
        ? (existing?.isPublished ?? false)
        : Boolean(body.is_published);

    const helpVideoUrl = this.cleanNullableString(body.help_video_url);
    this.assertHttpUrlOrNull(helpVideoUrl, 'help_video_url');

    const row = await this.prisma.appSupportConfig.upsert({
      where: { id: SUPPORT_CONFIG_ID },
      create: {
        id: SUPPORT_CONFIG_ID,
        isPublished,
        developerName: this.cleanNullableString(body.developer_name),
        developerTitle: this.cleanNullableString(body.developer_title),
        developerBio: this.cleanNullableString(body.developer_bio),
        supportEmail: this.cleanNullableString(body.support_email),
        supportPhone: this.cleanNullableString(body.support_phone),
        supportWhatsapp: this.cleanNullableString(body.support_whatsapp),
        helpVideoUrl,
        updatedByDeveloperSub: developerSub,
      },
      update: {
        isPublished,
        developerName: this.cleanNullableString(body.developer_name),
        developerTitle: this.cleanNullableString(body.developer_title),
        developerBio: this.cleanNullableString(body.developer_bio),
        supportEmail: this.cleanNullableString(body.support_email),
        supportPhone: this.cleanNullableString(body.support_phone),
        supportWhatsapp: this.cleanNullableString(body.support_whatsapp),
        helpVideoUrl,
        updatedByDeveloperSub: developerSub,
      },
    });

    await this.audit(developerSub, 'support_config.update', {
      is_published: row.isPublished,
      has_video: Boolean(row.helpVideoUrl && row.helpVideoUrl.trim()),
      has_email: Boolean(row.supportEmail && row.supportEmail.trim()),
      has_phone: Boolean(row.supportPhone && row.supportPhone.trim()),
      has_whatsapp: Boolean(row.supportWhatsapp && row.supportWhatsapp.trim()),
    });

    return this.configToDto(row, { publishedOnly: false });
  }
}

