-- Full data wipe: removes all rows, keeps tables and migrations.
-- Re-seed by restarting the API (PRIDE_AUTH_SEED / PRIDE_OPERATOR_SEED on boot).

TRUNCATE TABLE
  "subscription_payment_claims",
  "activation_codes",
  "admin_audit_logs",
  "password_reset_requests",
  "shop_push_tokens",
  "p2p_signal_messages",
  "public_catalog_entries",
  "shop_catalog_settings",
  "license_expiry_push_days",
  "shop_sync_mutations",
  "shop_users",
  "shop_licenses",
  "shops",
  "subscription_billing_config",
  "app_support_config"
RESTART IDENTITY CASCADE;
