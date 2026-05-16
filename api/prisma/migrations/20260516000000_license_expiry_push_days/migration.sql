-- Dedup table for daily license-expiry FCM reminders (`plan-22`).
CREATE TABLE "license_expiry_push_days" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "day_utc" VARCHAR(10) NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "license_expiry_push_days_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "license_expiry_push_days_shop_id_day_utc_key" ON "license_expiry_push_days"("shop_id", "day_utc");

CREATE INDEX "license_expiry_push_days_shop_id_idx" ON "license_expiry_push_days"("shop_id");

ALTER TABLE "license_expiry_push_days" ADD CONSTRAINT "license_expiry_push_days_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;
