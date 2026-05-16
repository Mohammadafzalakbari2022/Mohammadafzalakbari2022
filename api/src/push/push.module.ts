import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { FcmPushService } from './fcm-push.service';
import { LicenseExpiryPushCronService } from './license-expiry-push.cron.service';
import { PushDispatchService } from './push-dispatch.service';

@Module({
  imports: [LicenseModule],
  providers: [FcmPushService, PushDispatchService, LicenseExpiryPushCronService],
  exports: [PushDispatchService, FcmPushService],
})
export class PushModule {}
