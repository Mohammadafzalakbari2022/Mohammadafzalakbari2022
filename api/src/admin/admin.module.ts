import { Module } from '@nestjs/common';

import { PushModule } from '../push/push.module';
import { ShopModule } from '../shop/shop.module';
import { AdminController } from './admin.controller';
import { AdminService } from './admin.service';

@Module({
  imports: [ShopModule, PushModule],
  controllers: [AdminController],
  providers: [AdminService],
})
export class AdminModule {}
