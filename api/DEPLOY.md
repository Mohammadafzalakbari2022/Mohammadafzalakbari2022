# Deploy `pride-api` (NestJS)

## Local

```bash
cd api
npm install
npm run start:dev
```

- `GET http://localhost:3000/health` → `{ "status": "ok", "service": "pride-api" }`

### Windows: `npm install` fails with `ENOTEMPTY`

Delete `api/node_modules` completely, then run `npm install` again (sometimes caused by interrupted installs or antivirus locking files).

### Do not use `npm audit fix --force` here

`--force` can upgrade **only some** `@nestjs/*` packages (e.g. core to v11 while `common` stays v10), which **breaks peer dependencies** and can corrupt `node_modules` (symptoms: Jest / `@babel/types` missing files like `getFunctionName.js`). If that happened: delete `api/node_modules` and `api/package-lock.json`, restore `package.json` from git, then run `npm install`. Use `npm audit` for awareness; fix transitive issues only when a **coherent** Nest upgrade is planned.

## Render (free tier, cold starts OK — plan-07)

> **Primary deploy target:** [Vercel](#vercel-recommended) (zero-config NestJS, Fluid compute).
> Render remains documented below as a fallback.

Root [`render.yaml`](../render.yaml) targets **Supabase (or any external Postgres)**:
there is **no** Render-managed database in the blueprint. You paste **`DATABASE_URL`**
in the dashboard when prompted (`sync: false`). **`JWT_SECRET`** is auto-generated unless
you replace it manually.

### Option A — Blueprint + Supabase Postgres (recommended)

1. **Supabase:** create a project → **Project Settings → Database**. Copy the **URI**
   (current project ref: `uplksiwbfmktlssnnxcs`, region `aws-1-ap-southeast-1`).
   - **Runtime (Render / API):** pooler port **6543** with `?pgbouncer=true&sslmode=require`
   - **Migrations (local `prisma migrate deploy`):** pooler port **5432** with `?sslmode=require`
   URL-encode special characters in the password (e.g. `@` → `%40`).
2. **Git:** push this repo to GitHub (or your Git provider Render supports).
3. **Render:** **New** → **Blueprint** → select the repo (`render.yaml` at repo root).
4. When Render asks for **synchronized environment variables**, set **`DATABASE_URL`**
   (pooler port **6543**) and **`DIRECT_DATABASE_URL`** (pooler port **5432** for migrations).
   Leave **`JWT_SECRET`** as generated, or set your own long secret.
5. **Build** runs `npm install --include=dev && npm run build` (`prisma generate` + Nest compile). On Render, `NODE_ENV=production` during build would otherwise **omit devDependencies**, so `nest` is missing — **`--include=dev`** fixes `sh: nest: not found`.
   **`preDeployCommand`** runs `npx prisma migrate deploy` against that URL before the
   new release goes live (creates `shops`, `shop_users`, etc.).
6. Open the service URL (e.g. `https://pride-api.onrender.com`) and confirm
   `GET /health` returns `200`.

**First sign-in (production `NODE_ENV=production`):** the API does **not** apply the local
dev default `owner` / `changeme` unless you set **`PRIDE_AUTH_SEED`** (Dashboard → **Environment**).
Format: `shop_id|username|password` or `shop_id|Shop Display Name|username|password`
(see [`api/README.md`](README.md)). Alternatively, call **`POST /shop/create`** once (no JWT)
to create the first shop and owner, then sign in from the Flutter app.

**Optional env (Dashboard):** `PRIDE_DEVELOPER_IDS`, `PRIDE_AUTH_SEED`, and any future flags
documented in [`api/.env.example`](.env.example).

### Render logs — normal vs failed

A **successful** deploy ends with:

- `Nest application successfully started`
- `Your service is live` and your URL (e.g. `https://mohammadafzalakbari2022.onrender.com`)

These lines are **not** errors:

- `FCM: FIREBASE_SERVICE_ACCOUNT_JSON not set (optional) — push delivery disabled.` — push
  notifications only; login, sync, and billing work without it. To enable FCM, add
  **`FIREBASE_SERVICE_ACCOUNT_JSON`** in Render → **Environment** (full Firebase service
  account JSON, one line).
- `Seeded shop "…"` / `Operator seed: user "…" already exists` — idempotent
  **`PRIDE_AUTH_SEED`** / **`PRIDE_OPERATOR_SEED`** bootstrap.

Confirm the API: `GET /health` → `200` and `{"status":"ok","service":"pride-api"}`.

A **failed** deploy usually shows **`ERROR`** or exits during **Build** / **Pre-deploy**
(e.g. `sh: nest: not found`, Prisma `P1001` / migration errors) — not the route-mapping
`LOG` block at startup.

### Option B — Render-managed Postgres

Add a `databases` entry to `render.yaml` and wire `DATABASE_URL` with `fromDatabase`
(see [Render blueprint spec](https://render.com/docs/blueprint-spec)). Keep the same
**build** / **preDeploy** / **start** commands as today.

### Option C — Web Service only (manual)

Create a **Web Service** with **root directory** `api`, same **build** / **preDeploy** /
**start** as in `render.yaml`, and set **`DATABASE_URL`**, **`JWT_SECRET`**, **`NODE_ENV=production`**
by hand. Do **not** commit secrets to git.

**Build command on Render (manual service):** use  
`npm install --include=dev && npm run build`  
(not plain `npm install && npm run build`), for the reason above.

### Flutter client

Use your deployed origin (no trailing slash):

```text
flutter run \
  --dart-define-from-file=config/dart_defines_base.json \
  --dart-define-from-file=config/dart_defines_prod.json
```
(production URL in repo: `https://mohammadafzalakbari2022.onrender.com`)

**Settings → Sync & diagnostics → Test connection** should report OK against `GET /health`.

`PORT` is set automatically by Render; the app reads `process.env.PORT`.

## Vercel (recommended)

Vercel detects NestJS from `src/main.ts` with **zero configuration** (single Fluid compute
function). Flutter Web stays on **Cloudflare Pages**; only this API deploys to Vercel.

### One-time: Vercel project settings

1. **Import repo:** [vercel.com/new](https://vercel.com/new) → your GitHub repo.
2. **Root Directory:** `api` (not repo root).
3. **Framework Preset:** NestJS (auto-detected).
4. **Build Command:** leave default or set `npm run build:vercel` (same as [`vercel.json`](vercel.json)).
5. **Output Directory:** leave empty (Vercel serves the NestJS function; no static output).
6. **Install Command:** `npm install` (default).

Or link from CLI (from repo root):

```bash
cd api
npm i -g vercel   # CLI >= 48.4.0
vercel link       # create/link project; set root = api when prompted
vercel env pull   # optional: pull env vars to .env.local for `vercel dev`
vercel            # preview deploy
vercel --prod     # production
```

### Environment variables (Vercel Dashboard → Project → Settings → Environment Variables)

Set for **Production** (and Preview if you want staging previews):

| Variable | Purpose |
|----------|---------|
| `NODE_ENV` | `production` |
| `DATABASE_URL` | Supabase **transaction pooler** — port **6543**, `?pgbouncer=true&sslmode=require` |
| `DIRECT_DATABASE_URL` | Supabase **session pooler** — port **5432**, `?sslmode=require` (Prisma migrations at build) |
| `JWT_SECRET` | Long random secret for JWT signing |
| `PRIDE_AUTH_SEED` | First shop owner, e.g. `dev\|owner\|changeme` |
| `PRIDE_OPERATOR_SEED` | Optional operator user, e.g. `dev\|Akbari\|YOUR_PASSWORD` |
| `PRIDE_DEVELOPER_USERS` | Developer portal logins, e.g. `dev\|Akbari` |
| `CRON_SECRET` | Random string; Vercel Cron sends `Authorization: Bearer …` to `/api/cron/license-expiry` |
| `FIREBASE_SERVICE_ACCOUNT_JSON` | Optional — FCM push (one-line JSON) |

**Do not commit secrets.** Paste values in the Vercel dashboard only.

URL-encode special characters in database passwords (e.g. `@` → `%40`).

Example Supabase URLs (replace password; project ref `uplksiwbfmktlssnnxcs`):

```text
DATABASE_URL=postgresql://postgres.uplksiwbfmktlssnnxcs:YOUR_PASSWORD@aws-1-ap-southeast-1.pooler.supabase.com:6543/postgres?pgbouncer=true&sslmode=require
DIRECT_DATABASE_URL=postgresql://postgres.uplksiwbfmktlssnnxcs:YOUR_PASSWORD@aws-1-ap-southeast-1.pooler.supabase.com:5432/postgres?sslmode=require
```

### Build and migrations

[`vercel.json`](vercel.json) runs `npm run build:vercel`:

1. `prisma generate`
2. `prisma migrate deploy` (uses `DIRECT_DATABASE_URL` via [`prisma/schema.prisma`](prisma/schema.prisma))
3. `nest build`

If migrations fail at build, confirm `DIRECT_DATABASE_URL` uses port **5432** (not 6543).

### Health check after deploy

Replace `YOUR_VERCEL_URL` with the deployment URL (e.g. `https://pride-api.vercel.app`):

```bash
curl -s https://YOUR_VERCEL_URL/health
# → {"status":"ok","service":"pride-api"}
```

### Cron jobs (license expiry push)

On Vercel, in-process `@nestjs/schedule` cron does **not** run between requests.
[`vercel.json`](vercel.json) registers a **Vercel Cron** at `09:00 UTC` → `GET /api/cron/license-expiry`.
Set `CRON_SECRET` in the dashboard; the handler rejects requests without the matching Bearer token.

Local dev (`nest start:dev`) still uses in-process cron when `VERCEL` is unset.

### Flutter client after first Vercel deploy

Update `config/dart_defines_prod.json` **`API_BASE_URL`** to your Vercel production URL
(no trailing slash). Until then the repo still points at Render:

```json
"API_BASE_URL": "https://mohammadafzalakbari2022.onrender.com"
```

Then rebuild/release the app:

```text
flutter run \
  --dart-define-from-file=config/dart_defines_base.json \
  --dart-define-from-file=config/dart_defines_prod.json
```

**Settings → Sync & diagnostics → Test connection** should hit `GET {API_BASE_URL}/health`.

### Local dev with Vercel runtime

From `api/`:

```bash
vercel dev
```

Uses the same serverless entry as production (requires Vercel CLI >= 48.4.0).

### Git auto-deploy

Connect the repo in Vercel; pushes to `main` that touch `api/**` trigger production deploys.
Optional: disable or keep [`.github/workflows/deploy_api.yml`](../.github/workflows/deploy_api.yml)
(Render hook) if you fully move off Render.

## Hesab Pay billing (Developer Portal + subscription screen)

After deploy, confirm billing routes exist (401 without JWT is OK; **404 means an old API build**):

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://mohammadafzalakbari2022.onrender.com/admin/billing-info
```

Production Postgres must include `subscription_billing_config` and `subscription_payment_claims`, and `_prisma_migrations` must list all migrations in `api/prisma/migrations/` (use `npx prisma migrate deploy` or baseline per [Prisma baselining](https://www.prisma.io/docs/guides/migrate/developing-with-prisma-migrate/add-prisma-migrate-to-a-project#baseline-your-production-environment)).

**Auto redeploy on `api/**` pushes:** [`.github/workflows/deploy_api.yml`](../.github/workflows/deploy_api.yml) calls your Render **Deploy Hook** on every `api/**` push to `main`.

### One-time: GitHub secret `RENDER_DEPLOY_HOOK_URL` (required)

Without this secret, the **Deploy API** workflow fails and Render does **not** get a new build.

1. **Render:** open your web service (e.g. `pride-v3` on Render) → **Settings** → **Deploy Hook** → **Create deploy hook** → copy the full URL (`https://api.render.com/deploy/srv-…?key=…`).
2. **GitHub:** repo **Settings** → **Secrets and variables** → **Actions** → **New repository secret**
   - Name: `RENDER_DEPLOY_HOOK_URL`
   - Value: paste the deploy hook URL
3. **Redeploy:** **Actions** → **Deploy API** → **Run workflow** → branch `main` → **Run workflow**

Or in GitHub Desktop: push any commit under `api/`, or use **Repository** → **Open in GitHub** → **Actions** → **Deploy API** → **Run workflow**.

**CLI (after `gh auth login`):** `gh workflow run deploy_api.yml --ref main`

**Manual fallback:** Render dashboard → your service → **Manual Deploy** → **Deploy latest commit**.

## Launch checklist (plan-07 / plan-21)

- **API:** set `DATABASE_URL`, `DIRECT_DATABASE_URL` (hosted Supabase), `JWT_SECRET`, optional `PRIDE_DEVELOPER_IDS` (comma-separated `shop_users.id`, same as JWT `sub`, for developer-only admin routes), optional `PRIDE_LEGACY_REDEEM_CODES`, optional `CATALOG_SHARING_DEFAULT` (`false` turns off default catalog sharing in `GET /catalog/public`). On Vercel also set `CRON_SECRET` for license-expiry cron.
- **Flutter:** pass `--dart-define=API_BASE_URL=…` for release builds; confirm **Settings → Sync & diagnostics → Test connection** and a **sign-in** round-trip against production.
- **Web / PWA:** smoke-test installability, offline shell, and same API base URL as mobile.
- **Stores:** signing keys, listing text, privacy policy URL, and support contact before submission.
