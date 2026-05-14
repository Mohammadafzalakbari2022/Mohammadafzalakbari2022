import { Module } from '@nestjs/common';

import { LicenseModule } from '../license/license.module';
import { LoginResponseFactory } from '../auth/login-response.factory';
import { DevicesController } from './devices.controller';
import { PasswordResetService } from './password-reset.service';
import { ShopBootstrapController } from './shop-bootstrap.controller';
import { ShopRegistryService } from './shop-registry.service';
import { ShopUsersController } from './shop-users.controller';

@Module({
  imports: [LicenseModule],
  controllers: [
    ShopBootstrapController,
    ShopUsersController,
    DevicesController,
  ],
  providers: [ShopRegistryService, LoginResponseFactory, PasswordResetService],
  exports: [ShopRegistryService, LoginResponseFactory, PasswordResetService],
})
export class ShopModule {}
