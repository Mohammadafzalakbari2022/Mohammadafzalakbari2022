import { Global, Module } from '@nestjs/common';

import { PrismaService } from './prisma.service';
import { AppSeedService } from './app-seed.service';

@Global()
@Module({
  providers: [PrismaService, AppSeedService],
  exports: [PrismaService],
})
export class PrismaModule {}
