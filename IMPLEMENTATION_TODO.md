# Pride — implementation backlog (prioritized)

Aligned with `plan-00-index.md`, `plan-25-implementation-backlog.md`, and `AGENTS.md`.

## P0 — Foundation (server + client contract)

- [x] **`POST /auth/login`** + Flutter login when `API_BASE_URL` is set.
- [x] **Offline login** — local SHA-256 verifier after first online login.
- [x] **Bundled defaults** — style figures + catalog designs on device.
- [x] **Persist API session** — restore / clear paths wired.
- [x] **JWT** + guards on protected routes.
- [ ] **Supabase-managed RLS / optional managed auth** — **excluded**; Nest + Postgres + Prisma ships.
- [x] **`POST /shop/create`**, **`POST /shop/join`** (login-shaped; invite flow excluded).

## P1 — Licensing & users

- [x] **`POST /license/redeem`**
- [x] **Shop users** — API + Settings UI when JWT session.

## P2 — Sync (plan-03 / plan-04)

- [x] **`POST /sync/push`**, **`GET /sync/pull`**, manual Sync, inbound applier, outbox from UI.
- [x] **Conflict inspector UI** — Settings → Sync conflicts; server returns `conflict` for stale order pushes.

## P3 — Catalog & P2P (plan-14)

- [x] **Local catalog** + sync outbox for catalog items.
- [x] **Server public catalog feed** — `GET /catalog/public/feed`, share settings, item share index, P2P signaling API; Flutter remote feed + share sync.

## P4 — Developer portal (plan-18)

- [x] Admin API + Flutter tabs wired.

## P5 — Ops & launch

- [x] **CI** — Flutter + API unit + e2e where configured.
- [x] **Deploy runbooks**
- [ ] **Play / App Store / Web production checklist (`plan-21`)** — **excluded** (ops).

## P6 — Deferred / excluded by product decision

- [ ] **Invite / QR shop join** — excluded.
- [ ] **Dashboard global search** — excluded.
- [x] **Server-driven push delivery (FCM)** — dispatch on new orders + notification sync + license-expiry cron; client caches token and re-registers on login (`FIREBASE_SERVICE_ACCOUNT_JSON` on API).
- [x] **Backup bundle including catalog image binaries** — backup JSON v3.
- [x] **Password reset request** + developer resolve + audit.
