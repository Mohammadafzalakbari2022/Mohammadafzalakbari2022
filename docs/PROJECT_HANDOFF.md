# Pride v3 — project handoff & closure (May 2026)

This document is the **single entry point** for anyone resuming work on Afghan Pride after the initial delivery. The canonical product contracts remain `plan-00-index.md` through `plan-25-implementation-backlog.md` and [`AGENTS.md`](../AGENTS.md).

## Repository

| Item | Value |
|------|--------|
| GitHub | https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022 |
| Default branch | `main` |
| Production API | `https://mohammadafzalakbari2022.onrender.com` (see [`config/dart_defines_prod.json`](../config/dart_defines_prod.json)) |
| Web app | https://pride-v3-web.pages.dev |
| App version (pubspec) | `3.5.5+35305` |

## What ships in this closure

### Core product (delivered)

- Offline-first shop app: Orders, Customers, Catalog, Reports, Settings (Flutter + Isar).
- Custom NestJS API + Postgres (Prisma); JWT auth; sync push/pull; licensing & activation codes.
- Multi-user per shop (trial 2 / paid 5); developer portal; password reset queue.
- Localization: English, Dari (fa), Pashto (ps); RTL.

### Final fixes included in `main` (commit `1fc25e7`)

1. **Offline login** — After **one successful online** sign-in or shop creation on a device, sign-in works without internet using a local SHA-256 verifier ([`lib/auth/offline_credential_storage.dart`](../lib/auth/offline_credential_storage.dart)). Sign-up / create shop remains **online only**.
2. **Bundled defaults** — 15 style figure PNGs (`assets/style_figures/shape_1.png` … `shape_15.png`) and 4 catalog designs (`assets/catalog_seed/design_1.png` … `design_4.png`) seed into Isar for the real `shop_id` after login ([`lib/data/local/ensure_bundled_shop_defaults.dart`](../lib/data/local/ensure_bundled_shop_defaults.dart)).

### Database / migrations — important

| Layer | Schema changed? | Action on deploy |
|-------|-----------------|------------------|
| **Phone (Isar)** | No new collections | Install new APK; user logs in **once online** to seed credentials + defaults. Existing local data is kept. |
| **Server (Postgres)** | No new Prisma migration in closure | API deploy only; run existing migrations if setting up a **new** DB (`npx prisma migrate deploy` in `api/`). |

Offline credentials live in **SharedPreferences** (`pride_offline_credentials_v1`), not Isar. They survive sign-out.

## Build & install (developers)

Full command index: [`COMMANDS.md`](../COMMANDS.md).

| Target | Command | Output |
|--------|---------|--------|
| Android APK (phone) | `.\scripts\build-apk-release.ps1` | `build\app\outputs\flutter-apk\Pride.apk` |
| Play Store bundle | `.\scripts\build-store-release.ps1` | `build\app\outputs\bundle\release\app-release.aab` + `build\web\` |
| Web only | `.\scripts\build-flutter-with-defines.ps1 build web --release` | `build\web\` |
| iOS (Mac only) | `./scripts/build-ios-release.sh prod` | `build/ios/ipa/*.ipa` |

**Windows cannot build iOS.** CI: GitHub Actions → **Build iOS** (compile check, no codesign on push to `lib/**`).

### Publish APK for customers (GitHub Releases)

```powershell
git tag v3.5.6
git push origin v3.5.6
```

Or: **Actions → Release Android APK → Run workflow** (tag e.g. `v3.5.6`). Customers use:

`https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/latest/download/Pride-android.apk`

See [`README.md`](../README.md) and [`docs/INSTALL_FA.md`](INSTALL_FA.md).

## CI / CD (GitHub Actions)

| Workflow | Trigger | Purpose |
|----------|---------|---------|
| `flutter_ci.yml` | Push/PR to `main` | `flutter analyze`, `flutter test`, API e2e |
| `deploy_web.yml` | Push to `main` (`lib/**`, etc.) | Build web → Cloudflare Pages |
| `deploy_api.yml` | (see workflow) | API deploy |
| `release-android.yml` | Tag `v*` or manual | APK → GitHub Release |
| `build-ios.yml` | Push `lib/**` or manual | iOS compile on macOS |
| `deploy-privacy-pages.yml` | (see workflow) | Play Store privacy URL on GitHub Pages |

## Key source files (future upgrades)

| Topic | Location |
|-------|----------|
| Offline login | `lib/auth/login_screen.dart`, `lib/auth/offline_credential_storage.dart` |
| Session restore | `lib/auth/auth_session_storage.dart`, `lib/main.dart` |
| Style figure seed | `lib/data/local/style/style_catalog_seed.dart` |
| Catalog bundle seed | `lib/data/local/catalog_bundle_seed_isar.dart`, `lib/data/local/catalog_bundle_seed.dart` |
| Login-time seed hook | `lib/data/local/seed_bundled_defaults_io.dart` |
| API auth | `api/src/auth/`, `api/src/shop/shop-registry.service.ts` (SHA-256 passwords) |
| Sync | `lib/core/sync/`, `api/src/sync/` |
| Plans | `plan-*.md` |

## Deferred work (not blocking closure)

Tracked in [`IMPLEMENTATION_TODO.md`](../IMPLEMENTATION_TODO.md) and `plan-25-implementation-backlog.md`:

- Sync **conflict inspector UI** for orders.
- Full **public catalog feed + WebRTC P2P** (plan-14).
- **FCM/APNs** push delivery pipeline (token registration exists).
- **Backup** including catalog image binaries.
- **Dashboard global search**.
- **Play / App Store** full launch checklist (`plan-21`) — signing, listings, TestFlight.
- Optional: Supabase RLS path (not used; Nest + Prisma is canonical).

## QA smoke checklist (before calling a release “done”)

1. Online: create shop or log in → Settings → Style Figures (15 images) → Catalog → My designs (4 images).
2. Sign out → airplane mode → same username/password → enters app (no “no internet” if device was seeded online once).
3. Sync: create customer/order online → second device or pull sees data (when API up).
4. Web: open https://pride-v3-web.pages.dev — login + core tabs.
5. iOS: build on Mac before App Store submission.

## Play Store & marketing assets

- Privacy setup: [`play store ready files/PLAY_STORE_PRIVACY_SETUP.md`](../play%20store%20ready%20files/PLAY_STORE_PRIVACY_SETUP.md)
- **Store listings (EN + Dari + Pashto):** [`play store ready files/PLAY_STORE_LISTINGS_EN_FA_PS.md`](../play%20store%20ready%20files/PLAY_STORE_LISTINGS_EN_FA_PS.md)
- Listing copy / tags (English notes): [`play store ready files/description and tags for pride.txt`](../play%20store%20ready%20files/description%20and%20tags%20for%20pride.txt)
- Privacy page: [`web/privacy-policy.html`](../web/privacy-policy.html)

## Environment & secrets

- **Never** commit `api/.env`, `android/key.properties`, or signing keys.
- Flutter: `config/dart_defines_base.json` + `config/dart_defines_prod.json` (or staging).
- API on Render: see [`api/DEPLOY.md`](../api/DEPLOY.md).

## Resuming development

1. Read `AGENTS.md` and the relevant `plan-NN-*.md` for the feature.
2. `flutter pub get` → `flutter gen-l10n` → change code → `flutter analyze` → `flutter test`.
3. If Isar entities change: `dart run build_runner build --delete-conflicting-outputs`.
4. If API schema changes: add Prisma migration under `api/prisma/migrations/` and deploy with `prisma migrate deploy`.

---

*Last updated: May 2026 — project closure documentation.*
