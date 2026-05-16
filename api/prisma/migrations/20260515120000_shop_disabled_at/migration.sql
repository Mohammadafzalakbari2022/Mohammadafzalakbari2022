-- Shop-level disable for admin abuse handling (`plan-05` / `plan-18`).
ALTER TABLE "shops" ADD COLUMN IF NOT EXISTS "disabled_at" TIMESTAMP(3);
