/** Matches `plan-04-backend-api.md` license status snapshot (server contract). */
export type LicenseSnapshotStatus = 'trial_active' | 'active' | 'expired';

export interface LicenseStatusDto {
  status: LicenseSnapshotStatus;
  expires_at: string;
  server_now: string;
  last_successful_check_at: string;
}
