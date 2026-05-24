# Afghan Pride — agent / AI coding contract

This file applies **only to this repository**. Humans and automated agents must follow it during implementation so behavior stays consistent with `plan-00-index.md` through **`plan-25-implementation-backlog.md`** and `plans.md`.

## How I work (product owner testing vs. engineering targets)

- **I** (the product owner) currently **manual-test on Android and Web only**, and mostly the **Flutter frontend** (no full backend required to iterate on UI/navigation).
- **You** (the AI / developers) still **design, guard, and ship code for all three Flutter targets: Web, Android, and iOS.** Do not treat iOS as optional in architecture, navigation, safe areas, Cupertino/Material behavior, or `Platform.isIOS` / `defaultTargetPlatform` branches. When I cannot run an iOS build locally (e.g. Windows), keep **iOS compile-clean** in CI or verify on a Mac before release; never merge iOS-breaking API usage without a platform abstraction.

## Non-negotiables

1. **Plans are law** — If code disagrees with an agreed plan, fix the code (or escalate and update the plan first). Do not invent alternate auth, storage, or navigation without a documented plan change.

2. **Offline-first** — Local **Isar** is the source of truth on device; sync follows `plan-03-sync-offline.md`. UI must tolerate offline; show sync state honestly.

3. **No Supabase Auth in the app** — Login is **custom NestJS API** (shop-scoped username/password). Supabase = Postgres + RLS + optional realtime; **anon key only** in the client, never service role.

4. **Secrets** — No production secrets in source. API base URL and Supabase public values come from **`dart-define` or flavors** (`plan-20`). Document run/build commands per environment.

5. **Codegen stack** — **`isar_generator`** is in active use for local entities. **Riverpod**, repositories, and API DTOs are mostly hand-written today; adopt **riverpod_generator**, **freezed**, and **json_serializable** only when touching a module that already uses them or when a plan explicitly calls for codegen there (`plan-20`). Do **not** add Drift/SQLite unless the plan explicitly changes.

6. **Navigation** — **`go_router`** with guards per `plan-19-ui-routes-navigation-map.md` (auth, license read-only, developer portal).

7. **Strings & RTL** — No hardcoded user-facing copy. Use ARB + `intl` and directional layout per `plan-17-localization-rtl.md`.

8. **Platform guards** — Catalog camera/gallery, printing, Bluetooth, P2P: branch on **`kIsWeb`** / `defaultTargetPlatform` where behavior differs. Web may lack some hardware features; **still keep web builds compiling** and show a clear “not available on web” state where needed. **iOS and Android** get full intended behavior behind the same guards.

9. **Three Flutter targets** — Every feature change must **remain valid for `TargetPlatform.iOS`, `TargetPlatform.android`, and `Web`** at compile time. Use conditional imports or `kIsWeb` / `Theme.of(context).platform` where APIs differ. Do not land code that only runs on one mobile OS without documenting the exception in a plan update.

10. **Licensing** — Enforce read-only mode when expired except subscription/settings paths per licensing plans; respect server time and grace rules in client UX.

11. **Owner password** — Destructive or high-risk actions (e.g. delete user, backup restore, mark delivered, cancel order) require **owner password** confirmation as specified in order/settings plans—not a second arbitrary PIN.

12. **Payments** — **Append-only** ledger; reversals are new rows, not silent edits.

13. **Orders UX** — List = filters + table, **no row quick actions**; detail screen owns status changes and confirmations. Saved orders are **editable on all statuses** (including delivered/cancelled). Payments: append-only ledger; total editable when `newTotal ≥ paid`. Confirmations: type **customer name** to delete or cancel an order; simple dialog for other edits and status changes (no owner password on orders).

14. **One module at a time** — Small, reviewable changes. After meaningful edits: **`flutter analyze`** (and tests when they exist).

15. **API alignment** — REST shapes and names follow **`plan-04-backend-api.md`** (single canonical catalog-sharing block). If the server diverges, update server **and** plan together.

16. **Bottom navigation** — Tabs: **Orders, Customers, Catalog, Reports, Settings** only. **Dashboard** is edge-swipe / optional hamburger, not a fifth tab (`plan-09`, `plan-16`).

## Before starting a task

- Read the relevant `plan-NN-*.md` sections and any tables/schemas they reference.
- Check `plan-20` pre-coding checklist for env and codegen expectations.

## Reduce AI / agent mistakes (workflow)

These rules exist so the model **stops guessing** and **proves** changes.

1. **Read before edit** — Open the full file (or surrounding region) you will change; match existing style, imports, and patterns.
2. **No speculative deletions** — Do not remove imports, parameters, or `const` to silence the analyzer without understanding the root cause.
3. **ARB first for UI copy** — Add strings to `lib/l10n/app_en.arb`, run `flutter gen-l10n`, use `AppLocalizations.of(context)!` in widgets.
4. **Router changes are sensitive** — After editing `lib/router/**`, verify auth redirect, license redirect, and tab deep links still behave (`plan-19`).
5. **One concern per patch** — Avoid mixing unrelated refactors with a bugfix.
6. **Report what ran** — In the chat reply, state whether `flutter analyze` / `flutter test` / `flutter gen-l10n` were executed and the outcome.

Human and agent **testing commands** and Android/Web setup: see **[`TESTING.md`](TESTING.md)**.

## Definition of done (agent)

- **`flutter analyze`** clean for the project (or explain blockers).
- **`flutter test`** passing if tests exist or were modified.
- If ARB changed: **`flutter gen-l10n`** run and generated files consistent.
- No new hardcoded user-visible strings without l10n.
- Plans and `AGENTS.md` updated if behavior or contracts intentionally change.
