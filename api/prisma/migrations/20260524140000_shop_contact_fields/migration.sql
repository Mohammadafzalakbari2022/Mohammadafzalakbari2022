-- Developer/support contact captured at shop registration (`plan-05` / `plan-18`).
ALTER TABLE "shops"
  ADD COLUMN "contact_whatsapp" TEXT,
  ADD COLUMN "contact_email" TEXT,
  ADD COLUMN "contact_address" TEXT;
