-- Subscription billing: single settings image (replaces structured copy in the app UI).
ALTER TABLE "subscription_billing_config"
ADD COLUMN IF NOT EXISTS "settings_image" BYTEA,
ADD COLUMN IF NOT EXISTS "settings_image_mime_type" TEXT;
