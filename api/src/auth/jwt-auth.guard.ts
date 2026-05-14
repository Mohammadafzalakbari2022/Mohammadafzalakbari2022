import {
  CanActivate,
  ExecutionContext,
  Injectable,
  UnauthorizedException,
} from '@nestjs/common';
import { JwtService } from '@nestjs/jwt';

import type { PrideAccessPayload } from './jwt-payload.interface';

@Injectable()
export class JwtAuthGuard implements CanActivate {
  constructor(private readonly jwt: JwtService) {}

  canActivate(context: ExecutionContext): boolean {
    const req = context.switchToHttp().getRequest<{ headers: Record<string, unknown> }>();
    const raw = req.headers['authorization'];
    const h = typeof raw === 'string' ? raw : Array.isArray(raw) ? raw[0] : '';
    if (!h.startsWith('Bearer ')) {
      throw new UnauthorizedException();
    }
    const token = h.slice(7).trim();
    if (!token) throw new UnauthorizedException();
    try {
      const payload = this.jwt.verify<PrideAccessPayload>(token);
      (req as unknown as { user: PrideAccessPayload }).user = payload;
      return true;
    } catch {
      throw new UnauthorizedException();
    }
  }
}
