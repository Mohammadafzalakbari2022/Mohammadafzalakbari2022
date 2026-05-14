-- Activation codes (developer-created) + admin audit trail (`plan-18`).

CREATE TABLE "activation_codes" (
    "id" TEXT NOT NULL,
    "code" TEXT NOT NULL,
    "status" TEXT NOT NULL DEFAULT 'active',
    "max_uses" INTEGER NOT NULL DEFAULT 1,
    "uses_count" INTEGER NOT NULL DEFAULT 0,
    "plan_days" INTEGER NOT NULL DEFAULT 365,
    "expires_at" TIMESTAMP(3),
    "assigned_shop_id" TEXT,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "redeemed_at" TIMESTAMP(3),
    "last_redeemed_shop_id" TEXT,

    CONSTRAINT "activation_codes_pkey" PRIMARY KEY ("id")
);

CREATE UNIQUE INDEX "activation_codes_code_key" ON "activation_codes"("code");

CREATE TABLE "admin_audit_logs" (
    "id" TEXT NOT NULL,
    "developer_sub" TEXT NOT NULL,
    "action" TEXT NOT NULL,
    "payload" JSONB,
    "created_at" TIMESTAMP(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "admin_audit_logs_pkey" PRIMARY KEY ("id")
);

CREATE INDEX "admin_audit_logs_created_at_idx" ON "admin_audit_logs"("created_at");
