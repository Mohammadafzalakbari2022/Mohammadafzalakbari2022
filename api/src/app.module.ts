import { Module } from '@nestjs/common';
import { ScheduleModule } from '@nestjs/schedule';
import { AppController } from './app.controller';
import { AppService } from './app.service';
import { AuthModule } from './auth/auth.module';
import { ApiCoreModule } from './core/api-core.module';
import { LicenseModule } from './license/license.module';
import { ShopModule } from './shop/shop.module';
import { AdminModule } from './admin/admin.module';
import { SyncModule } from './sync/sync.module';
import { PrismaModule } from './prisma/prisma.module';
import { CatalogModule } from './catalog/catalog.module';

@Module({
  imports: [
    ScheduleModule.forRoot(),
    PrismaModule,
    ApiCoreModule,
    LicenseModule,
    ShopModule,
    AuthModule,
    AdminModule,
    SyncModule,
    CatalogModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
