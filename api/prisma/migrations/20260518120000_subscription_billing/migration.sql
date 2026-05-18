-- CreateTable
CREATE TABLE "subscription_billing_config" (
    "id" TEXT NOT NULL,
    "hesab_pay_account_name" TEXT,
    "hesab_pay_account_number" TEXT,
    "hesab_pay_merchant_id" TEXT,
    "price_1_year_afn" INTEGER,
    "price_2_year_afn" INTEGER,
    "price_lifetime_afn" INTEGER,
    "payment_steps" JSONB NOT NULL DEFAULT '{}',
    "activation_delivery_steps" JSONB NOT NULL DEFAULT '{}',
    "cash_payment_note" JSONB NOT NULL DEFAULT '{}',
    "whatsapp_e164" TEXT,
    "telegram_handle" TEXT,
    "direct_phone_e164" TEXT,
    "is_published" BOOLEAN NOT NULL DEFAULT false,
    "updated_at" TIMESTAMP(3) NOT NULL,
    "updated_by_developer_sub" TEXT,

    CONSTRAINT "subscription_billing_config_pkey" PRIMARY KEY ("id")
);

-- CreateTable
CREATE TABLE "subscription_payment_claims" (
    "id" TEXT NOT NULL,
    "shop_id" TEXT NOT NULL,
    "submitted_by_user_id" TEXT NOT NULL,
    "plan_tier" TEXT NOT NULL,
    "amount_afn" INTEGER NOT NULL,
    "transaction_id" TEXT NOT NULL,
    "payer_phone" TEXT,
    "notes" TEXT,
    "status" TEXT NOT NULL DEFAULT 'pending',
    "reviewed_at" TIMESTAMP(3),
    "reviewed_by_developer_sub" TEXT,
    "review_notes" TEXT,
    "linked_activation_code_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "subscription_payment_claims_pkey" PRIMARY KEY ("id")
);

-- CreateIndex
CREATE UNIQUE INDEX "subscription_payment_claims_transaction_id_key" ON "subscription_payment_claims"("transaction_id");

-- CreateIndex
CREATE INDEX "subscription_payment_claims_status_created_at_idx" ON "subscription_payment_claims"("status", "created_at");

-- CreateIndex
CREATE INDEX "subscription_payment_claims_shop_id_created_at_idx" ON "subscription_payment_claims"("shop_id", "created_at");

-- AddForeignKey
ALTER TABLE "subscription_payment_claims" ADD CONSTRAINT "subscription_payment_claims_linked_activation_code_id_fkey" FOREIGN KEY ("linked_activation_code_id") REFERENCES "activation_codes"("id") ON DELETE SET NULL ON UPDATE CASCADE;

-- Seed default billing config row
INSERT INTO "subscription_billing_config" ("id", "payment_steps", "activation_delivery_steps", "cash_payment_note", "is_published", "updated_at")
VALUES ('default', '{}', '{}', '{}', false, CURRENT_TIMESTAMP)
ON CONFLICT ("id") DO NOTHING;
