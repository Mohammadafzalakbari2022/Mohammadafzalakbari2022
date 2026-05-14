# Afghan Pride (Pride-v3) — testing guide

Use this when **you** verify what Cursor or another developer built. The AI is instructed to follow the same commands before finishing a task (see **`AGENTS.md`** and **`.cursor/rules/afghan-pride.mdc`**).

**Web-first testing:** You can validate the whole UI on **Chrome** (`flutter run -d chrome`). Sample orders use **in-memory** data on Web (Isar is not compiled for Web: its generated schema IDs are 64-bit integers that **JavaScript cannot represent**). **Android and iOS** are unaffected and use **Isar** on the device. After **Android SDK command-line tools** are installed, run **`flutter run -d android`** — the same UI reads from **Isar** there.

## One-time setup (Windows + Android + Web)

1. **Install Flutter** (stable) and add it to `PATH`.
2. **Enable Web** (once per machine):

   ```powershell
   flutter config --enable-web
   ```

3. **Android SDK** — If you use Android Studio, follow **[Android SDK on Windows (Android Studio)](#android-sdk-on-windows-android-studio)** below (check paths, install missing pieces, licenses).

4. **Check health**:

   ```powershell
   cd C:\Users\Moh.Akbari\Desktop\Pride-v3
   flutter doctor -v
   ```

   Resolve any **Android toolchain** or **Chrome** issues reported there.

5. **iOS** (full device/simulator builds): requires **macOS + Xcode**. On Windows you can still keep the codebase **iOS-compile-clean** via CI or a Mac when available.

---

## Android SDK on Windows (Android Studio)

### Beginner: “sdkmanager not found” or licenses fail — read this first

**Good news:** On your machine Flutter already reports an **Android SDK** at:

`C:\Users\Moh.Akbari\AppData\Local\Android\sdk`

That folder already contains things like **platform-tools** (includes `adb`), **build-tools**, **platforms**, and **emulator**. So you are **not** missing the whole SDK.

**What is actually missing:** the **Android SDK Command-line Tools** package. Flutter runs `sdkmanager` (inside that package) to accept licenses. Until **Command-line Tools** is installed, you will see errors like:

- `Android sdkmanager not found`
- `cmdline-tools component is missing` (in `flutter doctor -v`)

**Easiest fix (recommended): use Android Studio’s SDK Manager**

1. Open **Android Studio**.
2. Open **SDK Manager**:
   - From the welcome screen: **More Actions** → **SDK Manager**, **or**
   - From a project: **File** → **Settings** (or **Android Studio** → **Settings** on some versions) → **Languages & Frameworks** → **Android SDK**.
3. Open the **SDK Tools** tab (not “SDK Platforms” at first).
4. Find **Android SDK Command-line Tools (latest)**.
5. **Check the box** so it will be installed. Also ensure these are checked:
   - **Android SDK Platform-Tools**
   - **Android SDK Build-Tools** (a recent version)
6. Click **Apply** → **OK** and wait until the download finishes.
7. **Fully close** Android Studio and **close and reopen** your terminal (or Cursor), then run:

   ```powershell
   flutter doctor -v
   flutter doctor --android-licenses
   ```

Type `y` and press Enter for each license prompt until it finishes.

**Check that Command-line Tools really arrived** (optional):

```powershell
Test-Path "C:\Users\Moh.Akbari\AppData\Local\Android\sdk\cmdline-tools\latest\bin\sdkmanager.bat"
```

If that prints `False`, look for a **version number** folder instead of `latest`:

```powershell
Get-ChildItem "C:\Users\Moh.Akbari\AppData\Local\Android\sdk\cmdline-tools" -ErrorAction SilentlyContinue
```

If you see something like `19.0`, then `sdkmanager.bat` is at:

`...\cmdline-tools\19.0\bin\sdkmanager.bat`

---

Android Studio almost always installs the SDK here:

`%LOCALAPPDATA%\Android\Sdk` → e.g. `C:\Users\YourName\AppData\Local\Android\Sdk`

### 1) See what Flutter thinks about Android

```powershell
flutter doctor -v
```

In the output, find the line **Android SDK at** … — that is your SDK root. If you see **cmdline-tools component is missing** or **Android license status unknown**, continue below.

### 2) Check environment variables (optional but helpful)

```powershell
echo $env:ANDROID_HOME
echo $env:ANDROID_SDK_ROOT
```

Flutter uses **`ANDROID_SDK_ROOT`** or **`ANDROID_HOME`**. If both are empty, Flutter still finds the default Studio path on many machines; setting one avoids confusion:

```powershell
# Example only — use YOUR user name / path from `flutter doctor -v`
[System.Environment]::SetEnvironmentVariable("ANDROID_HOME", "$env:LOCALAPPDATA\Android\Sdk", "User")
```

Close and reopen the terminal (or Cursor) after setting **User** environment variables.

### 3) Verify the SDK folder and key tools exist

```powershell
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
Write-Host "SDK path: $sdk"
Test-Path $sdk
Test-Path "$sdk\platform-tools\adb.exe"
Test-Path "$sdk\cmdline-tools\latest\bin\sdkmanager.bat"
```

- If **`adb.exe`** is missing, install **Android SDK Platform-Tools** (via Studio SDK Manager or `sdkmanager` below).
- If **`sdkmanager.bat`** is missing, install **Android SDK Command-line Tools (latest)** — this is what Flutter’s doctor usually means by “cmdline-tools”.

### 4) Install / fix SDK pieces using Android Studio (GUI)

1. Open **Android Studio** → **Settings** (or **More Actions** on welcome screen → **SDK Manager**).
2. **Languages & Frameworks** → **Android SDK**.
3. **SDK Tools** tab — install / update:
   - **Android SDK Command-line Tools (latest)** ← fixes “cmdline-tools missing”
   - **Android SDK Platform-Tools**
   - **Android SDK Build-Tools** (pick a recent version)
4. **SDK Platforms** tab — enable at least one **Android API** (e.g. latest stable).
5. Apply → OK → wait for download to finish.

Then run again:

```powershell
flutter doctor -v
flutter doctor --android-licenses
```

### 5) Install / fix SDK pieces using the command line (`sdkmanager`)

Use this **after** `cmdline-tools\latest\bin\sdkmanager.bat` exists (step 4 GUI once, or Studio installed it). If you only see a **versioned** folder (e.g. `cmdline-tools\19.0\`), use that path instead of `latest`.

```powershell
$sdk = "$env:LOCALAPPDATA\Android\Sdk"
$sdkmanager = "$sdk\cmdline-tools\latest\bin\sdkmanager.bat"
& $sdkmanager --version
& $sdkmanager --list_installed
```

Typical install / repair (API level **34** is an example — choose a version you see in Studio’s SDK Platforms list):

```powershell
& $sdkmanager "cmdline-tools;latest" "platform-tools" "platforms;android-34" "build-tools;34.0.0"
```

Then accept licenses:

```powershell
flutter doctor --android-licenses
flutter doctor -v
```

### 6) Confirm `adb` sees a device or emulator

```powershell
& "$env:LOCALAPPDATA\Android\Sdk\platform-tools\adb.exe" devices
```

Start an AVD from Android Studio (**Device Manager**) if the list is empty, then run `adb devices` again.

---

## Commands you should run after every meaningful change

From the project root (`Pride-v3`):

| Step | Command | Purpose |
|------|---------|--------|
| **Nest API (optional)** | `cd api` then `npm install` / `npm run build` / `npm test` / `npm run test:e2e` | Verify the NestJS service in [`api/`](api/) after backend edits. Endpoint list and env vars: [`api/README.md`](api/README.md). On Windows, if `npm install` fails with `ENOTEMPTY`, delete `api/node_modules` and retry. |

**Developer portal (API):** set `PRIDE_DEVELOPER_IDS` to the **`shop_users.id`** of the account (this is the same value as JWT `sub`). Comma-separated for several users. Then the in-app Developer Portal can call `GET /admin/stats`, `GET /admin/activation-codes`, `POST /admin/activation-codes`, `GET /admin/audit-log`, etc. License redeem accepts codes created via the portal, or any code listed in `PRIDE_LEGACY_REDEEM_CODES` (default includes `pilot-2026` for dev/e2e).

| Dependencies | `flutter pub get` | Sync packages after `pubspec.yaml` changes |
| Localization | `flutter gen-l10n` | Regenerate `lib/l10n/*.dart` after editing `lib/l10n/*.arb` |
| Isar / codegen | `dart run build_runner build --delete-conflicting-outputs` | Regenerate `*.g.dart` after editing `@collection` entities in `lib/data/local/entities/` |
| Static analysis | `flutter analyze` | Catch type errors, bad imports, lints |
| Unit / widget tests | `flutter test` | Run everything under `test/` |

**Recommended single line (PowerShell):**

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3; flutter pub get; flutter gen-l10n; dart run build_runner build --delete-conflicting-outputs; flutter analyze; flutter test

```

run this after major implimentations:

flutter pub get; flutter gen-l10n; flutter analyze; flutter test



**Note:** You only need `build_runner` when Isar entity files (`*.dart` with `@collection`) change. First run can take a minute; later runs are faster.

---

## Run the app manually

### Web (Chrome)

```powershell
cd C:\Users\Moh.Akbari\Desktop\Pride-v3
flutter run -d chrome
```

Useful flags:

- `flutter run -d chrome --web-port=8080` — fixed port for bookmarks.

### Android (USB device or emulator)

List devices:

```powershell
flutter devices
```

Run on a chosen device id:

```powershell
flutter run -d <deviceId>
```

Example when only one Android device is connected:

```powershell
flutter run -d android
```

---

## Build (release-ish checks)

For **Google Play (AAB)**, **App Store / TestFlight**, **web production deploy**, signing, store listings, and privacy forms, use **`plan-21-launch-deployment.md`**. QA checklists first: **`plan-08-qa-release.md`**.

**Web:**

```powershell
flutter build web
```

Output: `build/web/` (host on any static server or open locally for smoke checks).

**Android APK (side-load / QA):**

```powershell
flutter build apk
```

Output: `build/app/outputs/flutter-apk/app-release.apk`.

---

## Hosted Nest API (smoke against Render or any URL)

Full steps: **[`api/DEPLOY.md`](api/DEPLOY.md)** (Blueprint, migrations, first shop / `PRIDE_AUTH_SEED`).

1. Deploy the API and note the base URL, e.g. `https://pride-api.onrender.com` (no trailing slash).
2. Run the app with that base URL baked in:

   ```powershell
   cd C:\Users\Moh.Akbari\Desktop\Pride-v3
   flutter run -d chrome --dart-define=API_BASE_URL=https://pride-api.onrender.com
   ```

3. From a shell, confirm health:

   ```powershell
   curl.exe -sS https://pride-api.onrender.com/health
   ```

4. Sign in from the Flutter **Login** screen using credentials that exist on the server (either **`PRIDE_AUTH_SEED`** on the service, or the owner account from **`POST /shop/create`**).

---

## What to click-test (current app shell)

Use this pass after merges that touch **orders**, **notifications**, **sync UI**, or **licensing**:

1. **Login** — Dev **Continue without account** (debug only) → lands on **Orders**.
2. **Bottom nav** — All five tabs open without errors.
3. **Orders list** — Sample orders (in-memory on Web, **Isar** on Android/iOS after first launch). **Search** (order number or customer) and **status chips** (multi-select). Row → **Order details**.
4. **Order details** — Sections: **Customer**, **Measurements**, **Style**, **Internal notes**, **Payments**, **Audit** (local timestamps, internal ID copy, payment-ledger range). **Change status** → confirm → for **Delivered** or **Cancelled**, enter **owner password** (see below). **Delivered/Cancelled** shows a lock hint; **internal notes** stay editable if the license is valid. **Payments**: add payment / adjustment when license is valid (append-only ledger).
5. **Owner password (local, offline)** — Default development password is **`pride-dev-owner`** (verified via SHA-256 in `lib/security/owner_password_verify.dart`). For release-style builds, set the digest with  
   `--dart-define=PRIDE_OWNER_PASSWORD_SHA256=<64-char lowercase hex>`  
   (hash the shop owner password with SHA-256). Wrong password → snackbar; no status change.
6. **Notifications** — App bar bell → inbox; unread **badge** when not muted. **Settings → Notifications** — list, mark read, **Mark all read**. **Menu / dashboard drawer** — **Recent notifications** + **View all**; quick links include **Tasks**.
7. **Sync & diagnostics** — **Settings → Sync & diagnostics** — **Local data snapshot** counts match expectations; **API server** shows whether `API_BASE_URL` was passed at build time; when online and a URL is set, **Test connection** calls `GET /health` (expect `200` when the NestJS app exposes that route). **Sync now**: when **signed in with the online API** (JWT), runs **`GET /sync/pull`** then **`POST /sync/push`**; accepted outbox rows are marked synced — the server persists mutations in Postgres and pull returns the append log for that shop (see `plan-04-backend-api.md`). **Queued local changes** reflects rows in the **persisted outbox** (Isar on device; in-memory on Web). **Pending mutations** lists recent queue entries (kind + time).
8. **New order** — From Orders toolbar → **composer** (customer, measurements/profile, delivery, totals, save) → detail for new id.
9. **Settings → Subscription** — Opens; back returns.
10. **License (debug)** — Settings → set **Expired** → **New order** should redirect to **Subscription**; order detail and internal notes become read-only where enforced.
11. **Backup & restore (native only)** — **Settings → Backup & restore**: owner password (`pride-dev-owner` in dev). Exports **v2 JSON** (`pride_backup_v2_*.json`): customers, **measurement types + profiles + profile lines**, orders (including **internal notes**), payments, order measurement snapshots, notifications. **v1** backup files still restore (without measurement tables). Restore **merges** as before. **Web** shows “use native app” (no Isar).
12. **Reports** — **Reports** → **Unpaid**: segments **All / Overdue / Due in 7 days**, **remaining balance** dropdown (Any / brackets), sort **Amount** vs **Due date**, totals update, row opens order detail. **Monthly income**: **Daily payments** bar strip for the selected month; toggle **Compare to previous month**; change the month with arrows and confirm previous-month payment total and **Change from previous month** line. **Reports** tab overview: **This month income** respects **Settings → calendar** (Gregorian vs solar Hijri month).
13. **Reports** — **Reports** → **Payments ledger**: pick a date range, verify total updates; use **Group by** **Day / Week / Month** and confirm section headers and subtotals; tapping a row opens the order (when the order still exists locally).
14. **Tasks** — **Settings → Tasks**: add a task (title + optional notes), set/clear due date, mark done/undone, edit, and delete (soft delete) with confirmation.
15. **Thermal printer (Android / iOS)** — Put a **network ESC/POS** printer on the same LAN (often raw TCP **port 9100**). **Settings → Printer**: enter host/IP, port, paper width (**58 mm** or **80 mm**), **Save**, then **Test print**. Open an **order** → app bar **Print** sends a receipt with totals and payment lines. **Web** explains that hardware printing needs the mobile app (no TCP print path in the browser). iOS may prompt once for **Local Network** access so the app can reach a private IP.
16. **Developer portal (debug)** — Enable **Developer account** in Settings → **Diagnostics** tab shows **local** entity counts (offline).

When you add **RTL** or **new strings**, repeat on **Web** and **Android** at least once.

---

## Future: integration / E2E tests

When the app grows, consider:

- `integration_test/` + `flutter test integration_test/...`
- Golden tests for stable widgets (optional)

Document new suites in this file when you add them.

---

## Chat with Cursor: what to ask

- *“Run `flutter analyze` and `flutter test` and fix all issues before stopping.”*
- *“After edits, regenerate l10n if ARB changed.”*
- *“Do not remove imports until `flutter analyze` is clean.”*
- *“Summarize what you changed and list the exact commands you ran.”*
- *“Android SDK / `flutter doctor` issues — follow `TESTING.md` Android SDK section.”*

Point the agent at **`AGENTS.md`**, **`TESTING.md`**, and the relevant **`plan-NN-*.md`** for the feature.

---

## Optional Sentry (crash / performance)

- **Default:** no DSN → Sentry is not initialized; tests and local runs behave as before.
- **Enable:** pass `--dart-define=PRIDE_SENTRY_DSN=<your DSN>` (see **`plan-20-flutter-tooling-and-environments.md`** for `PRIDE_SENTRY_ENV` and `PRIDE_SENTRY_TRACES_SAMPLE_RATE`).
- **Smoke:** after enabling, trigger a handled error or use Sentry’s test event from the dashboard to confirm events arrive for the correct environment.
