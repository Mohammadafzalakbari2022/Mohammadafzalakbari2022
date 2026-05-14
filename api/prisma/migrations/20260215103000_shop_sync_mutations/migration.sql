-- AlterTable
ALTER TABLE "shops" ADD COLUMN "last_mutation_revision" INTEGER NOT NULL DEFAULT 0;

-- CreateTable
CREATE TABLE "shop_sync_mutations" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "revision" INTEGER NOT NULL,
    "internal_id" TEXT NOT NULL,
    "entity_type" TEXT NOT NULL,
    "operation" TEXT NOT NULL,
    "client_updated_at" TIMESTAMP(3) NOT NULL,
    "payload" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "shop_sync_mutations_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "shop_sync_mutations_shop_id_revision_key" ON "shop_sync_mutations"("shop_id", "revision");

-- CreateIndex
CREATE INDEX "shop_sync_mutations_shop_id_revision_idx" ON "shop_sync_mutations"("shop_id", "revision");

-- AddForeignKey
ALTER TABLE "shop_sync_mutations" ADD CONSTRAINT "shop_sync_mutations_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;
