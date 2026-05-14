import { Injectable } from '@nestjs/common';

/** Comma-separated JWT `sub` values that count as developer (`plan-18`). */
@Injectable()
export class AdminService {
  isDeveloperSub(sub: string): boolean {
    const raw = process.env.PRIDE_DEVELOPER_IDS ?? '';
    const ids = raw
      .split(',')
      .map((s) => s.trim())
      .filter((s) => s.length > 0);
    return ids.includes(sub);
  }
}
