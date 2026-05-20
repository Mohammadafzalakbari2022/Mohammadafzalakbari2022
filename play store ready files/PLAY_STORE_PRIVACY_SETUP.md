# Google Play — Privacy Policy & Data Safety

Use this checklist when submitting **Pride** to Google Play Console.

## Privacy policy URL (required)

### Option A — GitHub Pages (recommended; no Cloudflare secrets)

1. **One-time:** GitHub → repo **Settings** → **Pages** → **Build and deployment** → **Source:** choose **GitHub Actions** (not “Deploy from branch”).
2. Push is already done; run **Actions** → **Deploy Privacy Policy (GitHub Pages)** → **Run workflow** if needed.
3. After a green run, open **Settings → Pages** and copy the site URL. It is usually:

**https://mohammadafzalakbari2022.github.io/Mohammadafzalakbari2022/docs/privacy-policy.html**

(Live now — open that link in your browser to confirm.)

Use that **exact** URL in Play Console.

Optional: In **Settings → Pages**, switch **Source** to **GitHub Actions** so future deploys use the workflow; the URL may become `/privacy-policy.html` without the `docs/` segment.

### Option B — Cloudflare Pages (when secrets are set)

Requires GitHub secrets `CLOUDFLARE_API_TOKEN` and `CLOUDFLARE_ACCOUNT_ID` (see `web/DEPLOY.md`). Then:

**https://pride-v3-web.pages.dev/privacy-policy.html**

(Custom domain: `https://YOUR-DOMAIN/privacy-policy.html`)

### Paste in Play Console

1. Open [Google Play Console](https://play.google.com/console).
2. Select **Pride**.
3. **Policy** → **App content** → **Privacy policy**.
4. Enter the URL above → **Save**.

Also set the same URL under **Store settings** → **Contact details** if asked for a privacy policy link.

---

## Update contact email (recommended)

The HTML policy currently lists:

`afzalakbari2017@gmail.com`

Edit `web/privacy-policy.html` (search for that address), commit, and redeploy web if you use a dedicated support address (e.g. `support@yourdomain.com`). Play Console **Support email** should match.

---

## Data safety form (align with the app)

Answer honestly in **App content** → **Data safety**. Summary for Pride v3.5.5:

| Data type | Collected? | Shared? | Purpose |
|-----------|------------|---------|---------|
| **Name** | Yes (customers, users) | No | App functionality |
| **Phone number** | Yes (customers) | No | App functionality |
| **Email** | Optional / rare | No | App functionality |
| **Photos** | Yes (catalog, logo) | No | App functionality |
| **Financial info** | Yes (order payments) | No | App functionality |
| **App activity** | Optional (crash logs if Sentry enabled) | With service provider | Analytics / crash logs |
| **Device or other IDs** | Optional (push token) | With service provider | App functionality |

- **Data is encrypted in transit:** Yes (HTTPS).
- **Users can request deletion:** Yes (contact support email).
- **Data is not sold.**

**Permissions declared in the app:** Internet, read/write contacts (optional user action), camera/photos via image picker.

---

## Activation codes (policy note)

The app is **free** on Play Store; subscriptions use **activation codes** outside Google Play billing. The privacy policy already mentions this. In the store listing, avoid directing users to off-store payment inside the app UI (see `description and tags for pride.txt`).

---

## Redeploy privacy page only

Edit **`docs/privacy-policy.html`** (and copy the same changes to **`web/privacy-policy.html`** if you use Cloudflare later). Push to `main` → **Deploy Privacy Policy (GitHub Pages)** runs automatically.

---

## Quick verify

Open in a browser (GitHub Pages URL after setup):

- https://mohammadafzalakbari2022.github.io/Mohammadafzalakbari2022/docs/privacy-policy.html

You should see the purple header and full policy text. Use this exact URL in Play Console.
