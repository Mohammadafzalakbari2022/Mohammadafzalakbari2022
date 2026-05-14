# Plan 25 — Implementation backlog (status vs plans)

This document tracks **what the written plans still imply** versus **what this Flutter repository actually ships**, so Q&A and prioritization stay grounded in `AGENTS.md` and `plan-00-index.md`.

## Done in this repo (aligned with plans)

| Area | Plans | Notes |
|------|--------|--------|
| Waves 1–2 | `plan-22`, `plan-23` | Notifications, dashboard preview, internal notes, outbox stub, backup v2, owner password gates — marked shipped in those files. |
| Reports core | `plan-16` | Reports tab, monthly income (calendar month, compare, daily bars), unpaid (delivery filters + sort), delivered by month, payments ledger, money formatting. |
| Tasks | `plan-24` | Settings → Tasks CRUD (offline); optional dashboard shortcut when implemented. |
| Tooling / optional crash | `plan-20` | Env defines, codegen stack, optional Sentry bootstrap. |
| API config (client) | `plan-04`, `plan-20` | `API_BASE_URL` + `GET /health` from Settings → Sync & diagnostics. |
| NestJS + Postgres | `plan-04`, `plan-07` | [`api/`](api/) — `GET /health`, **`GET /license/status`** (per-shop license rows), **`POST /license/redeem`**, **`POST /auth/login`** (JWT), **`POST /shop/create`**, **`POST /shop/join`**, **`/shop/users`**, **`GET /admin/me`**, **`POST /sync/push`** + **`GET /sync/pull`** (JWT; mutations persisted to `shop_sync_mutations` + cursor), CORS, [`render.yaml`](render.yaml). |
| Routing / licensing | `plan-19`, `plan-06` | `go_router`, license read-only paths. |
| API session + shop users (client) | `plan-04`, `plan-15`, `plan-19` | Flutter: persisted session, Settings → Users against live API when `API_BASE_URL` + JWT. |
| Sync scaffold + manual retry | `plan-03`, `plan-04`, `plan-15` | Nest persists mutations; **pull** returns rows. Flutter **Sync now** persists pull cursor, applies **`notification`** upserts/deletes locally; **order/customer/payment/…** pull application + conflict UI still open. |
| Developer portal gate (server) | `plan-18` | `GET /admin/me` + Settings shows portal entry when `is_developer` or debug toggle. |

## Recently closed gaps (Flutter-only, still under `plan-16` / `plan-24`)

- **Reports overview:** “This month income” uses the same **shop calendar system** as other report screens (Gregorian vs solar Hijri month boundaries).
- **Unpaid report:** optional **remaining-balance amount range** filter (plan-16 “by amount range (optional)”).
- **Payments ledger:** **Group by day / week / month** (plan-16 screen 4).
- **Dashboard:** **Tasks** quick link (plan-24 “optional shortcut chip”).
- **API reachability:** compile-time `API_BASE_URL` + **Settings → Sync & diagnostics → Test connection** (`GET /health`, plan-04 / plan-20).
- **NestJS:** `GET /license/status` + shops/users/licenses on **Postgres** (per-shop rows) in [`api/`](api/).
- **Flutter + API:** When `API_BASE_URL` is set, login calls **`POST /auth/login`** and applies `license_snapshot` to the client license notifier; otherwise local mock sign-in unchanged.
- **Session + subscription:** API login fields persisted in **`SharedPreferences`** (restore in `main.dart`); **`POST /license/redeem`** + subscription refresh call the API when configured; background **`GET /license/status`** refresh when JWT session exists.
- **Sync:** Nest **`POST /sync/push`** persists accepted mutations to **`shop_sync_mutations`**; **`GET /sync/pull`** returns deltas by `cursor`. Flutter **Sync now** does not yet **apply** pull rows to Isar (merge/conflict UI still open).

## Not done here — requires Postgres, long builds, or ops (honest backlog)

| Item | Plans | Why it remains open |
|------|--------|---------------------|
| **Client merge of pull + conflicts** | `plan-03`, `plan-04` | **Notifications:** applied on pull. **Orders, customers, payments, tasks, measurement_type:** still ignored on pull; need field/entity merge + conflict UI per `plan-03`. |
| **Invite-based `POST /shop/join`** | `plan-04` | Plan lists join; **invite semantics** are not specified — current join matches login body until the contract is written. |
| Developer portal **admin write APIs** (codes, shops, resets) | `plan-18`, `plan-05` | UI shells exist; **POST/GET admin/** beyond `/admin/me` need DB + audit + role checks. |
| **Catalog + P2P** | `plan-14`, `plan-04` | Metadata tables, signaling, WebRTC client — large vertical. |
| **Production deploy + secrets** | `plan-07`, `plan-21` | Render/Supabase env, signing, store listings — ops, not a single PR. |
| Backup **including catalog binary images** in one bundle | `plan-15` | Planned extension; v2 JSON is data-focused today. |
| Push notifications | `plan-22` out of scope | Server push not in wave 1. |

**CI:** Flutter workflow in [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml) also runs **`api/`** `npm test` + `npm run test:e2e` on pushes/PRs to main/master (see `IMPLEMENTATION_TODO.md` P5).

## How to use this file

- **Product / Q&A:** Treat rows under “Not done here” as **honest dependencies**, not “forgotten” features.
- **Agents:** When closing a gap, update **this file** and the relevant **`plan-NN`** definition of done if the contract changes.

## Hosting Q&A (locked decision)

- **API cold starts:** Accepted for MVP (first request after idle may be slow; fine for dev/pilot).
- **Default stack:** **Free hosting** only — see **`plan-07-hosting-devops.md`** (*Option A*: Supabase free + **Render Free** + **Cloudflare Pages**), locked with **`plan-00-index.md`** free-tier guidance.
- **Paid / business hosting:** Optional upgrade later; **not** the default and **not** implied unless you update the plans explicitly.
