# Deploy Pride Web (GitHub Actions → Cloudflare Pages)

## Do NOT use Cloudflare “Connect to Git” + `npx wrangler deploy`

If your build log shows:

- `Output Directory: docs`
- `Read 4 files from the assets directory .../docs`
- `npx wrangler deploy` and a URL ending in **`*.workers.dev`**

then Cloudflare deployed the **wrong thing**: the small **APK download landing page** in [`docs/`](../docs/) (Dari install guide), **not** the Flutter app. The Flutter app only exists after `flutter build web` in **`build/web/`** (~5 MB `main.dart.js`, `canvaskit/`, etc.).

| URL pattern | What it is |
|-------------|------------|
| **`https://pride-v3-web.pages.dev`** | **Cloudflare Pages** — this is what the README uses for the web **app** |
| **`https://pride-v3-web.*.workers.dev`** | **Cloudflare Worker** — your log deployed here with only `docs/` |

**Fix:** In Cloudflare, open the project that is tied to Git → **Settings** → disconnect or delete that Worker-style Git build. Then deploy **`build/web/`** using one of the methods below (GitHub **Deploy Web** workflow or **Direct Upload** / `wrangler pages deploy`, not `wrangler deploy`).

---

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

Upload the **contents** of **`build/web/`** (so `index.html` is at the site root), not the `web/` source folder and not a nested `build/web/` path.

```powershell
.\scripts\build-flutter-with-defines.ps1 build web --release
.\scripts\verify-web-build.ps1
```

Then Cloudflare → **pride-v3-web** → **Create deployment** → **Direct Upload** → select **all files inside** `build\web\` (or use Wrangler: `npx wrangler pages deploy build/web --project-name=pride-v3-web`).

If not at domain root:

```powershell
.\scripts\build-flutter-with-defines.ps1 build web --release --base-href=/your-path/
```

## Troubleshooting (page blank, 503, or “not loading”)

| Symptom | Likely cause | Fix |
|--------|----------------|-----|
| **503** on `*.pages.dev` | No successful **Production** deployment | Cloudflare → **Deployments** → latest must be **Success** and marked Production. Re-upload or re-run GitHub **Deploy Web**. |
| **Blank white page**, HTML loads | Uploaded **`web/`** source instead of **`build/web/`** | `index.html` still contains `$FLUTTER_BASE_HREF`; `main.dart.js` missing. Rebuild Flutter, run `.\scripts\verify-web-build.ps1`, upload again. |
| **404** on `/main.dart.js` | Wrong zip/folder shape (nested `build/web/index.html`) | Deploy **files inside** `build/web/`, not the parent `build` folder. |
| CI “succeeds” but site empty | **Connect repo** on Cloudflare with wrong build (no Flutter) | Do **not** use Cloudflare’s Git build for this app. Use **GitHub Actions** (`deploy_web.yml`) or **Direct Upload** of `build/web/` only. |
| Build log: **`docs`**, 4 files, **`wrangler deploy`**, **workers.dev** | Worker deploy of install landing page, not Pages Flutter build | Remove Git Worker build; deploy `build/web/` to **Pages** (see top of this file). |
| **`pages.dev` broken**, log shows **workers.dev** success | App never uploaded to **Pages** | Same fix; `pages.dev` and `workers.dev` are different targets. |
| Deep links 404 | `_redirects` missing from deploy | Must be in `build/web/` after `flutter build web` (copied from `web/_redirects`). |

**Quick checks in the browser** (replace with your Pages URL):

1. `https://pride-v3-web.pages.dev/` — View source: `<base href="/">` and `<script src="flutter_bootstrap.js">`.
2. `https://pride-v3-web.pages.dev/flutter_bootstrap.js` — should return JavaScript (not 404).
3. `https://pride-v3-web.pages.dev/main.dart.js` — large file (~5+ MB); 404 means wrong upload.

**GitHub Actions:** repo → **Actions** → **Deploy Web** → latest run must be green. Needs secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID`. A red run means nothing new reached Pages.
