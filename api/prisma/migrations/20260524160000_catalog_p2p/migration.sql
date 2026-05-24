-- Catalog sharing metadata + P2P signaling (`plan-14`).

CREATE TABLE "shop_catalog_settings" (
    "shop_id" TEXT NOT NULL,
    "sharing_enabled" BOOLEAN NOT NULL DEFAULT false,
    "updated_at" TIMESTAMP(3) NOT NULL,

    CONSTRAINT "shop_catalog_settings_pkey" PRIMARY KEY ("shop_id")
);

CREATE TABLE "public_catalog_entries" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "internal_id" TEXT NOT NULL,
    "design_name" TEXT NOT NULL,
    "designer_shop_name" TEXT NOT NULL,
    "notes" TEXT,
    "shared_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "unpublished_at" TIMESTAMP(3),

    CONSTRAINT "public_catalog_entries_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "public_catalog_entries_shop_id_internal_id_key" ON "public_catalog_entries"("shop_id", "internal_id");
CREATE INDEX "public_catalog_entries_shared_at_idx" ON "public_catalog_entries"("shared_at");

CREATE TABLE "p2p_signal_messages" (
    "id" TEXT NOT NULL,
    "to_shop_id" TEXT NOT NULL,
    "from_shop_id" TEXT NOT NULL,
    "session_id" TEXT NOT NULL,
    "payload_type" TEXT NOT NULL,
    "payload" JSONB NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "consumed_at" TIMESTAMP(3),

    CONSTRAINT "p2p_signal_messages_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "p2p_signal_messages_to_shop_id_consumed_at_idx" ON "p2p_signal_messages"("to_shop_id", "consumed_at");
CREATE INDEX "p2p_signal_messages_session_id_idx" ON "p2p_signal_messages"("session_id");

ALTER TABLE "shop_catalog_settings" ADD CONSTRAINT "shop_catalog_settings_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;
ALTER TABLE "public_catalog_entries" ADD CONSTRAINT "public_catalog_entries_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;
