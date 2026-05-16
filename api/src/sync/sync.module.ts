import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { PushModule } from '../push/push.module';
import { SyncController } from './sync.controller';
import { SyncService } from './sync.service';

@Module({
  imports: [LicenseModule, PushModule],
  controllers: [SyncController],
  providers: [SyncService],
})
export class SyncModule {}
