# Afghan Pride — Hosting/DevOps Plan (Supabase + Railway)

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
  - deploy API to Railway on main branch

## Secrets management
- Never commit keys
- Use Railway env vars + Supabase secrets

