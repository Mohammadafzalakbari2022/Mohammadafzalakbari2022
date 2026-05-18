# Afghan Pride — In-App Developer/Admin Portal Plan

You want the admin portal **inside the same Flutter app**, visible only when you sign in with a specific developer account.

## Security posture (important)
Hiding UI is not security. The **server must enforce developer-only access**.

## Recommended approach

### Developer allowlist
On server side, mark developer accounts by one of:
- `is_developer = true` on the user record (set only by you)
- allowlist table keyed by email/user_id

### Client behavior
- After login, client calls `GET /admin/me` (or similar) to confirm developer role
- If developer:
  - show “Developer Portal” entry in Settings
  - enable admin routes

## Developer portal UX (in-app)

### Entry point
- Settings → **Developer Portal** (only visible when `is_developer` is confirmed by server)
- Also support deep-link route (still guarded server-side)

### Global rules
- All actions require a fresh developer check (JWT + server-side `is_developer`)
- Show environment badge (dev/staging/prod) to avoid mistakes
- Every action writes an audit log

## Screens (MVP for the portal)

### 1) Overview dashboard
Shows:
- total shops
- active vs expired shops
- trials running
- activations redeemed today/this week
- API health status (simple ping)

### 2) Activation codes
Capabilities:
- Create activation code:
  - plan type: 1 year / 2 year / lifetime
  - optional: assign to a specific shop at creation time
  - single-use enforced server-side
- List/search codes:
  - by code
  - by status (unused/redeemed/expired/revoked)
- View code details:
  - created_by, created_at
  - redeemed_by_shop_id, redeemed_at

### 3) Shops & licenses
Capabilities:
- List shops:
  - shop name, created_at
  - user count (must enforce max 5)
  - license status + expires_at
  - last_successful_check_at
  - last sync timestamp (if tracked)
- Shop detail:
  - users list (username/phone/email)
  - current license snapshot (server)
  - activation history
- Actions (guarded + audited):
  - revoke/disable shop (rare abuse)
  - extend license (admin action) or apply a new code

### 4) Developer diagnostics (support)
Capabilities:
- View recent API errors (if stored)
- Download/Share “diagnostics bundle” from device (client-side)
  - last sync errors, outbox stats, last license snapshot, app version

### 5) Subscription billing (Hesab Pay MVP)
Capabilities:
- Edit global Hesab Pay profile (account, prices, localized steps, contacts)
- Publish / unpublish instructions for all shops
- Review payment claims queue (pending → approve with auto-created code, or reject)

### 6) Password reset requests (manual support)
No SMS/email reset. Developer handles resets via portal.
Capabilities:
- View password reset requests (shop_id + username + requested_at)
- Issue password reset (sets a new password; audited)
- Mark request resolved

## API endpoints needed (developer-only)
- `GET /admin/me`
- `POST /admin/activation-codes`
- `GET /admin/activation-codes`
- `GET /admin/activation-codes/:code`
- `GET /admin/shops`
- `GET /admin/shops/:shopId`
- `POST /admin/shops/:shopId/disable` (optional)
- `POST /admin/shops/:shopId/extend-license` (optional; audited)
- `GET /admin/password-resets`
- `POST /admin/password-resets/:requestId/reset`

## Portal sections (phase-able)

### 1) Licensing & subscription management (core)
- Create activation codes
  - plan type: 1 year / 2 year / lifetime
  - duration, expiration, single-use
- Redeem history / audit
- Shop license status

### 2) Shop management (ops)
- View shops + users (count, created date, last sync)
- Disable a shop (rare, abuse)

### 3) Support tooling
- Export diagnostics bundle (logs + sync errors) from a device
- Search orders by internal_id/display_order_no (future)

## Audit logging (required)
All admin actions must record:
- who did it (developer user id)
- when
- what changed (before/after summary)

