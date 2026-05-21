import { AdminService } from './admin.service';
import type { PasswordResetService } from '../shop/password-reset.service';
import type { ShopRegistryService } from '../shop/shop-registry.service';
import type { ShopUserLimitsService } from '../shop/shop-user-limits.service';
import type { PrismaService } from '../prisma/prisma.service';

describe('AdminService', () => {
  const prevIds = process.env.PRIDE_DEVELOPER_IDS;
  const prevUsers = process.env.PRIDE_DEVELOPER_USERS;

  const svc = () =>
    new AdminService(
      {} as PrismaService,
      {} as PasswordResetService,
      {} as ShopRegistryService,
      {} as ShopUserLimitsService,
    );

  afterEach(() => {
    if (prevIds === undefined) delete process.env.PRIDE_DEVELOPER_IDS;
    else process.env.PRIDE_DEVELOPER_IDS = prevIds;
    if (prevUsers === undefined) delete process.env.PRIDE_DEVELOPER_USERS;
    else process.env.PRIDE_DEVELOPER_USERS = prevUsers;
  });

  it('returns false when env unset', () => {
    delete process.env.PRIDE_DEVELOPER_IDS;
    delete process.env.PRIDE_DEVELOPER_USERS;
    const s = svc();
    expect(s.isDeveloper({ sub: 'x', shop_id: 's', username: 'u', is_shop_owner: false })).toBe(
      false,
    );
  });

  it('matches trimmed sub in comma list', () => {
    process.env.PRIDE_DEVELOPER_IDS = ' u1 , u2 ';
    delete process.env.PRIDE_DEVELOPER_USERS;
    const s = svc();
    expect(s.isDeveloperSub('u1')).toBe(true);
    expect(s.isDeveloper({ sub: 'u1', shop_id: 's', username: 'u', is_shop_owner: false })).toBe(
      true,
    );
  });

  it('PRIDE_DEVELOPER_USERS matches shop_id and username', () => {
    delete process.env.PRIDE_DEVELOPER_IDS;
    process.env.PRIDE_DEVELOPER_USERS = 'dev|Akbari, other|x';
    const s = svc();
    expect(
      s.isDeveloper({
        sub: 'any',
        shop_id: 'dev',
        username: 'Akbari',
        is_shop_owner: false,
      }),
    ).toBe(true);
    expect(
      s.isDeveloper({
        sub: 'any',
        shop_id: 'dev',
        username: 'Other',
        is_shop_owner: false,
      }),
    ).toBe(false);
  });
});
