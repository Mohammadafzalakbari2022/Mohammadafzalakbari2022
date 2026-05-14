import type { LicenseSnapshotStatus, LicenseStatusDto } from './license.types';

/** Maps persisted license row + clock to `GET /license/status` DTO (`plan-04`). */
export function licenseStatusDtoFromRow(
  row: { statusStored: string; expiresAt: Date },
  now: Date,
): LicenseStatusDto {
  const serverNow = now.toISOString();
  let status = row.statusStored as LicenseSnapshotStatus;
  if (now.getTime() > row.expiresAt.getTime()) {
    status = 'expired';
  }
  return {
    status,
    expires_at: row.expiresAt.toISOString(),
    server_now: serverNow,
    last_successful_check_at: serverNow,
  };
}
