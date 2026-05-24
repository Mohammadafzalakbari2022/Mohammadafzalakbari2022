import { Module } from '@nestjs/common';

import { BillingAuditBridge } from '../billing/billing-audit.bridge';
import { BillingModule } from '../billing/billing.module';
import { PushModule } from '../push/push.module';
import { ShopModule } from '../shop/shop.module';
import { SupportAuditBridge } from '../support/support-audit.bridge';
import { SupportModule } from '../support/support.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  imports: [ShopModule, PushModule, BillingModule, SupportModule],
  controllers: [AdminController],
  providers: [AdminService, BillingAuditBridge, SupportAuditBridge],
  exports: [AdminService],
})
export class AdminModule {}
