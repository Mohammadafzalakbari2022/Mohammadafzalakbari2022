# Plan 25 — Implementation backlog (status vs plans)

This document tracks **what the written plans still imply** versus **what this repository ships**.

## Done in this repo (high level)

| Area | Notes |
|------|--------|
| Nest API + Postgres | Auth, shops, users, licenses, sync push/pull (with order **conflict** responses), health, **catalog public feed + share settings + P2P signaling**, password reset queue, push token storage + **FCM dispatch + license-expiry cron + notification sync push**, **activation codes**, **admin audit log**, **admin stats**. |
| Flutter | API session, settings users, **manual sync (pull + outbox push)**, **sync conflict inspector** (Settings → Sync conflicts), reports/tasks, catalog (local + sync outbox + **remote public feed**), password reset request screen, **developer portal**, push token UI + **cached token re-register on login**. |
| Sync | Pull applier for plan entity types; outbox push; conflict recording on pull skip + push `conflict`; partial outbox clear. |
| Licensing | Redeem via **`activation_codes`** + optional **`PRIDE_LEGACY_REDEEM_CODES`**. |
| Dashboard drawer | Order search, Tasks, KPIs, notifications preview. |
| Shop finance | Reports → Shop finance; Isar + sync entity types. |
| Backup | JSON **v3** export (v1–v3 import) including **catalog items + image binaries** (base64 sidecar in JSON). |
| UX / docs | Stale “coming soon” l10n removed; **AGENTS.md** / **plan-20** aligned with actual codegen stack. |

## Not done (honest backlog)

| Item | Why it remains |
|------|----------------|
| **Invite / code-based shop join** | Intentionally excluded — `POST /shop/join` stays login-shaped. |
| **Supabase Auth + RLS in app** | Intentionally excluded — **Nest + Prisma + JWT** remains canonical; Postgres can be hosted on Supabase. |
| **Dashboard global search** | Intentionally excluded. |
| **Store / prod launch tasks** | Intentionally excluded (`plan-21`) — ops. |
| **Full WebRTC data channel** | Signaling + chunk transfer scaffold exists; native WebRTC peer connection not wired (optional hardening). |

## CI

See [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml) and `TESTING.md`.

## Hosting Q&A (unchanged)

See `plan-07-hosting-devops.md` and `plan-00-index.md`.
