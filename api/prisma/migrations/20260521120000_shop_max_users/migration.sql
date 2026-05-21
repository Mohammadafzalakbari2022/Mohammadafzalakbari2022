-- Per-shop paid user seat cap (default 5; trial uses fixed limit in app logic).
ALTER TABLE "shops" ADD COLUMN "max_users" INTEGER NOT NULL DEFAULT 5;
