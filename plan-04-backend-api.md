# Afghan Pride — Backend API Plan (Supabase + NestJS TypeScript)

## Why a custom API (even with Supabase)
- Central place for business rules (licensing, code redemption, shop limits)
- Safer than shipping secrets/business logic in client
- Stable sync endpoints (batch push/pull) optimized for mobile

## Stack recommendation
- **NestJS (TypeScript)** for:
  - strong structure (modules/controllers/services)
  - validation + guards
  - long-term maintainability

## Responsibilities split

### Supabase does
- Postgres data storage
- Row Level Security (RLS) enforcement
- Realtime (optional later)

### Custom API does
- Authentication (username + password, offline-first)
- License/activation code redemption
- Shop/user limit enforcement (trial: 2 users; paid: 5 users)
- Sync endpoints (push/pull, conflict responses)
- Admin-only endpoints (generate codes, view subscriptions)
- Webhooks handling (future payments/provider integrations)

## Auth model (selected: custom API auth to support offline login)

### Online login
- Client sends `shop_id` (or shop code) + `username` + `password` to API
- API verifies password hash and returns:
  - short-lived access token (JWT)
  - refresh token (if used)
  - current `license_snapshot`

### Offline login
- After first successful online login, client caches:
  - minimal user record (user_id, shop_id, username, is_shop_owner)
  - password verifier (secure hash) or an offline-safe credential token
- Offline login validates against the cached verifier and opens the app in offline mode.

First-time device rule (selected)
- A brand-new install/device must complete **one successful online login** to seed credentials.
- Before seeding, offline login is not available.

### Username uniqueness rule (selected)
- `username` is unique **within a shop only**.
- No cross-shop uniqueness checks.

## Core API endpoints (initial)

### Health
- `GET /health`

### Shop bootstrap
- `POST /shop/create`
- `POST /shop/join`

Owner rule (selected):
- The user who calls `POST /shop/create` becomes the **shop owner** (`is_shop_owner = true`).
- The owner is the only account allowed to manage users for the shop.

### User management (shop admin inside app)
Owner/admin of the shop manages users from inside the app.

Endpoints (authenticated; must enforce shop scope + limits):
- `POST /shop/users` (create user: username + password)
- `GET /shop/users` (list users)
- `DELETE /shop/users/:userId` (remove user)

Access rule (selected):
- Only the **shop owner/admin** account can manage users (create/list/remove).
- Normal users have full business access, but **cannot** manage accounts.
- The **owner account cannot be deleted**.
- Ownership transfer is not supported (owner is permanent for the shop).

User limits (server-side enforcement):
- trial_active: max **2** users
- active (paid): max **5** users

Password reset (selected)
- No SMS/email password reset.
- User requests reset in login screen → request is visible to developer/admin tooling.
- Developer/admin tooling issues a reset (manual process) and user receives the new password via support.

### Sync
- `POST /sync/push` (batch upserts/deletes)
- `GET /sync/pull?cursor=...` (delta changes)

#### Sync HTTP contract (v1 scaffold; in-memory until Postgres)

**Auth:** both endpoints require `Authorization: Bearer <JWT>`. All mutations apply to the JWT’s `shop_id` only (ignore any `shop_id` inside `data` for authorization; server uses the token).

**License:** if `GET /license/status` would return `status: "expired"`, both endpoints respond **403** with JSON body `{ "error": "license_expired", "message": "..." }` and the client must not retry until license is valid again (`plan-03`).

---

**`POST /sync/push`**

Request body:

```json
{
  "mutations": [
    {
      "internal_id": "<uuid|ulid string>",
      "entity_type": "order|customer|payment|notification|measurement_type|task",
      "operation": "upsert|delete",
      "client_updated_at": "<ISO-8601 instant>",
      "data": {}
    }
  ]
}
```

Rules:
- `mutations` is required; may be an empty array (heartbeat / cursor bump).
- `data` is required for `operation: "upsert"` (may be `{}`); ignored for `delete`.
- `entity_type` must be one of the literals above (extend later per `plan-02`).

Response **200:**

```json
{
  "server_now": "<ISO-8601>",
  "results": [
    {
      "internal_id": "<same as request>",
      "status": "accepted|conflict|rejected",
      "message": null
    }
  ],
  "next_cursor": "<opaque string; client may store as pull cursor hint>"
}
```

Scaffold behavior: server returns `accepted` for every well-formed mutation and does not persist rows yet. `conflict` / `rejected` are reserved for when the real merge engine exists (`plan-03`).

---

**`GET /sync/pull?cursor=<string>`**

Query:
- `cursor` optional. Opaque token returned by the last successful **pull** or **push** (`next_cursor`). Omit or empty string means “from beginning” for that shop.

Response **200:**

```json
{
  "server_now": "<ISO-8601>",
  "changes": [
    {
      "internal_id": "<string>",
      "entity_type": "order|customer|payment|notification|measurement_type|task",
      "operation": "upsert|delete",
      "server_updated_at": "<ISO-8601>",
      "data": {}
    }
  ],
  "next_cursor": "<opaque string>"
}
```

Scaffold behavior: `changes` is always an empty array until server-side history exists; `next_cursor` still advances so clients can test cursor plumbing.

### Licensing
- `POST /license/redeem` (activation code)
- `GET /license/status`
- `GET /license/billing-info` (published Hesab Pay profile; optional `?locale=`)
- `POST /license/payment-claims` (shop **owner** only: submit transaction ID)
- `GET /license/payment-claims` (shop owner: own claim history)

License status contract (important for offline):
- Response must include:
  - `status` (trial_active/active/expired)
  - `expires_at` (server time)
  - `server_now` (server time)
  - `last_successful_check_at` (server time; set to server_now)
- Trial rule:
  - Trial (15 days) starts at **first successful online registration/login** (server time)
  - API must compute and return correct snapshot even if client was installed offline earlier

### Catalog sharing (canonical; P2P; no image blobs on server)

Responsibilities:
- Store shared catalog **metadata** only (design name, shop name as designer label, dates, flags)
- Provide WebRTC **signaling** (offer/answer/ICE); never store or proxy image binaries

Endpoints (implement one consistent set; names may be adjusted in NestJS routing):
- `POST /catalog/share-settings` — set shop-level `sharing_enabled` (mutual opt-in gate)
- `GET /catalog/public` — public directory metadata; **requires** caller shop `sharing_enabled=true`
- `POST /catalog/items/:id/share` — mark one catalog item shared/unshared (metadata index)
- `POST /p2p/signal` — send WebRTC signaling payload to peer session
- `GET /p2p/inbox` — poll pending signaling messages for current shop/user/session

Rules:
- Mutual opt-in: caller must have sharing enabled to use `GET /catalog/public`.
- Public directory entries carry watermark label: **creator shop name**.
- Downloads are **P2P**; no sender approval required; both parties must be online for transfer.

### Admin (developer-only)
- `POST /admin/activation-codes`
- `GET /admin/shops`
- `GET /admin/licenses`
- `GET /admin/billing-info` / `POST /admin/billing-info` (upsert singleton Hesab Pay profile)
- `GET /admin/payment-claims` (optional `?status=pending|all`)
- `GET /admin/payment-claims/:id`
- `POST /admin/payment-claims/:id/approve` (`activation_code` or `auto_create_code`)
- `POST /admin/payment-claims/:id/reject` (`review_notes`)

## Data access & safety
- API uses a **service role key** only on the server
- Still keep RLS where practical; API should not become “god mode” without checks

## Hosting
- Deploy on Railway (budget), but plan a backup option:
  - Render (free but sleeping)
  - Fly.io (more setup)

