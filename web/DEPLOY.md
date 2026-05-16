# Deploy Pride Web (Cloudflare Pages)

Matches **`plan-07-hosting-devops.md`** (static `build/web/`) and **`plan-21-launch-deployment.md`**.

## Build locally

```powershell
flutter pub get
flutter gen-l10n
flutter build web --release --dart-define-from-file=config/dart_defines_prod.json
```

Output: **`build/web/`**. Production API URL is in [`config/dart_defines_prod.json`](../config/dart_defines_prod.json) (`API_BASE_URL`).

## CI deploy (recommended)

Workflow: [`.github/workflows/deploy_web.yml`](../.github/workflows/deploy_web.yml)

### One-time GitHub + Cloudflare setup

1. **Cloudflare** → **Workers & Pages** → create project **pride-v3-web** (or any name).
2. **Cloudflare** → profile → **API Tokens** → create token with **Cloudflare Pages — Edit**.
3. Copy **Account ID** from the Cloudflare dashboard URL or overview page.
4. **GitHub** repo → **Settings → Secrets and variables → Actions**:
   - `CLOUDFLARE_API_TOKEN` — token from step 2
   - `CLOUDFLARE_ACCOUNT_ID` — account id
5. Optional **variable** `CLOUDFLARE_PAGES_PROJECT` if the Pages project name is not `pride-v3-web`.
6. Push to **`main`** (or run **Actions → Deploy Web → Run workflow**).

After deploy, open the `*.pages.dev` URL (or attach a custom domain in Cloudflare).

### Verify

- App loads over **HTTPS**.
- **Settings → Sync & diagnostics → Test connection** succeeds (API: `https://pride-v3.onrender.com/health`).
- Deep link refresh works (e.g. `/app/orders`) — requires [`_redirects`](_redirects) in the build output.

## Manual upload

Upload the contents of **`build/web/`** to any static host (Cloudflare Pages drag-and-drop, Netlify, Vercel, S3+CDN).

If the site is not at domain root:

```powershell
flutter build web --release --base-href=/your-path/ --dart-define-from-file=config/dart_defines_prod.json
```
