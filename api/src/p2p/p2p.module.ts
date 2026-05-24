import { Module } from '@nestjs/common';

import { PrismaModule } from '../prisma/prisma.module';
import { P2pController } from './p2p.controller';
import { P2pService } from './p2p.service';

@Module({
  imports: [PrismaModule],
  controllers: [P2pController],
  providers: [P2pService],
})
export class P2pModule {}
