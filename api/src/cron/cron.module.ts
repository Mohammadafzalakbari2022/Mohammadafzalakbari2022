import { Module } from '@nestjs/common';

import { PushModule } from '../push/push.module';
import { CronController } from './cron.controller';

@Module({
  imports: [PushModule],
  controllers: [CronController],
})
export class CronModule {}
