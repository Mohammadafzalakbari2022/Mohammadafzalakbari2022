import { Module } from '@nestjs/common';

import { BillingModule } from '../billing/billing.module';
import { LicenseController } from './license.controller';
import { LicenseService } from './license.service';

@Module({
  imports: [BillingModule],
  controllers: [LicenseController],
  providers: [LicenseService],
  exports: [LicenseService],
})
export class LicenseModule {}
