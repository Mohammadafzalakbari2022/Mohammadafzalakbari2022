import {
  clampPaidShopMaxUsers,
  resolveMaxUsers,
  SHOP_USER_LIMIT_PAID_MAX,
  SHOP_USER_LIMIT_TRIAL,
} from './shop-user-limits.helper';

describe('shop-user-limits.helper', () => {
  it('trial always returns 2', () => {
    expect(resolveMaxUsers('trial_active', 99)).toBe(SHOP_USER_LIMIT_TRIAL);
  });

  it('expired returns 0', () => {
    expect(resolveMaxUsers('expired', 5)).toBe(0);
  });

  it('paid uses clamped shop max', () => {
    expect(resolveMaxUsers('active', 5)).toBe(5);
    expect(resolveMaxUsers('active', 8)).toBe(8);
    expect(resolveMaxUsers('active', 99)).toBe(SHOP_USER_LIMIT_PAID_MAX);
    expect(resolveMaxUsers('active', 0)).toBe(1);
  });

  it('clampPaidShopMaxUsers bounds 1–20', () => {
    expect(clampPaidShopMaxUsers(5)).toBe(5);
    expect(clampPaidShopMaxUsers(0)).toBe(1);
    expect(clampPaidShopMaxUsers(100)).toBe(20);
    expect(clampPaidShopMaxUsers(NaN)).toBe(5);
  });
});
