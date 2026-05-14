# Plan 25 — Implementation backlog (status vs plans)

This document tracks **what the written plans still imply** versus **what this repository ships**.

## Done in this repo (high level)

| Area | Notes |
|------|--------|
| Nest API + Postgres | Auth, shops, users, licenses, sync push/pull, health, catalog public stub, password reset queue, push token storage, **activation codes**, **admin audit log**, **admin stats**. |
| Flutter | API session, settings users, manual sync, reports/tasks, catalog (local + sync outbox), password reset request screen, **developer portal** (overview + stats/audit, activation codes CRUD, shops+licenses list, password reset queue, diagnostics), push token UI. |
| Sync | Pull applier for plan entity types including **measurement_profile** and **catalog_item**; outbox push mappings for those and other entities. |
| Licensing | Redeem via **`activation_codes`** table or **`PRIDE_LEGACY_REDEEM_CODES`** (default includes `pilot-2026`). |

## Not done (honest backlog)

| Item | Why it remains |
|------|----------------|
| **Sync conflict inspector UI** | LWW on orders; no full merge UI (`plan-03`). |
| **Invite-based `POST /shop/join`** | Contract not finalized; join matches login today (`plan-04`). |
| **Catalog P2P + public server feed** | WebRTC/signaling + rich public catalog beyond local/sync (`plan-14`). |
| **Supabase as product** (RLS, managed auth) | Stack is Nest+Prisma; DB can be any Postgres URI including Supabase. |
| **Server push “send” pipeline** | Tokens stored; FCM/APNs broadcast not implemented (`plan-22`). |
| **Backup with catalog binaries** | JSON backup path exists; binary bundle extension (`plan-15`). |
| **Store / prod launch tasks** | Signing, listings, privacy (`plan-21`) — ops. |
| **Dashboard global search** | Deferred (`plan-09`). |

## CI

See [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml) and `TESTING.md` for Flutter + API commands.

## Hosting Q&A (unchanged)

See `plan-07-hosting-devops.md` and `plan-00-index.md` for free-tier defaults and cold-start expectations.
