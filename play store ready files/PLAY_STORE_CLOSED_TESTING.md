# Google Play — closed testing CSV & 12 testers

## What Play Console wants

| Field | Required? |
|-------|-------------|
| **Email** (Gmail / Google account) | **Yes** |
| Name | Optional in UI only — **not** in CSV |
| Phone | **No** — do not put phone numbers in the CSV |

CSV rules (from Google):

- **One email per line**
- **No commas** in the file
- **No header row** (do not write `Email Address` unless the upload screen explicitly asks for it)
- Save as plain `.csv` — avoid UTF-8 with BOM (Notepad “UTF-8” on Windows can break upload; use VS Code / Cursor “Save with Encoding → UTF-8”)

---

## File to upload

**`play-store-closed-testers.csv`** (15 lines — more than the minimum 12)

1. Open the file and **replace** `khayat.tester02@gmail.com` … `khayat.tester15@gmail.com` with **real Gmail addresses** of people who will test (friends, family, colleagues).
2. Keep `afzalakbari2017@gmail.com` or swap in your other accounts.
3. In Play Console: **Test and release → Testing → Closed testing → Testers → Create email list** → **Upload CSV**.

**Warning:** Uploading CSV **overwrites** emails you typed in the box. Put all addresses in the CSV first.

---

## Why it still says “12 testers” after you add 2–3 emails

For **new personal developer accounts**, Google requires:

- **At least 12 testers opted in** (not just listed)
- **14 continuous days** with the closed test active (AAB uploaded + release published)
- Testers must open your **opt-in link**, accept, install from Play, and stay opted in

So:

- Adding 3 emails → only **3 on the list**
- **Fake emails** in the CSV do **not** count as opted-in unless someone signs into that Google account and joins
- The dashboard number that matters is **“Opted-in testers”**, not “emails in CSV”

---

## Steps that actually clear the requirement

1. **Closed testing** track → upload **Khayat-release.aab** → **Review release** → **Start rollout**
2. **Testers** → email list → upload **`play-store-closed-testers.csv`** (12+ real Gmail addresses)
3. Copy the **opt-in link** from the closed test page
4. Send the link to each tester (WhatsApp, email, etc.)
5. Each person: open link → **Become a tester** → install from Play Store
6. Wait until the console shows **≥ 12 opted-in** for **14 days**, then **Apply for production access**

---

## Quick opt-in message (copy for testers)

```
سلام — لطفاً برای تست برنامهٔ خیاط این لینک را باز کنید، «Become a tester» را بزنید و برنامه را از Play نصب کنید:

[PASTE YOUR OPT-IN LINK HERE]

ممنون!
```

---

## If you only need to satisfy the CSV upload field

Use the provided CSV as-is to upload 15 lines. For **production access**, you still need **12 real people** with Google accounts to opt in — placeholders alone will not finish the 14-day rule.
