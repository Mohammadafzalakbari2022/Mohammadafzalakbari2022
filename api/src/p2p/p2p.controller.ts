import {
  Body,
  Controller,
  Get,
  HttpCode,
  HttpStatus,
  Post,
  Query,
  Req,
  UseGuards,
} from '@nestjs/common';
import type { Request } from 'express';

import { JwtAuthGuard } from '../auth/jwt-auth.guard';
import type { PrideAccessPayload } from '../auth/jwt-payload.interface';
import { P2pService } from './p2p.service';

@Controller('p2p')
export class P2pController {
  constructor(private readonly p2p: P2pService) {}

  @Post('signal')
  @HttpCode(HttpStatus.OK)
  @UseGuards(JwtAuthGuard)
  sendSignal(
    @Req() req: Request & { user: PrideAccessPayload },
    @Body() body: unknown,
  ) {
    return this.p2p.sendSignal(req.user.shop_id, body);
  }

  @Get('inbox')
  @UseGuards(JwtAuthGuard)
  pollInbox(
    @Req() req: Request & { user: PrideAccessPayload },
    @Query('session_id') sessionId?: string,
  ) {
    return this.p2p.pollInbox(req.user.shop_id, sessionId);
  }
}
