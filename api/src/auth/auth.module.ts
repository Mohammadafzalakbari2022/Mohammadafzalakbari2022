import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { ShopModule } from '../shop/shop.module';
import { AuthController } from './auth.controller';
import { AuthService } from './auth.service';
import { ShopJoinController } from './shop-join.controller';

@Module({
  imports: [ShopModule, LicenseModule],
  controllers: [AuthController, ShopJoinController],
  providers: [AuthService],
  exports: [AuthService],
})
export class AuthModule {}
