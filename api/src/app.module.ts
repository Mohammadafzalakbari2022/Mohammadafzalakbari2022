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
import { P2pModule } from './p2p/p2p.module';
import { PushModule } from './push/push.module';
import { CronModule } from './cron/cron.module';

/** In-process @Cron only when not on Vercel serverless (use Vercel Cron Jobs in prod). */
const scheduleImports = process.env.VERCEL ? [] : [ScheduleModule.forRoot()];

@Module({
  imports: [
    ...scheduleImports,
    PrismaModule,
    ApiCoreModule,
    LicenseModule,
    ShopModule,
    AuthModule,
    AdminModule,
    SyncModule,
    CatalogModule,
    P2pModule,
    PushModule,
    CronModule,
  ],
  controllers: [AppController],
  providers: [AppService],
})
export class AppModule {}
