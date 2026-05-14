import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { LoginResponseFactory } from '../auth/login-response.factory';
import { ShopBootstrapController } from './shop-bootstrap.controller';
import { ShopRegistryService } from './shop-registry.service';
import { ShopUsersController } from './shop-users.controller';

@Module({
  imports: [LicenseModule],
  controllers: [ShopBootstrapController, ShopUsersController],
  providers: [ShopRegistryService, LoginResponseFactory],
  exports: [ShopRegistryService, LoginResponseFactory],
})
export class ShopModule {}
