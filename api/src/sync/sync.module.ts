import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { SyncController } from './sync.controller';
import { SyncService } from './sync.service';

@Module({
  imports: [LicenseModule],
  controllers: [SyncController],
  providers: [SyncService],
})
export class SyncModule {}
