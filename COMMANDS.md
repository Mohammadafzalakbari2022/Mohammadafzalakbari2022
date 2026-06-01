# Afghan Pride (Pride-v3) — command reference

Complete index for **Git/GitHub**, **Flutter** (Web / Android / iOS), **Nest API**, **database**, **builds**, **deploy**, and **QA**.  
See also: [`TESTING.md`](TESTING.md), [`AGENTS.md`](AGENTS.md), [`ios/DEPLOY.md`](ios/DEPLOY.md), [`api/DEPLOY.md`](api/DEPLOY.md), [`web/DEPLOY.md`](web/DEPLOY.md).

**Project root (Windows example):**

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
```

**Project root (macOS example):**

```bash
cd ~/Desktop/Pride-v3
```

**Production API URL** (baked into release builds): `https://mohammadafzalakbari2022.onrender.com` — stacked [`config/dart_defines_base.json`](config/dart_defines_base.json) + [`config/dart_defines_prod.json`](config/dart_defines_prod.json) (no `.env`).

---

## Table of contents

1. [One-time setup](#1-one-time-setup)
2. [After every code change (Flutter)](#2-after-every-code-change-flutter)
3. [Run the app — development](#3-run-the-app--development)
4. [Build — QA and release](#4-build--qa-and-release)
5. [Android signing and install](#5-android-signing-and-install)
6. [iOS (macOS + Xcode only)](#6-ios-macos--xcode-only)
7. [Web deploy](#7-web-deploy)
8. [Nest API](#8-nest-api)
9. [Database migrations](#9-database-migrations)
10. [Docker (local Postgres)](#10-docker-local-postgres)
11. [Git and GitHub](#11-git-and-github)
12. [CI (what runs on push)](#12-ci-what-runs-on-push)
13. [Deploy summary (all platforms)](#13-deploy-summary-all-platforms)
14. [Environment variables](#14-environment-variables)
15. [Developer account (`is_developer`)](#15-developer-account-is_developer)
16. [Copy-paste daily blocks](#16-copy-paste-daily-blocks)
17. [Customer download links](#17-customer-download-links-distribute-to-shops)

---

## 1. One-time setup

### Flutter + Web + Android (Windows or macOS)

| Command | What it does |
|---------|----------------|
| `flutter config --enable-web` | Enables building/running the web target. |
| `flutter doctor -v` | Reports missing SDKs, licenses, Xcode (Mac), Chrome, etc. |
| `flutter doctor --android-licenses` | Accepts Android SDK licenses (Windows/Linux). |
| `flutter pub get` | Downloads Dart/Flutter package dependencies from `pubspec.yaml`. |

### API (any OS)

| Command | What it does |
|---------|----------------|
| `npm run api:install` | Runs `npm install` inside `api/`. |
| `copy api\.env.example api\.env` (Win) / `cp api/.env.example api/.env` (Mac) | Creates local API env file (gitignored). Edit `DATABASE_URL`, `JWT_SECRET`, etc. |

### iOS (macOS only)

| Command | What it does |
|---------|----------------|
| Install **Xcode** from the App Store | Required compiler and iOS SDK. |
| `sudo xcode-select -s /Applications/Xcode.app/Contents/Developer` | Points CLI tools at Xcode. |
| `sudo xcodebuild -license accept` | Accepts Xcode license. |
| `sudo gem install cocoapods` (if needed) | CocoaPods manages iOS native deps. |
| `cd ios && pod install` | Installs pods (or run `flutter build ios` once, which triggers this). |

### Local Postgres (optional, for API dev)

```powershell
docker compose up -d
```

Point `api/.env` at: `postgresql://pride:pride@127.0.0.1:5433/pride_api`

---

## 2. After every code change (Flutter)

### Full check (entities + l10n + analyze + tests)

Use after editing **Isar `@collection` entities**, **ARB strings**, or before **commit/push**.

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
flutter pub get
flutter gen-l10n
dart run build_runner build --delete-conflicting-outputs
flutter analyze
flutter test
```

| Command | What it does |
|---------|----------------|
| `flutter pub get` | Resolves dependencies. |
| `flutter gen-l10n` | Regenerates `lib/l10n/app_localizations*.dart` from ARB files. |
| `dart run build_runner build --delete-conflicting-outputs` | Regenerates Isar `.g.dart` files when entities change. **Skip** if you did not touch entities. |
| `flutter analyze` | Static analysis; must be clean before merge. |
| `flutter test` | Runs unit/widget tests under `test/`. |

### Lighter check (no Isar codegen)

```powershell
flutter pub get; flutter gen-l10n; flutter analyze; flutter test
```

### Maintenance

| Command | What it does |
|---------|----------------|
| `dart run build_runner watch --delete-conflicting-outputs` | Watches entities and regenerates codegen during long sessions. |
| `flutter pub outdated` | Lists packages with newer versions. |
| `flutter pub upgrade` | Upgrades dependencies within `pubspec.yaml` constraints. |
| `flutter clean` | Deletes `build/` and cached artifacts (use if builds act stale). |
| `flutter devices` | Lists connected phones, emulators, Chrome, etc. |

---

## 3. Run the app — development

Uses **dev** data unless you pass production `dart-define`s. Dev owner password: **`pride-dev-owner`** — see [`TESTING.md`](TESTING.md).

### Web (Chrome) — in-memory data, fast UI testing

```powershell
flutter run -d chrome
flutter run -d chrome --web-port=8080
```

| Flag | What it does |
|------|----------------|
| `--dart-define=API_BASE_URL=http://localhost:3000` | Talks to local Nest API. |
| Stacked `--dart-define-from-file=config/dart_defines_base.json` + `config/dart_defines_prod.json` | Production API URL (recommended). |

### Android — full Isar + device features

```powershell
flutter run -d android
flutter run -d <deviceId>
```

`deviceId` from `flutter devices` (e.g. `f163be9d`).

### iOS — full Isar (macOS only)

```bash
flutter run -d ios
flutter run -d "iPhone 16"
flutter run -d ios --dart-define-from-file=config/dart_defines_prod.json
```

Open **`ios/Runner.xcworkspace`** in Xcode first if signing fails; set **Team** under Signing & Capabilities.

### Optional `dart-define` flags (all platforms)

```powershell
flutter run --dart-define=PRIDE_SENTRY_DSN=https://...@.../... `
  --dart-define=PRIDE_SENTRY_ENV=staging `
  --dart-define=PRIDE_SENTRY_TRACES_SAMPLE_RATE=0.2

flutter run --dart-define=PRIDE_OWNER_PASSWORD_SHA256=<64-char-lowercase-hex>
flutter run --dart-define=ENV=dev --dart-define=API_BASE_URL=https://...
```

---

## 4. Build — QA and release

Production defines: stack [`config/dart_defines_base.json`](config/dart_defines_base.json) then [`config/dart_defines_prod.json`](config/dart_defines_prod.json). Helper: `.\scripts\build-flutter-with-defines.ps1 build web --release`.

### Web

| Command | What it does | Output |
|---------|----------------|--------|
| `flutter build web` | Release web build (default API from compile-time defines if passed). | `build/web/` |
| `.\scripts\build-flutter-with-defines.ps1 build web --release` | Production web (stacked defines). | `build/web/` |
| `flutter build web --base-href=/your-path/` | Use when not hosted at domain root. | `build/web/` |

### Android

| Command | What it does | Output |
|---------|----------------|--------|
| `flutter build apk --release --dart-define-from-file=config/dart_defines_prod.json` | Side-load / QA APK. | `build/app/outputs/flutter-apk/app-release.apk` |
| `flutter build appbundle --release --dart-define-from-file=config/dart_defines_prod.json` | **Google Play** upload bundle. | `build/app/outputs/bundle/release/app-release.aab` |
| `.\scripts\build-apk-release.ps1` | Windows script: pub get + gen-l10n + release APK. | Same APK path |
| `.\scripts\build-store-release.ps1` | Windows: AAB + web (prints iOS reminder). | AAB + `build/web/` |

### iOS (macOS only)

| Command | What it does | Output |
|---------|----------------|--------|
| `flutter build ios --release --dart-define-from-file=config/dart_defines_prod.json` | Compiled iOS app (needs Xcode signing to run on device). | `build/ios/` |
| `flutter build ipa --release --dart-define-from-file=config/dart_defines_prod.json` | Signed IPA for TestFlight / App Store. | `build/ios/ipa/*.ipa` |
| `./scripts/build-ios-release.sh` | Same as IPA build with checks. | `build/ios/ipa/` |

Detail: [`ios/DEPLOY.md`](ios/DEPLOY.md).

---

## 5. Android signing and install

### Play Store signing (once)

```powershell
keytool -genkey -v -keystore upload-keystore.jks -keyalg RSA -keysize 2048 -validity 10000 -alias upload
copy android\key.properties.example android\key.properties
```

Edit `android/key.properties` (gitignored). Without it, release builds use the **debug keystore** (OK for personal install, not for Play upload).

### Install release APK on a connected phone

```powershell
flutter devices
flutter install -d <deviceId> --use-application-binary=build\app\outputs\flutter-apk\app-release.apk
```

Or:

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" install -r build\app\outputs\flutter-apk\app-release.apk
```

| Command | What it does |
|---------|----------------|
| `adb devices` | Lists USB/debug devices. |
| `flutter doctor -v` | Verifies Android SDK paths. |

---

## 6. iOS (macOS + Xcode only)

**Same Dart code as Android** — Isar, sync, shop finance, printer, camera. Not optional in this repo.

### Quick Mac session (friend’s laptop)

```bash
cd ~/Desktop/Pride-v3
git pull
flutter doctor -v
flutter pub get && flutter gen-l10n
cd ios && pod install && cd ..
open ios/Runner.xcworkspace   # set Signing Team, then:
flutter run -d ios --dart-define-from-file=config/dart_defines_prod.json
```

### TestFlight / App Store

```bash
chmod +x scripts/build-ios-release.sh
./scripts/build-ios-release.sh
```

Upload `build/ios/ipa/*.ipa` with **Transporter** or Xcode **Organizer**.

| Item | Value |
|------|--------|
| Bundle ID | `com.pridev3.prideV3` |
| Min iOS | 13.0 |
| Permissions | Camera, photos, contacts, local network — in `ios/Runner/Info.plist` |

Full checklist: [`ios/DEPLOY.md`](ios/DEPLOY.md).

---

## 7. Web deploy

### Build

```powershell
flutter pub get
flutter gen-l10n
.\scripts\build-flutter-with-defines.ps1 build web --release
```

### CI (recommended: GitHub Actions → Cloudflare Pages)

Build uses the same stacked defines as local; **only** Cloudflare API credentials go in GitHub Secrets (not Flutter config).

1. Set secrets: `CLOUDFLARE_API_TOKEN`, `CLOUDFLARE_ACCOUNT_ID`.
2. Push to `main` or run workflow **Deploy Web** manually.

See [`web/DEPLOY.md`](web/DEPLOY.md).

### Smoke after deploy

- App loads over HTTPS.
- **Settings → Sync & diagnostics → Test connection** → `GET /health` OK.

---

## 8. Nest API

### From repo root

| Command | What it does |
|---------|----------------|
| `npm run api:install` | `npm install` in `api/`. |
| `npm run api:dev` | Nest watch mode (`start:dev`). |
| `npm run api:build` | `prisma generate` + `nest build`. |
| `npm run api:test` | Unit tests in `api/`. |

### From `api/` folder

```powershell
cd api
npm install
npm run start:dev          # dev with watch
npm run start:prod         # production: node dist/main
npm run build
npm test
npm run test:e2e
npm run lint
npx prisma generate
```

### Health check

```powershell
curl.exe -sS http://localhost:3000/health
curl.exe -sS https://mohammadafzalakbari2022.onrender.com/health
```

### Windows: `npm install` fails (`ENOTEMPTY`)

```powershell
Remove-Item -Recurse -Force api\node_modules
cd api; npm install
```

Do **not** run `npm audit fix --force` in `api/` — see [`api/DEPLOY.md`](api/DEPLOY.md).

---

## 9. Database migrations

| Command | What it does |
|---------|----------------|
| `npm run db:migrate` | `prisma migrate deploy` — **production/staging** (applies pending migrations). |
| `npm run db:migrate:dev` | `prisma migrate dev` — **local** schema changes + new migration files. |
| `npm run db:generate` | Regenerates Prisma client only. |

### Production (Supabase / hosted Postgres)

```powershell
$env:DATABASE_URL = "postgresql://..."   # add ?sslmode=require if needed
.\scripts\migrate-production-db.ps1
```

Render runs migrations automatically via `preDeployCommand` in [`render.yaml`](render.yaml).

---

## 10. Docker (local Postgres)

```powershell
docker compose up -d
docker compose down
docker compose down -v
docker compose logs -f postgres
```

---

## 11. Git and GitHub

Remote example: `git@github.com:Mohammadafzalakbari2022/Mohammadafzalakbari2022.git`

### First-time clone

```powershell
git clone git@github.com:Mohammadafzalakbari2022/Mohammadafzalakbari2022.git
cd Mohammadafzalakbari2022
flutter pub get
```

### Daily workflow

| Command | What it does |
|---------|----------------|
| `git status` | Shows modified and untracked files. |
| `git diff` | Shows unstaged line changes. |
| `git diff --staged` | Shows staged changes. |
| `git add -A` | Stages all changes (respect `.gitignore`). |
| `git add path\to\file` | Stages specific files. |
| `git restore path\to\file` | Discards unstaged changes in a file. |
| `git commit -m "message"` | Creates a commit from staged files. |
| `git push` | Uploads commits to `origin` (GitHub). |
| `git pull` | Downloads and merges remote changes. |

### Push to GitHub (typical)

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
git status
git add -A
git commit -m "Describe what changed and why."
git push origin main
```

If the branch has no upstream yet:

```powershell
git push -u origin main
```

### Branches and pull requests

| Command | What it does |
|---------|----------------|
| `git checkout -b feature/my-change` | Creates and switches to a new branch. |
| `git push -u origin feature/my-change` | Publishes branch to GitHub. |
| `gh pr create --title "..." --body "..."` | Opens a PR (requires [GitHub CLI](https://cli.github.com/)). |
| `gh pr list` | Lists open PRs. |
| `gh pr merge <number>` | Merges a PR on GitHub. |

### Sync with remote before push

```powershell
git fetch origin
git pull origin main
# resolve conflicts if any, then:
git push origin main
```

### Never commit

- `android/key.properties`, `*.jks`, `api/.env`, `.dart_tool/`, `build/`
- Secrets or production passwords

---

## 12. CI (what runs on push)

Workflow: [`.github/workflows/flutter_ci.yml`](.github/workflows/flutter_ci.yml)

**Flutter job (`analyze-and-test`):**

```powershell
flutter pub get
flutter gen-l10n
flutter analyze
flutter test
```

**API job (`nestjs-build-test-e2e`):**

```powershell
cd api
npm ci
npx prisma migrate deploy
npm run build
npm test
npm run test:e2e
```

**Web deploy:** [`.github/workflows/deploy_web.yml`](.github/workflows/deploy_web.yml) (on `main`, when configured).

**iOS:** not built in CI yet — build on a Mac before App Store release.

---

## 13. Deploy summary (all platforms)

| Layer | Environment | Command / action |
|--------|-------------|------------------|
| **Postgres** | Supabase | Create project; set `DATABASE_URL` on API |
| **API** | Render | Push `main` → Blueprint [`render.yaml`](render.yaml) — [`api/DEPLOY.md`](api/DEPLOY.md) |
| **Web** | Cloudflare Pages | `flutter build web` + CI or manual upload — [`web/DEPLOY.md`](web/DEPLOY.md) |
| **Android** | Google Play | `flutter build appbundle` + Play Console |
| **Android** | Side-load / QA | `.\scripts\build-apk-release.ps1` → `adb install` |
| **iOS** | TestFlight / App Store | `./scripts/build-ios-release.sh` on Mac — [`ios/DEPLOY.md`](ios/DEPLOY.md) |

### Production Flutter build (all mobile + web artifacts)

**Windows (Android + web):**

```powershell
.\scripts\build-store-release.ps1
.\scripts\build-apk-release.ps1
```

**macOS (add iOS):**

```bash
./scripts/build-ios-release.sh
```

---

## 14. Environment variables

### Flutter (`--dart-define=...` or `config/dart_defines_prod.json`)

| Define | Purpose |
|--------|---------|
| `API_BASE_URL` | Nest API base URL (no trailing slash) |
| `PRIDE_SENTRY_DSN` | Sentry DSN (empty = disabled) |
| `PRIDE_SENTRY_ENV` | Sentry environment label |
| `PRIDE_SENTRY_TRACES_SAMPLE_RATE` | `0.0`–`1.0` |
| `PRIDE_DEVELOPER_USERS` | Comma-separated `shop_id\|username` for in-app Developer Portal (client gate; server must match) |
| `PRIDE_OWNER_PASSWORD_SHA256` | SHA-256 hex of owner password for destructive actions |
| `ENV` | Optional: `dev` / `staging` / `prod` |

### API (`api/.env` or Render dashboard)

See [`api/.env.example`](api/.env.example): `DATABASE_URL`, `JWT_SECRET`, `PRIDE_AUTH_SEED`, `PRIDE_DEVELOPER_IDS`, `PRIDE_DEVELOPER_USERS`, `PRIDE_LEGACY_REDEEM_CODES`, etc.

---

## 15. Developer account (`is_developer`)

Not a database column — controlled by API **environment variables** on Render:

- `PRIDE_DEVELOPER_IDS` — comma-separated `shop_users.id` (JWT `sub`)
- `PRIDE_DEVELOPER_USERS` — comma-separated `shop_id|username`

### Verify after login

```powershell
# 1) Login
$body = '{"shop_id":"YOUR_SHOP","username":"YOUR_USER","password":"YOUR_PASSWORD"}'
$login = Invoke-RestMethod -Method POST -Uri "https://mohammadafzalakbari2022.onrender.com/auth/login" -ContentType "application/json" -Body $body

# 2) Check developer flag
Invoke-RestMethod -Method GET -Uri "https://mohammadafzalakbari2022.onrender.com/admin/me" -Headers @{ Authorization = "Bearer $($login.access_token)" }
```

Expect: `{ "is_developer": true }` for Developer Portal in **Settings**.

### Find user id in Postgres (Supabase SQL)

```sql
SELECT id, shop_id, username FROM shop_users
WHERE shop_id = 'YOUR_SHOP' AND username = 'YOUR_USER';
```

Use `id` in `PRIDE_DEVELOPER_IDS` on Render, redeploy, test again.

---

## 16. Copy-paste daily blocks

### Full stack locally

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
docker compose up -d
npm run db:migrate
npm run api:dev
# New terminal:
flutter run -d chrome --dart-define=API_BASE_URL=http://localhost:3000
```

### Verify before commit / push

**One script (Flutter analyze/test + API build/tests):**

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
.\scripts\verify-before-push.ps1
```

**Full release check (add platform builds after the script above):**

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
.\scripts\verify-before-push.ps1
.\scripts\build-flutter-with-defines.ps1 build web --release
.\scripts\verify-web-build.ps1
.\scripts\build-apk-release.ps1
git add -A
git commit -m "Describe what changed and why."
git push origin main
```

| Command | What it does |
|---------|----------------|
| `.\scripts\verify-before-push.ps1` | `flutter pub get`, `gen-l10n`, `analyze`, `test`, then `api/` `npm ci`, `build`, `test`, `test:e2e`. |
| `.\scripts\build-flutter-with-defines.ps1 build web --release` | Production web artifact (`build/web/`). |
| `.\scripts\verify-web-build.ps1` | Confirms `main.dart.js` exists before Cloudflare upload. |
| `.\scripts\build-apk-release.ps1` | Release APK for Android QA / GitHub release. |
| `.\scripts\build-store-release.ps1` | AAB + web for store submission (Windows). |
| `./scripts/build-ios-release.sh` | IPA on macOS only. |
| `npm run api:dev` | Local Nest API (separate terminal). |
| `flutter run -d chrome` | Web UI dev. |
| `flutter run -d android` | Android + Isar dev. |
| `flutter run -d ios` | iOS + Isar dev (macOS). |

**macOS (iOS release, after the Flutter steps above):**

```bash
./scripts/build-ios-release.sh
```

### Error log & cache (support)

- **Background errors:** stored locally (last 40) in `SharedPreferences`; included in **Settings → Sync & diagnostics → Export diagnostics**. When `PRIDE_SENTRY_DSN` is set, the same errors are also sent to Sentry.
- **Cache:** temp invoice PDFs are trimmed on startup (3+ days old) and cleared on sign-out; image memory cache is cleared on sign-out.

### Production Android install (Windows)

```powershell
.\scripts\build-apk-release.ps1
flutter install -d android --use-application-binary=build\app\outputs\flutter-apk\app-release.apk
```

### Production iOS (Mac — short visit)

```bash
git pull
flutter pub get && flutter gen-l10n
cd ios && pod install && cd ..
open ios/Runner.xcworkspace
./scripts/build-ios-release.sh
```

---

## 17. Customer download links (distribute to shops)

After you publish a release, customers can install without the Play Store.

| What | URL |
|------|-----|
| **Android APK (latest)** | `https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases/latest/download/Pride-android.apk` |
| **Dari install guide** | `docs/INSTALL_FA.md` in repo (or GitHub Pages `docs/index.html`) |
| **Web app** | `https://pride-v3-web.pages.dev` |
| **Releases list** | `https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/releases` |

### Publish a new APK to GitHub

| Command | What it does |
|---------|----------------|
| `git tag v1.0.1` | Creates version tag (match `pubspec.yaml` if you bump version). |
| `git push origin v1.0.1` | Triggers [`.github/workflows/release-android.yml`](.github/workflows/release-android.yml) — builds APK and attaches `Pride-android.apk`. |

Or: **GitHub → Actions → Release Android APK → Run workflow** → version `v1.0.0`.

### Enable public download page (optional)

**GitHub → Settings → Pages → Build from branch `main` → folder `/docs`**  
Then share: `https://<username>.github.io/Mohammadafzalakbari2022/` (see your Pages URL in Settings).

### iOS for customers

APK/IPA from GitHub **does not install on iPhone** for random users. Use **web**, **TestFlight**, or **App Store** — see [`docs/INSTALL_FA.md`](docs/INSTALL_FA.md).

---

## Notes

- **Automatic sync (mobile + web with API session):** On app open, on resume, when connectivity returns, and every **15 minutes** while foreground — pull then push (outbox, up to 5×100 mutations per run). Skipped when offline, mock login, license read-only, or API not configured. Manual sync still available from the app bar / drawer.
- **Web:** Isar is not used; sample data is in-memory. **Android/iOS** use Isar on device.
- **iOS = Android** for app features; only platform-specific gaps: WhatsApp deep link (Android), custom UI sounds (Android channel; iOS uses system sounds).
- **Supabase:** hosted Postgres via API `DATABASE_URL` — no Supabase CLI in this repo.
- **Manual QA:** [`TESTING.md`](TESTING.md).
- **Store launch:** [`plan-21-launch-deployment.md`](plan-21-launch-deployment.md).
