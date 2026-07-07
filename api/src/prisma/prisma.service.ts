import { Injectable, Logger, OnModuleDestroy, OnModuleInit } from '@nestjs/common';
import { PrismaClient } from '@prisma/client';

@Injectable()
export class PrismaService extends PrismaClient implements OnModuleInit, OnModuleDestroy {
  private readonly log = new Logger(PrismaService.name);
  private connectPromise: Promise<void> | null = null;

  async onModuleInit(): Promise<void> {
    // On Vercel serverless, defer DB connect so /health can respond even if
    // Prisma engine or pooler is slow on first cold start.
    if (process.env.VERCEL) {
      return;
    }
    await this.ensureConnected();
  }

  async ensureConnected(): Promise<void> {
    if (!this.connectPromise) {
      this.connectPromise = this.$connect().catch((error) => {
        this.connectPromise = null;
        this.log.error(`Prisma connect failed: ${String(error)}`);
        throw error;
      });
    }
    await this.connectPromise;
  }

  async onModuleDestroy(): Promise<void> {
    await this.$disconnect();
  }
}
