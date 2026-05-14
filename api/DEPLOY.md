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

### Option A — Blueprint (repo root [`render.yaml`](../render.yaml))

1. Push this repo to GitHub (or connect Render to your Git provider).
2. In the Render dashboard: **New** → **Blueprint** → select the repo (file `render.yaml` at the root).
3. The blueprint provisions **Render Postgres** (`pride-postgres`) and a **Node web service** (`pride-api`, `rootDir: api`).
4. **Build** runs `npm install && npm run build` (`prisma generate` + Nest compile). **`preDeployCommand`** runs `npx prisma migrate deploy` so tables exist before traffic switches to the new release.
5. After a green deploy, open the web service URL (e.g. `https://pride-api.onrender.com`) and confirm `GET /health` returns `200`.

**First sign-in (production `NODE_ENV=production`):** the API does **not** apply the local dev default `owner` / `changeme` unless you set **`PRIDE_AUTH_SEED`** on the service (Dashboard → **Environment**). Format: `shop_id|username|password` or `shop_id|Shop Display Name|username|password` (see [`api/README.md`](README.md)). Alternatively, call **`POST /shop/create`** once (no JWT) to create the first shop and owner, then sign in with the Flutter app.

**Optional env (Dashboard):** `PRIDE_DEVELOPER_IDS`, `CATALOG_SHARING_DEFAULT`, `PRIDE_AUTH_SEED`.

If **Render Postgres `plan: free`** is no longer available for new accounts, edit `render.yaml` to use e.g. `basic-256mb`, or use Option B.

### Option B — External Postgres (Neon, Supabase pooler, RDS, …)

1. Create a Postgres database and a connection string `DATABASE_URL` (SSL params included if your host requires them).
2. Create a **Web Service** on Render with **root directory** `api`, same **build** / **preDeploy** / **start** commands as in `render.yaml`.
3. Set **`DATABASE_URL`**, **`JWT_SECRET`** (long random string), and **`NODE_ENV=production`** in the service environment. Do **not** commit secrets to git.

### Flutter client

Use your deployed origin (no trailing slash):

`flutter run --dart-define=API_BASE_URL=https://your-service.onrender.com`

**Settings → Sync & diagnostics → Test connection** should report OK against `GET /health`.

`PORT` is set automatically by Render; the app reads `process.env.PORT`.

## Launch checklist (plan-07 / plan-21)

- **API:** set `DATABASE_URL`, `JWT_SECRET`, optional `PRIDE_DEVELOPER_IDS` (comma-separated JWT `sub` for `/admin/audit-log` and `POST /admin/report`), optional `CATALOG_SHARING_DEFAULT` (`false` turns off default catalog sharing in `GET /catalog/public`).
- **Flutter:** pass `--dart-define=API_BASE_URL=…` for release builds; confirm **Settings → Sync & diagnostics → Test connection** and a **sign-in** round-trip against production.
- **Web / PWA:** smoke-test installability, offline shell, and same API base URL as mobile.
- **Stores:** signing keys, listing text, privacy policy URL, and support contact before submission.
