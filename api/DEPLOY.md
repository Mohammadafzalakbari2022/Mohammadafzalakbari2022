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

Root [`render.yaml`](../render.yaml) targets **Supabase (or any external Postgres)**:
there is **no** Render-managed database in the blueprint. You paste **`DATABASE_URL`**
in the dashboard when prompted (`sync: false`). **`JWT_SECRET`** is auto-generated unless
you replace it manually.

### Option A — Blueprint + Supabase Postgres (recommended)

1. **Supabase:** create a project → **Project Settings → Database**. Copy the **URI**
   (prefer **Direct connection** for this API so migrations and runtime use the same URL;
   ensure **`?sslmode=require`** if required by your region/host).
2. **Git:** push this repo to GitHub (or your Git provider Render supports).
3. **Render:** **New** → **Blueprint** → select the repo (`render.yaml` at repo root).
4. When Render asks for **synchronized environment variables**, set **`DATABASE_URL`**
   to the Supabase URI. Leave **`JWT_SECRET`** as generated, or set your own long secret.
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
(production URL in repo: `https://pride-v3.onrender.com`)

**Settings → Sync & diagnostics → Test connection** should report OK against `GET /health`.

`PORT` is set automatically by Render; the app reads `process.env.PORT`.

## Hesab Pay billing (Developer Portal + subscription screen)

After deploy, confirm billing routes exist (401 without JWT is OK; **404 means an old API build**):

```bash
curl -s -o /dev/null -w "%{http_code}\n" https://pride-v3.onrender.com/admin/billing-info
```

Production Postgres must include `subscription_billing_config` and `subscription_payment_claims`, and `_prisma_migrations` must list all migrations in `api/prisma/migrations/` (use `npx prisma migrate deploy` or baseline per [Prisma baselining](https://www.prisma.io/docs/guides/migrate/developing-with-prisma-migrate/add-prisma-migrate-to-a-project#baseline-your-production-environment)).

**Auto redeploy on `api/**` pushes:** add [`.github/workflows/deploy_api.yml`](../.github/workflows/deploy_api.yml) and set GitHub secret `RENDER_DEPLOY_HOOK_URL` (Render → service → **Deploy Hook**).

## Launch checklist (plan-07 / plan-21)

- **API:** set `DATABASE_URL`, `JWT_SECRET`, optional `PRIDE_DEVELOPER_IDS` (comma-separated `shop_users.id`, same as JWT `sub`, for developer-only admin routes), optional `PRIDE_LEGACY_REDEEM_CODES`, optional `CATALOG_SHARING_DEFAULT` (`false` turns off default catalog sharing in `GET /catalog/public`).
- **Flutter:** pass `--dart-define=API_BASE_URL=…` for release builds; confirm **Settings → Sync & diagnostics → Test connection** and a **sign-in** round-trip against production.
- **Web / PWA:** smoke-test installability, offline shell, and same API base URL as mobile.
- **Stores:** signing keys, listing text, privacy policy URL, and support contact before submission.
