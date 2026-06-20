# Afghan Pride — Full System Plan Index

This is the **detailed, production-grade plan** split into focused documents.

## Hosting reality check (Free tiers)

### Supabase
- **Supabase managed** is a great fit for your size. The free tier is usually enough for early MVP testing, but plan for upgrade once you have real shops/data.

### Railway (API hosting)
- **Possible “almost free”** for very small usage, but not reliably “free forever”.
- Expect **monthly credit limits** and the risk of throttling or cost if traffic grows.

### Recommended “free-ish” API hosting alternatives (when Railway isn’t enough)
- **Render Free Web Service**: simplest Git deploy, but it can **sleep** and cold start.
- **Fly.io free allowance**: can be more “always-on”, but typically requires a credit card and more setup.

### Frontend (Flutter Web) hosting
If you want a free place for optional Web builds (mostly for UI testing):
- **Cloudflare Pages** (very strong free tier for static hosting)
- **Vercel** or **Netlify** (also good; bandwidth/build minute limits apply)

## Reading order
1. `plan-01-architecture.md`
2. `plan-02-data-model.md`
3. `plan-03-sync-offline.md`
4. `plan-04-backend-api.md`
5. `plan-06-security-licensing.md`
6. `plan-05-admin-portal.md`
7. `plan-07-hosting-devops.md`
8. `plan-08-qa-release.md` (testing, QA, release checklist)
9. `plan-09-ui-dashboard.md` (dashboard UI plan)
10. `plan-10-ui-design-system.md` (global UI tokens + dialogs/notifications/feedback)
11. `plan-11-ui-order-composer.md` (single-screen new order flow)
12. `plan-12-ui-orders-module.md` (orders list + details + payments + status flow)
13. `plan-13-ui-customers-module.md` (customers list + customer profile + today orders)
14. `plan-14-ui-catalog.md` (catalog UI + local images + P2P sharing)
15. `plan-15-ui-settings.md` (settings UI + owner-only controls + backup/restore/password confirms)
16. `plan-16-ui-reports.md` (reports tab + monthly income + unpaid)
17. `plan-17-localization-rtl.md` (localization system + RTL/LTR rules + QA checklist)
18. `plan-18-ui-developer-portal.md` (developer portal UI + flows)
19. `plan-19-ui-routes-navigation-map.md` (implementation-ready routes + guards + navigation)
20. `plan-20-flutter-tooling-and-environments.md` (dev/staging/prod API URLs, codegen, Cursor build rules)
21. `plan-21-launch-deployment.md` (Play / App Store / web deploy, signing, listings, privacy, branding pack)
22. `plan-22-implementation-wave-1.md` (cross-plan implementation waves — e.g. notifications inbox + dashboard)
23. `plan-23-implementation-wave-2.md` (order internal notes + sync-queue stub bumps)
24. `plan-24-ui-tasks-todo.md` (simple offline-first tasks / to‑do list)
25. `plan-25-implementation-backlog.md` (remaining work: in-repo vs backend / ops)
26. `plan-27-offline-license-performance.md` (offline license cache, developer exemption, perf)
27. `plan-28-ui-orders-composer-compact.md` (compact receipt composer: search fix, density, post-save)

**Agent / implementation contract:** [`AGENTS.md`](AGENTS.md) — non-negotiable rules for humans and AI when writing code in this repo (stack, offline-first, guards, l10n). Use it together with the `plan-NN-*.md` contracts.

**Closure / resume work:** [`docs/PROJECT_HANDOFF.md`](docs/PROJECT_HANDOFF.md) — builds, CI, offline login, bundled assets, DB notes, deferred backlog.

**Testing (commands + Android/Web):** [`TESTING.md`](TESTING.md).

Notes:
- `plan-14-ui-catalog-module.md` is an older draft; `plan-14-ui-catalog.md` is the canonical Catalog plan.
- **Plan audit (resolved):** `plan-09-ui-dashboard.md` previously listed four bottom tabs (missing **Reports**); it now matches `plan-01`, `plan-10`, `plan-16`, and `plan-19` (five tabs including Reports).

## Ground rules (decisions already made)
- **Flutter targets (engineering)**: **Web + Android + iOS** — all three must stay compile-correct; platform-guard features that differ per target (`AGENTS.md`).
- **Manual testing (today)**: **Android + Web**, frontend-first; iOS checked on a Mac or CI before release when the dev machine is Windows-only.
- **Offline DB**: Isar (mobile)
- **Backend**: Supabase + custom API (TypeScript)
- **Admin portal**: inside Flutter app, visible only to developer account(s)

