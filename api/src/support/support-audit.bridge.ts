import { Injectable, OnModuleInit } from '@nestjs/common';

import { AdminService } from '../admin/admin.service';
import { SupportService } from './support.service';

/** Connects support config audit events to `AdminAuditLog` without circular imports. */
@Injectable()
export class SupportAuditBridge implements OnModuleInit {
  constructor(
    private readonly admin: AdminService,
    private readonly support: SupportService,
  ) {}

  onModuleInit(): void {
    this.support.setAuditCallback((developerSub, action, payload) =>
      this.admin.appendAudit(developerSub, action, payload),
    );
  }
}

