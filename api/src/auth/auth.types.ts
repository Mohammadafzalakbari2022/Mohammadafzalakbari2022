import type { LicenseStatusDto } from '../license/license.types';

/** `POST /auth/login` body — `plan-04-backend-api.md` (shop-scoped login). */
export interface LoginRequestBody {
  shop_id?: string;
  username: string;
  password: string;
}

/** `POST /auth/login` success JSON (until refresh tokens are implemented). */
export interface LoginResponseBody {
  access_token: string;
  refresh_token: string | null;
  license_snapshot: LicenseStatusDto;
  user: {
    id: string;
    shop_id: string;
    username: string;
    is_shop_owner: boolean;
  };
}
