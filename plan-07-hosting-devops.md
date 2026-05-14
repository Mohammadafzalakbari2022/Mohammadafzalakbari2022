# Afghan Pride — Hosting/DevOps Plan (Supabase + Railway)

## Product decision — MVP hosting (cold starts OK)

For **early dev / pilot** usage, the product owner accepts **API cold starts** after idle (often **~10–60+ seconds** for the first request, then normal speed until the service sleeps again). That unlocks **zero/low-cost** API hosting on typical **free web service** tiers.

**Implication for UX:** the Flutter app should treat sync as **best-effort / background** (already offline-first); avoid UX that assumes an always-on API for every tap.

## Hosting strategy lock (free-first; aligned with plan-00)

The **documented MVP default** stays **free-tier hosting** (Supabase + **Render Free** API + **Cloudflare Pages** for web static builds), with **cold starts acceptable** as in Option A below. This matches **`plan-00-index.md` — Hosting reality check (Free tiers)**.

**Paid or “business” hosting** is only an **explicit later upgrade** when you outgrow free limits. It does **not** replace this section unless you deliberately edit these plans—agents should not assume a switch to paid hosting.

## Environments
- **dev**: fast iteration, test data
- **staging**: production-like, used for release testing
- **prod**: real shops

## Supabase (managed)
- Separate Supabase projects per environment (recommended)
- Store configuration:
  - RLS policies
  - edge functions (if used later)
  - database migrations (tracked)

## API hosting (Railway)

### Is “free” possible?
- **Sometimes**, if you stay inside very small monthly usage limits.
- Not reliable as “free forever” if you have real usage.

Notes:
- Railway “free” is best treated as **development / early pilot** hosting.
- Once you have multiple real shops syncing daily, expect to upgrade or move to a stable low-cost host.

### Free-ish fallback options
- **Render Free**: easiest, but sleeping/cold starts
- **Fly.io**: more setup, can be more stable under free allowance

### Recommended “Option A” stack (free-first, cold starts accepted)

| Layer | Suggested host (MVP) | Notes |
|--------|----------------------|--------|
| **Postgres + auth storage + optional file storage** | **Supabase** (free tier per env) | Separate **dev / staging / prod** projects when you can. Core rows (orders, payments, users) stay small for a long time. **Larger growth** usually comes from **images** (catalog) and **backups** — use Storage buckets deliberately and retention rules. |
| **NestJS REST API** | **Render** — *Free Web Service* | Expect **sleep after idle** and the first wake-up delay you already accepted. Fine for pilots and low concurrent traffic. **Repo scaffold:** [`api/`](api/) (NestJS `pride-api`) + root [`render.yaml`](render.yaml) for Blueprint deploy. |
| **Flutter Web (static)** | **Cloudflare Pages** | Strong free tier for static `build/web/` output; matches “Web = limited features, testing + light usage” in the plans. |
| **Android / iOS** | Store or sideload builds | Full feature set per plans; API base URL from `dart-define` / flavors (`plan-20`). |

Rough **order-of-magnitude** for MVP data (not a hard limit): **tens of thousands** of order/payment rows are still tiny on disk; **photos** (catalog, measurement attachments) dominate. Plan **Supabase Storage** quotas and optional image compression before you assume “unlimited” free space.

Additional very-low-cost options (when you outgrow free):
- A small VPS + Docker (predictable monthly cost)

## Frontend hosting (optional Web)
If you want free web hosting for UI testing builds:
- **Cloudflare Pages** (best free static hosting)
- **Vercel/Netlify** (also fine, usage limits apply)

Recommendation:
- Since Web is for UI testing only, prefer Cloudflare Pages and keep Web features limited (no printing/Bluetooth/images).

## CI/CD (recommended)
- GitHub Actions:
  - lint/format/tests
  - build Android APK/AAB for releases
  - build iOS via macOS runner (or later)
  - deploy API to **Render** (Option A) or **Railway** on main branch

## Secrets management
- Never commit keys
- Use **Render** or **Railway** env vars + Supabase secrets

