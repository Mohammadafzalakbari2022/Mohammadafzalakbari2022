-- Hesab Pay payment link + localized button label (QR generated in app from URL).
ALTER TABLE "subscription_billing_config"
ADD COLUMN IF NOT EXISTS "hesab_pay_payment_link" TEXT,
ADD COLUMN IF NOT EXISTS "hesab_pay_payment_link_label" JSONB NOT NULL DEFAULT '{}';
