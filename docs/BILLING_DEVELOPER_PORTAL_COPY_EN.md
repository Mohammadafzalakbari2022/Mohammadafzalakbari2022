# Developer Portal → Billing — copy & paste (English)

Open the app as a **developer** → **Developer portal** → **Billing** tab. Turn on **Published** when you are ready for all shops to see this under **Settings → Subscription**.

Replace the placeholders below with your real Hesab Pay details.

---

## Hesab Pay profile (single line fields)

| Field in app | Paste this (example — edit yours) |
|--------------|-----------------------------------|
| **Account name** | `Afghan Pride` |
| **Account number** | `0700123456` |
| **Merchant / reference ID** | *(optional)* `PRIDE-001` |

---

## Prices (AFN)

| Field | Example value |
|-------|----------------|
| **Price 1 year** | `5000` |
| **Price 2 years** | `9000` |
| **Price lifetime** | `25000` |

---

## Payment link (Hesab Pay link + QR)

| Field | Paste this |
|-------|------------|
| **Payment link URL** | `https://hesab.com/pay/your-merchant-link` *(use the full HTTPS link from Hesab Pay)* |
| **Link name (English)** | `Pay with Hesab Pay` |
| **Link name (Dari)** | `پرداخت با حساب پی` |
| **Link name (Pashto)** | `د حساب پی له لارې تادیه` |

Shops will see a **QR code** (generated from the URL) and a button with the link name. They can scan the QR or tap to open the link in the browser.

---

## Payment steps (English) — paste into **Payment steps (English)**

```
1. Open Hesab Pay on your phone (or scan the QR code / tap the payment link above).
2. Send the exact plan amount in AFN to the account number shown above.
3. Save your Hesab Pay transaction ID from the receipt.
4. In Afghan Pride: Settings → Subscription → "I have paid (Hesab Pay)" — enter the transaction ID and your plan (1 year / 2 years / Lifetime).
5. We will verify your payment and send an activation code (usually within 1 business day).
```

---

## Payment steps (Dari) — **Payment steps (Dari)**

```
۱. حساب پی را در موبایل باز کنید (یا QR را اسکن کنید / روی لینک پرداخت بالا بزنید).
۲. مبلغ دقیق پلن را به شماره حساب بالا واریز کنید.
۳. شناسه تراکنش (Transaction ID) را از رسید حساب پی یادداشت کنید.
۴. در پراید: تنظیمات → اشتراک → «پرداخت کردم» — شناسه تراکنش و پلن را وارد کنید.
۵. پس از تأیید، کد فعال‌سازی برای شما ارسال می‌شود.
```

---

## Payment steps (Pashto) — **Payment steps (Pashto)**

```
۱. په موبایل کې حساب پی خلاص کړئ (یا QR سکین کړئ / د تادیې لینک باندې کلیک وکړئ).
۲. د پلان exact مبلغ په پورته حساب شمېرې ولېږئ.
۳. د حساب پی رسید څخه د معاملې ID خوندي کړئ.
۴. په Pride کې: تنظیمات → اشتراک → «تادیه مې کړې» — ID او پلان ولیکئ.
۵. وروسته به د فعالولو کوډ درسره لیږل شي.
```

---

## Activation delivery (English) — **Activation delivery (English)**

```
After we approve your payment, your activation code will appear in Settings → Subscription under payment history, and we may also send it via WhatsApp if you left your number.
```

---

## Cash payment note (English) — optional

```
You may also pay in cash at our office. Bring this shop ID and your chosen plan. We will give you an activation code on the spot.
```

---

## Contact (for support after payment)

| Field | Example |
|-------|---------|
| **WhatsApp (E.164)** | `+93700123456` |
| **Telegram handle** | `@AfghanPrideSupport` |
| **Direct phone (E.164)** | `+93700123456` |

---

## Checklist before publishing

- [ ] Account name and number match your Hesab Pay merchant account  
- [ ] Payment link opens correctly in a phone browser  
- [ ] Prices match what you charge for each plan  
- [ ] **Published** is ON  
- [ ] Test on a shop device: **Settings → Subscription** shows QR, link, steps, and claim form  
