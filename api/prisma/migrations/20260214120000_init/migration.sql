-- CreateTable
CREATE TABLE "shops" (
    "id" TEXT NOT NULL,
    "name" TEXT NOT NULL,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "shops_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shop_users" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "username" TEXT NOT NULL,
    "password_hash" VARCHAR(64) NOT NULL,
    "is_shop_owner" BOOLEAN NOT NULL,
    "deleted_at" TIMESTAMP(3),

    CONSTRAINT "shop_users_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "shop_licenses" (
    "shop_id" TEXT NOT NULL,
    "status" TEXT NOT NULL,
    "expires_at" TIMESTAMP(3) NOT NULL,
    "trial_started_at" TIMESTAMP(3),

    CONSTRAINT "shop_licenses_pkey" PRIMARY KEY ("shop_id")
);

-- CreateIndex
CREATE INDEX "shop_users_shop_id_username_idx" ON "shop_users"("shop_id", "username");

-- AddForeignKey
ALTER TABLE "shop_users" ADD CONSTRAINT "shop_users_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;

-- AddForeignKey
ALTER TABLE "shop_licenses" ADD CONSTRAINT "shop_licenses_shop_id_fkey" FOREIGN KEY ("shop_id") REFERENCES "shops"("id") ON DELETE CASCADE ON UPDATE CASCADE;
