import type { LicenseSnapshotStatus } from '../license/license.types';

/** Trial shops: total active users including owner (`plan-04`). */
export const SHOP_USER_LIMIT_TRIAL = 2;

/** Default / minimum paid seat cap stored on `shops.max_users`. */
export const SHOP_USER_LIMIT_PAID_DEFAULT = 5;

/** Minimum paid seat cap (admin + stored value). */
export const SHOP_USER_LIMIT_PAID_MIN = 1;

/** Maximum paid seat cap (admin portal + enforcement). */
export const SHOP_USER_LIMIT_PAID_MAX = 20;

export function clampPaidShopMaxUsers(raw: number): number {
  const n = Math.floor(Number(raw));
  if (!Number.isFinite(n)) return SHOP_USER_LIMIT_PAID_DEFAULT;
  return Math.min(
    Math.max(n, SHOP_USER_LIMIT_PAID_MIN),
    SHOP_USER_LIMIT_PAID_MAX,
  );
}

/**
 * Effective max active users for a shop (owner + team), by license.
 * Trial ignores `shopMaxUsers`; paid uses clamped DB value.
 */
export function resolveMaxUsers(
  licenseStatus: LicenseSnapshotStatus,
  shopMaxUsers: number,
): number {
  if (licenseStatus === 'trial_active') return SHOP_USER_LIMIT_TRIAL;
  if (licenseStatus === 'expired') return 0;
  return clampPaidShopMaxUsers(shopMaxUsers);
}

export function isTrialLicenseStatus(
  licenseStatus: LicenseSnapshotStatus,
): boolean {
  return licenseStatus === 'trial_active';
}
