# Afghan Pride — Security & Licensing Plan (Full System)

## Threats to address
- Sharing activation codes
- Using app after subscription expiry
- Unauthorized cross-shop access
- Developer portal misuse if routes are discovered

## Core security controls

### 1) Row Level Security (RLS) in Supabase
- Every table must be scoped by `shop_id`
- Policies enforce: user can only read/write rows matching their `shop_id`

### 1b) Local-first audit log (selected)
- Record audit events locally first (Isar), then sync to server when online.
- Audit events include:
  - user added/removed
  - order status changes (cancelled/delivered/etc.)
  - activation redemption / license changes
  - backup restore performed

### 2) Server-enforced licensing
Client UI must not be the enforcement point.
- API returns license status for the shop
- API denies sync push/pull (or restricts) when expired, per your business rules

### 2b) Subscription-enforced user limits (selected)
- Trial shops: **max 2 users** (fixed)
- Paid shops: **max `shops.max_users`** per shop (default **5**; developer portal can set **1–20**)
- Enforcement must be server-side (API), not only UI.

Owner-only account management (selected)
- Each shop has an **owner/admin** account (e.g., `is_shop_owner = true`).
- The shop creator becomes the initial owner automatically.
- Only the owner can:
  - create users (username + password)
  - remove users
- All users can still use business features (no cashier/limited roles), but user management stays owner-controlled.

Permissions update (selected)
- All users have full CRUD access for day-to-day business data:
  - customers
  - customer measurement profiles
  - orders (within the locking rules after delivered/cancelled)
  - style selections (design/style figures attached to orders)

Owner-only controls remain limited to:
- user management (create/remove users)
- subscription/activation management
- backup/restore actions

Owner password confirmation (selected)
For destructive or high-risk actions, require the **owner’s login password** confirmation:
- delete user
- restore backup
- cancel order
- mark order as delivered

Notes:
- Apply to owner only (normal users cannot perform these destructive actions anyway).
- Works offline by validating against the cached offline credential verifier (after seeding).

Owner deletion rule (selected)
- The **owner account must not be deletable**.
- Ownership transfer is **not supported** (selected):
  - the shop owner/admin is permanent for that shop
  - owner can create/remove users, but ownership itself does not change

### 3) Activation code rules
- single use
- can be tied to a shop at redemption time
- store redemption audit trail

### 4) Developer portal gating
- API checks developer role (allowlist / is_developer flag)
- Never ship service role keys in client

## License behavior design (choose one)

### Option A (recommended)
- Expired shops:
  - can still access local data (read-only)
  - cannot sync
  - cannot create new orders

### Option B (stricter)
- Expired shops:
  - blocked from app except subscription screen
  - still can export backup (if you want goodwill) OR block it

## Selected enforcement rule (per product decision)
If the shop is **trial-expired** or **subscription-expired**:
- The entire app enters **READ-ONLY mode**:
  - disable all create/update/delete actions
  - disable all sync operations (push/pull)
  - allow browsing/searching/printing/sharing of existing local data (read-only)
- **Only the Subscription screen remains interactive** to enter an activation code and refresh license status.

This keeps the app useful for reference while ensuring paid features require renewal.

## Client caching & offline
- Cache last known license status locally
- Define “grace period” behavior when offline and license cannot be rechecked
  - e.g., allow offline work for N days since last successful check

### Selected grace period
- **3 days grace period** after the `last_successful_check_at` when the device is offline and cannot refresh license status.
- After the grace window passes without a successful server check, enter **READ-ONLY mode** (except Subscription) until the app can refresh license status online.

## Offline expiration tracking (must-have)

### Goals
- Enforce expiry even when offline
- Reduce abuse via device clock changes
- Avoid accidentally locking out honest users due to temporary connectivity issues

### Trial start rule (selected)
- Trial (15 days) starts at **first successful online registration/login** using **server time**.
- Offline installs before first online check operate as “unverified”:
  - require an online check to start trial and unlock full editing
  - once verified, client caches the license snapshot for offline enforcement

### Local state (stored in Isar, signed if possible)
- `last_license_snapshot`:
  - status (trial_active/active/expired)
  - `expires_at` (server time)
  - `last_successful_check_at` (server time)
  - `shop_id`
- `device_time_anchors` (anti-tamper):
  - `last_seen_device_time`
  - `last_seen_monotonic_uptime` (elapsed time since boot, if available)
  - `suspected_time_tamper` flag

### Evaluation rules (client-side gate)
- If status is expired ⇒ enable READ-ONLY mode immediately.
- If offline and status is active:
  - compare current device time against `expires_at` and against anchored progression
  - if current time > expires_at ⇒ READ-ONLY mode
- If offline and license cannot be rechecked:
  - allow editing only while `now <= last_successful_check_at + 3 days`
  - once exceeded ⇒ READ-ONLY mode (except Subscription) until successful refresh
- If `suspected_time_tamper` is detected:
  - immediately restrict to READ-ONLY (except Subscription) until a successful server check resolves it.

### Server authority (Supabase + API)
- API must always treat licensing as authoritative:
  - deny sync push/pull when expired (or return “read-only” response)
  - return current license snapshot on login and on explicit refresh
- Store audit logs:
  - activation redemption, license changes, suspicious clock signals (optional)

### UX requirements
- Always show a clear banner when in READ-ONLY:
  - “Subscription expired. Renew to continue editing.”
  - show expiry date and last verified time
- Subscription page supports:
  - activation code entry
  - “Refresh status” action
  - contact/support instructions (if needed)

