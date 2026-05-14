import { AdminService } from './admin.service';
import type { PasswordResetService } from '../shop/password-reset.service';
import type { PrismaService } from '../prisma/prisma.service';

describe('AdminService', () => {
  const prev = process.env.PRIDE_DEVELOPER_IDS;

  const svc = () =>
    new AdminService({} as PrismaService, {} as PasswordResetService);

  afterEach(() => {
    if (prev === undefined) {
      delete process.env.PRIDE_DEVELOPER_IDS;
    } else {
      process.env.PRIDE_DEVELOPER_IDS = prev;
    }
  });

  it('returns false when env unset', () => {
    delete process.env.PRIDE_DEVELOPER_IDS;
    const s = svc();
    expect(s.isDeveloperSub('any')).toBe(false);
  });

  it('matches trimmed sub in comma list', () => {
    process.env.PRIDE_DEVELOPER_IDS = ' u1 , u2 ';
    const s = svc();
    expect(s.isDeveloperSub('u1')).toBe(true);
    expect(s.isDeveloperSub('u2')).toBe(true);
    expect(s.isDeveloperSub('u3')).toBe(false);
  });
});
