# Plan 25 — Implementation backlog (status vs plans)

This document tracks **what the written plans still imply** versus **what this repository ships**.

## Done in this repo (high level)

| Area | Notes |
|------|--------|
| Nest API + Postgres | Auth, shops, users, licenses, sync push/pull, health, catalog public stub, password reset queue, push token storage, **activation codes**, **admin audit log**, **admin stats**. |
| Flutter | API session, settings users, **manual sync (pull + outbox push)**, reports/tasks, catalog (local + sync outbox), password reset request screen, **developer portal** (overview + stats/audit, activation codes CRUD, shops+licenses list, password reset queue, diagnostics), push token UI. **Login with shop id uses `POST /shop/join`**; login without shop id uses `POST /auth/login`. |
| Sync | Pull applier for plan entity types including **measurement_profile** and **catalog_item**; outbox push mappings; **Settings → Sync “Run sync”** runs pull then push and clears accepted outbox rows. |
| Licensing | Redeem via **`activation_codes`** table or **`PRIDE_LEGACY_REDEEM_CODES`** (default includes `pilot-2026`). |
| Dashboard drawer | Order search → `/app/orders?q=…`, **Tasks** quick link, KPIs, overdue / today deliveries, notifications preview (`plan-09`, `plan-24`). |
| Shop finance | Reports → **Shop finance** (rent, expenses, charts); Isar + sync entity types `shop_rent`, `shop_rent_payment`, `shop_expense`; rent-due in-app notifications. |
| UX polish (2026-05) | Sign-out navigation fix; dashboard shop branding + sync-now; default Dari locale; new-order customer flow; UI/notification sounds; developer portal refresh on login. |

## Not done (honest backlog)

| Item | Why it remains |
|------|----------------|
| **Sync conflict inspector UI** | LWW on orders; no full merge UI when server rejects or diverges (`plan-03`). |
| **Invite / code-based shop join** | `POST /shop/join` today equals login (same body/response); **no invite token / QR flow** yet (`plan-04`). |
| **Catalog P2P + public server feed** | WebRTC/signaling + rich public catalog beyond local/sync (`plan-14`). |
| **Supabase as product** (RLS, managed auth) | Stack is Nest+Prisma; DB can be any Postgres URI including Supabase. |
| **Server push “send” pipeline** | Tokens stored; FCM/APNs broadcast not implemented (`plan-22`). |
| **Backup with catalog binaries** | JSON backup path exists; binary bundle extension (`plan-15`). |
| **Store / prod launch tasks** | Signing, listings, privacy (`plan-21`) — ops. |
| **Dashboard global search (beyond orders)** | Orders: drawer search → `/app/orders?q=…` is **shipped**. Broader “search everything” still deferred (`plan-09`). |

## CI

See [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml) and `TESTING.md` for Flutter + API commands.

## Hosting Q&A (unchanged)

See `plan-07-hosting-devops.md` and `plan-00-index.md` for free-tier defaults and cold-start expectations.
