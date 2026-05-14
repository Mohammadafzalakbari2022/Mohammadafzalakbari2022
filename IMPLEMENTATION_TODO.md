# Pride — implementation backlog (prioritized)

Aligned with `plan-00-index.md`, `plan-25-implementation-backlog.md`, and `AGENTS.md`.

## P0 — Foundation (server + client contract)

- [x] **`POST /auth/login`** + Flutter login when `API_BASE_URL` is set.
- [x] **Persist API session** — restore / clear paths wired.
- [x] **JWT** + guards on protected routes.
- [ ] **Supabase-managed RLS / optional managed auth** — not the default path; **Nest + Postgres + Prisma** is what ships (`api/prisma/`). Hosted Postgres (e.g. Supabase connection string) works as the database only.
- [x] **`POST /shop/create`**, **`POST /shop/join`** (login-shaped until invite spec exists).

## P1 — Licensing & users

- [x] **`POST /license/redeem`** — DB-backed **`activation_codes`** + optional **`PRIDE_LEGACY_REDEEM_CODES`** (default `pilot-2026`) for dev/e2e.
- [x] **Shop users** — API + Settings UI when JWT session.

## P2 — Sync (plan-03 / plan-04)

- [x] **`POST /sync/push`**, **`GET /sync/pull`**, manual Sync in Settings, inbound applier for plan entity types including **`measurement_profile`** and **`catalog_item`**, outbox from UI for those entities.
- [ ] **Conflict inspector UI** — orders use `server_updated_at` LWW skip; no dedicated merge/conflict screen yet.

## P3 — Catalog & P2P (plan-14)

- [x] **Local catalog** + sync outbox for catalog items.
- [ ] **Server public catalog feed + WebRTC P2P download** — large vertical; `GET /catalog/public` remains minimal vs full plan-14.

## P4 — Developer portal (plan-18)

- [x] **`GET /admin/me`**, **`GET /admin/stats`**, **`GET/POST /admin/activation-codes`**, **`POST .../revoke`**, **`GET /admin/shops`** (with license summary), **`GET/POST` password reset queue**, **`GET /admin/audit-log`** (persisted rows), Flutter tabs wired (Overview stats + audit expansion, Codes, Shops, Resets, Diagnostics).

## P5 — Ops & launch

- [x] **CI** — Flutter + API unit + e2e where configured.
- [x] **Deploy runbooks** — `api/DEPLOY.md`, `render.yaml`, smoke notes in `TESTING.md`.
- [ ] **Play / App Store / Web** production checklist (`plan-21`) — signing, listings, privacy, PWA smoke (ops).

## P6 — Deferred / larger scope

- [ ] **Server-driven push delivery** (FCM/APNs send path) — device **token registration** exists; full delivery pipeline not done.
- [ ] **Backup bundle including catalog image binaries** (`plan-15` extension).
- [ ] **Dashboard global search** (`plan-09`) — deferred when timeboxed.
- [x] **Password reset request** (login → queue) + **developer resolve** + audit.
