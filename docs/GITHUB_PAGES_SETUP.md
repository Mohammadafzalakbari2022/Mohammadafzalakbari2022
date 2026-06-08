# GitHub Pages — Privacy policy

**Play Store URL (after Pages is live):**

https://mohammadafzalakbari2022.github.io/Mohammadafzalakbari2022/privacy-policy.html

---

## Why deploy fails with `404 Not Found`

Your log shows:

- Upload artifact: **success**
- `actions/deploy-pages`: **404** — *"Ensure GitHub Pages has been enabled"*

That means GitHub has **not registered Pages for this repo** with source **GitHub Actions**. Making the repo public is not enough by itself.

---

## Fix A — Fastest (recommended if Actions keeps failing)

Use **branch deploy** (no workflow required):

1. Open:  
   https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/settings/pages

2. **Build and deployment → Source:** choose **Deploy from a branch**

3. **Branch:** `main`  
   **Folder:** `/docs`  
   Click **Save**

4. Wait **2–5 minutes**, then open:  
   https://mohammadafzalakbari2022.github.io/Mohammadafzalakbari2022/privacy-policy.html

5. Paste that URL in Play Console → **Privacy policy**

You can ignore the failed Actions workflow if this works.

---

## Fix B — GitHub Actions deploy (for automatic updates on push)

1. Open:  
   https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/settings/pages

2. **Build and deployment → Source:** choose **GitHub Actions**  
   (Not “Deploy from a branch”.)

3. If you do not see **GitHub Actions**:
   - Confirm repo is **Public**
   - Refresh the page
   - Try Fix A first, then switch back to GitHub Actions later

4. Merge the latest `deploy-privacy-pages.yml` to **main** (two-job build + deploy).

5. Run workflow:  
   https://github.com/Mohammadafzalakbari2022/Mohammadafzalakbari2022/actions/workflows/deploy-privacy-pages.yml  
   → **Run workflow** → branch **main**

6. If prompted, approve **github-pages** environment deployment.

7. Verify the privacy URL in your browser.

---

## Play Console

- **Privacy policy URL:** use the link at the top of this file  
- **Package name:** `com.pridev3.pride_v3`

---

## Troubleshooting

| Symptom | What to do |
|---------|------------|
| 404 on deploy-pages step | Source must be **GitHub Actions** (Fix B step 2), or use Fix A |
| No “GitHub Actions” in Source dropdown | Use Fix A (branch + `/docs`) |
| Site 404 after branch deploy | Wait 5 min; confirm branch `main` and folder `/docs` |
| Workflow not listed | File must exist on **main**: `.github/workflows/deploy-privacy-pages.yml` |
