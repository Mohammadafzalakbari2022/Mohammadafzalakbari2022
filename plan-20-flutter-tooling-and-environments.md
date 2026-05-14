# Afghan Pride — Flutter Tooling, Environments & API Base URLs

This document locks **dev → staging → production** configuration and **codegen** choices for implementation.

## Environment progression (selected)

1. **dev** — daily development; fast iteration; disposable data.
2. **staging** — production-like builds for your **Android + Web** testing before release.
3. **prod** — real shops; only after staging sign-off.

Flow: build and integrate in **dev**, then point builds at **staging** for QA, then **prod** when ready.

## API base URL strategy (selected)

- One **NestJS API** per environment (e.g. Railway), each with its own base URL.
- Flutter reads base URL from **compile-time** configuration (not hardcoded in Dart source):

### Recommended mechanism

- **Dart defines** (or Flutter flavors) mapping:
  - `API_BASE_URL` — REST API root (e.g. `https://api-dev.example.com`)
  - `SUPABASE_URL` / `SUPABASE_ANON_KEY` — public client keys only (never service role in app)

**Flutter wiring:** `API_BASE_URL` is read at compile time in `lib/core/api/pride_api_config.dart`. **Settings → Sync & diagnostics** can call `GET {API_BASE_URL}/health` (see `lib/core/api/pride_api_health.dart`) to verify the server is reachable before full sync is implemented (plan-04).

Example (conceptual):

- dev: `--dart-define=ENV=dev` + `--dart-define=API_BASE_URL=...`
- staging: `--dart-define=ENV=staging` + ...
- prod: `--dart-define=ENV=prod` + ...

Optional: use **Flutter flavors** (`dev` / `staging` / `prod`) with different `main_*.dart` entrypoints that call `load()` for env-specific constants — same idea, easier for CI.

### Rules

- Never commit production secrets.
- Document in README (or internal doc) the exact `flutter run` / `flutter build` commands per environment.
- Staging must use **staging Supabase project** + **staging API** so tests never touch prod data.

## Supabase per environment

- Separate Supabase projects: **dev**, **staging**, **prod** (already aligned with `plan-07-hosting-devops.md`).

## Codegen & packages (selected)

Use **build_runner**-driven codegen for consistency and fewer mistakes:

| Purpose | Package |
|--------|---------|
| State + providers | `flutter_riverpod` + **`riverpod_annotation`** + **`riverpod_generator`** |
| Immutable models / unions | **`freezed`** + `freezed_annotation` |
| JSON (DTOs, API payloads) | **`json_serializable`** + `json_annotation` |
| Local DB (mobile) | **`isar`** + **`isar_generator`** + `isar_flutter_libs` |

Run after model/provider changes:

```bash
dart run build_runner build --delete-conflicting-outputs
```

(Use `watch` during heavy codegen sessions if you prefer.)

### Not in scope by default

- **Drift** (SQLite): not needed; **Isar** is the chosen offline store (`plan-02-data-model.md`). Do not add Drift unless you explicitly change strategy.

### Confirmed stack (typo “Tiber” → use this)

Use **only** the packages in the table above—no separate “Tiber” package. **Freezed** + **json_serializable** + **riverpod_generator** + **isar_generator** is the approved fit for Riverpod, Isar, sync DTOs, and maintainable codegen.

Optional (recommended when implementing): **`custom_lint`** + **`riverpod_lint`** for Riverpod-specific static analysis.

## Cursor / AI build rules (reference for implementation)

When implementation starts, builders should:

- Follow **`plan-19-ui-routes-navigation-map.md`** for navigation and guards.
- Follow **`plan-17-localization-rtl.md`** — no hardcoded user-facing strings.
- **Offline-first**: local (Isar) first; sync via API per `plan-03-sync-offline.md`.
- **Platform guards**: `kIsWeb` / `defaultTargetPlatform` for catalog camera, printing, Bluetooth, P2P where needed.
- **Three Flutter targets**: keep **Web, Android, and iOS** compile-correct; product owner may test Android + Web first, but do not ship iOS-breaking code (`AGENTS.md`).
- **One module at a time**; small PR-sized slices; run `flutter analyze` after meaningful changes.
- **Android + Web + iOS**: enable **web** in Flutter config; iOS builds require macOS/Xcode (use CI or a Mac when the dev machine is Windows-only).

## Definition of Done (tooling)

- `flutter doctor` clean for Android + Web on your machine.
- Three env configs documented with `dart-define` or flavors.
- Codegen pipeline documented and runnable in one command.

## Pre-coding consistency checklist (plans + stack)

Before writing feature code, confirm these are aligned (no contradictions in docs):

| Area | Canonical doc | Must match |
|------|----------------|------------|
| Environments | This file (`plan-20`) | dev / staging / prod; separate Supabase + API per env (`plan-07`) |
| API surface | `plan-04-backend-api.md` | Single catalog-sharing section; sync/auth/licensing as specified |
| Auth & offline | `plan-04`, `plan-03-sync-offline.md` | Custom API auth; one online login seeds offline |
| Data model | `plan-02-data-model.md` | Isar on device; server schema via migrations |
| Navigation & guards | `plan-19-ui-routes-navigation-map.md` | `go_router`; auth, license read-only, developer gates |
| Localization | `plan-17-localization-rtl.md` | ARB + `intl`; no hardcoded user strings |
| Catalog UI | `plan-14-ui-catalog.md` | Camera/gallery not web; P2P; sharing toggle in Catalog |
| Tooling / codegen | This file | Riverpod + freezed + json_serializable + isar_generator only (no Drift unless plan changes) |

**Machine verification (run locally before heavy coding):**

1. `flutter doctor -v` — Android toolchain OK; **Web** enabled (`flutter config --enable-web` if needed).
2. If Android shows **cmdline-tools missing**: install via Android Studio (SDK Manager → Android SDK Command-line Tools) or [Google’s standalone CLI tools](https://developer.android.com/studio#command-line-tools-only); set `ANDROID_HOME` if needed.
3. If **Android licenses** are unknown: run `flutter doctor --android-licenses` and accept.
4. `dart --version` / `flutter --version` — note in README or team doc.
5. iOS: full builds require **macOS + Xcode**; on Windows, document “iOS CI or Mac later” and do not block Android/Web.
6. After `flutter create` / first clone: `flutter pub get` then `dart run build_runner build --delete-conflicting-outputs` once models exist.

**Current snapshot (example):** Flutter stable + Web/Chrome OK; `flutter analyze` clean after `pub get`. Resolve any `flutter doctor` Android warnings before relying on `flutter build apk` in CI.

**AI / agent contract:** follow root [`AGENTS.md`](AGENTS.md) for non-negotiable project rules during implementation.

## Optional crash reporting (Sentry)

The app can send crashes and performance traces to **Sentry** when a DSN is provided at compile time. If the DSN is **empty**, the app runs normally with **no** Sentry initialization (default for local dev and CI).

Keep **`sentry_flutter` on a recent 9.x** (see `pubspec.yaml`): older **8.x** Android builds used Kotlin **language version 1.6**, which **fails** with current **Kotlin 2.x** Android toolchains (`Language version 1.6 is no longer supported` during `:sentry_flutter:compileDebugKotlin`).

| Dart define | Purpose |
|-------------|---------|
| `PRIDE_SENTRY_DSN` | Sentry project DSN (HTTPS URL). Omit or leave empty to disable. |
| `PRIDE_SENTRY_ENV` | Release environment label (default `development`). |
| `PRIDE_SENTRY_TRACES_SAMPLE_RATE` | Performance sample rate `0.0`–`1.0` (default `0.2`). |

Example (staging / QA):

```bash
flutter run --dart-define=PRIDE_SENTRY_DSN=https://examplePublicKey@o0.ingest.sentry.io/0 --dart-define=PRIDE_SENTRY_ENV=staging
```

Do **not** commit production DSNs or auth tokens in source. Document team-specific run commands in `TESTING.md`.
