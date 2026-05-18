import { Module } from '@nestjs/common';

import { BillingAuditBridge } from '../billing/billing-audit.bridge';
import { BillingModule } from '../billing/billing.module';
import { PushModule } from '../push/push.module';
import { ShopModule } from '../shop/shop.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  imports: [ShopModule, PushModule, BillingModule],
  controllers: [AdminController],
  providers: [AdminService, BillingAuditBridge],
  exports: [AdminService],
})
export class AdminModule {}
