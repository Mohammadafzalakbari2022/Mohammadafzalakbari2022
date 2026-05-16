# Deploy Pride Web (GitHub Actions → Cloudflare Pages)

## Why this stack (free + reliable)

| Piece | Role |
|--------|------|
| **GitHub Actions** | Builds Flutter on every push (free for public repos). Flutter web builds are awkward on Cloudflare’s default “connect repo” builders. |
| **Cloudflare Pages** | Hosts static `build/web/` on a **global CDN** — fast, generous free tier, HTTPS included. |

We do **not** use GitHub Secrets or Cloudflare environment variables for app config. All compile-time values use **stacked** `--dart-define-from-file` JSON in [`config/`](../config/) (no `.env`).

**Stack order** (later files override earlier keys):

1. [`config/dart_defines_base.json`](../config/dart_defines_base.json) — shared defaults (e.g. Sentry off)
2. [`config/dart_defines_prod.json`](../config/dart_defines_prod.json) — `ENV`, `API_BASE_URL`

## One-time setup (about 5 minutes)

1. **Cloudflare** → **Workers & Pages** → **Create** → **Pages** → project name **`pride-v3-web`** (Direct Upload is fine; CI will push builds).
2. **Cloudflare** → profile → **API Tokens** → **Create** → template **Edit Cloudflare Workers** (includes Pages) or custom with **Account → Cloudflare Pages → Edit**.
3. Copy your **Account ID** (dashboard home, right column).
4. **GitHub** → this repo → **Settings → Secrets and variables → Actions → New repository secret**:
   - `CLOUDFLARE_API_TOKEN` — token from step 2
   - `CLOUDFLARE_ACCOUNT_ID` — account id from step 3
5. Commit and push to **`main`**, or **Actions → Deploy Web → Run workflow**.

First successful run uploads `build/web/` to Pages. Open the **`*.pages.dev`** URL from the Cloudflare project overview (optional custom domain later).

**Do not** add Flutter `API_BASE_URL` to Cloudflare “Environment variables” — those are for Workers, not your static Flutter bundle.

## Build locally (same defines as CI)

```powershell
flutter pub get
flutter gen-l10n
.\scripts\build-flutter-with-defines.ps1 build web --release
```

Or explicitly:

```powershell
flutter build web --release `
  --dart-define-from-file=config/dart_defines_base.json `
  --dart-define-from-file=config/dart_defines_prod.json
```

Output: **`build/web/`**.

## Staging (optional)

Copy [`config/dart_defines_staging.json.example`](../config/dart_defines_staging.json.example) to `config/dart_defines_staging.json`, set staging `API_BASE_URL`, then:

```powershell
.\scripts\build-flutter-with-defines.ps1 staging build web --release
```

## Verify after deploy

- App loads over **HTTPS**.
- **Settings → Sync & diagnostics → Test connection** → OK (`GET /health` on prod API).
- Refresh a deep link (e.g. `/app/orders`) — needs [`_redirects`](_redirects) in the build output.

## Manual upload (no GitHub)

Upload **`build/web/`** via Cloudflare Pages **Direct Upload** if you prefer not to use Actions.

If not at domain root:

```powershell
.\scripts\build-flutter-with-defines.ps1 build web --release --base-href=/your-path/
```
