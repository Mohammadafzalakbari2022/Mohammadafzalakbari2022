# Pride — implementation backlog (prioritized)

Aligned with `plan-00-index.md`, `plan-25-implementation-backlog.md`, and `AGENTS.md`. Check off items as you ship them.

## P0 — Foundation (server + client contract)

- [x] **`POST /auth/login`** (NestJS in-memory seed + **JWT**) + Flutter login when `API_BASE_URL` is set (`lib/core/api/pride_api_auth.dart`, `lib/auth/login_screen.dart`).
- [x] **Persist API session** — `AuthSessionStorage` + restore in `main.dart` before `runApp`; cleared on mock sign-in, dev bypass, and Settings sign-out (`lib/auth/auth_session_storage.dart`).
- [x] **JWT** + Nest guard on protected routes — **`JwtAuthGuard`** on `/shop/users*`, `/admin/me`, `/sync/*`, **`/license/*`**; `POST /auth/login` and `POST /shop/create` issue **JWT** (`api/src/core/api-core.module.ts`, `auth/jwt-auth.guard.ts`).
- [ ] **Supabase** (RLS, optional managed auth, hosted DB) — not wired; **Nest uses PostgreSQL + Prisma** for shops/users/licenses (`api/prisma/`).
- [x] **`POST /shop/create`** — **Postgres** shop + owner + trial license (`shop-bootstrap.controller.ts`); **`GET/POST/DELETE /shop/users`** owner-only + limits (`shop-users.controller.ts`).
- [x] **`POST /shop/join`** — `plan-04` shop bootstrap; delegates to login (`auth/shop-join.controller.ts`) until invite-based join is specified in plans.

## P1 — Licensing & users (plan-04 / plan-06 / plan-15)

- [x] **`POST /license/redeem`** — **Postgres** per-shop row (non-empty code → `active` +365d stub) + Flutter subscription when `API_BASE_URL` is set (`pride_api_license.dart`, `subscription_screen.dart`).
- [x] **Shop users**: `POST/GET/DELETE /shop/users` + Settings → Users (Flutter) when API + JWT session; owner-only + trial/paid caps enforced on server (**Postgres**).

## P2 — Sync (plan-03 / plan-04)

- [x] **`POST /sync/push`**, **`GET /sync/pull?cursor=`** — Nest **Postgres** append log `shop_sync_mutations` + `shops.last_mutation_revision`; plan-04 **HTTP contract** in `plan-04-backend-api.md` + e2e (`api/src/sync/`).
- [x] **Client manual path** — `pride_api_sync.dart` + **Sync now** in Settings → Sync & diagnostics: pull, push mapped outbox batch, mark accepted rows synced (`lib/core/sync/`). **Not** full replay/merge/conflict UI.
- [ ] **Durable sync (remaining)** — client applies **pull** for **orders/customers/payments/tasks/measurement_type** + **conflict** UI (`plan-03`); **notifications** merged from pull today. Server append log only; tombstones / multi-writer rules TBD.

## P3 — Catalog & P2P (plan-14)

- [ ] **Catalog metadata** on server; `GET /catalog/public`, share flags, mutual opt-in enforcement.
- [ ] **WebRTC signaling** (`POST /p2p/signal`, `GET /p2p/inbox`) + mobile download flow + progress UI.
- [ ] **Replace** `catalogSharingEnabledProvider` dev stub with API-driven shop flag.

## P4 — Developer portal (plan-18)

- [x] **`GET /admin/me`** + Nest `is_developer` via `PRIDE_DEVELOPER_IDS`; Flutter `adminMeProvider` + Settings portal entry (`api/src/admin/`, `lib/auth/admin_me_provider.dart`).
- [ ] **Activation codes, shops, password reset queue** — Nest **`POST/GET /admin/...`** beyond `/me` + replace Flutter placeholder tabs with real API + audit.

## P5 — Ops & launch (plan-07 / plan-08 / plan-21)

- [x] **CI (in repo):** [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml) — `flutter pub get` / `gen-l10n` / `analyze` / `test`, plus **`api/`** `npm ci` / `build` / `test` / `test:e2e` on `main`/`master` PRs and pushes.
- [x] **Deploy runbooks:** Render Blueprint + Postgres in [`render.yaml`](../render.yaml); env + first-login steps in [`api/DEPLOY.md`](../api/DEPLOY.md); smoke in [`TESTING.md`](../TESTING.md) (hosted API).
- [ ] **Play / App Store / Web** checklist: signing, listings, privacy, PWA smoke (`plan-21`).

## P6 — Deferred / nice-to-have

- [ ] **Push notifications** (server-driven; out of wave 1 per `plan-22`).
- [ ] **Backup bundle** including catalog image binaries (`plan-15`).
- [ ] **Dashboard global search** (`plan-09` future).
- [ ] **Password reset request** from login → developer portal flow end-to-end.
