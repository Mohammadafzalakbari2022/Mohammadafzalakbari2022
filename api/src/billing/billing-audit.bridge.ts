import { Injectable, OnModuleInit } from '@nestjs/common';

import { AdminService } from '../admin/admin.service';
import { BillingService } from './billing.service';

/** Connects billing audit events to `AdminAuditLog` without circular imports. */
@Injectable()
export class BillingAuditBridge implements OnModuleInit {
  constructor(
    private readonly admin: AdminService,
    private readonly billing: BillingService,
  ) {}

  onModuleInit(): void {
    this.billing.setAuditCallback((developerSub, action, payload) =>
      this.admin.appendAudit(developerSub, action, payload),
    );
  }
}
