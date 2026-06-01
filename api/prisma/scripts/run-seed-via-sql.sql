-- Manual bootstrap matching api/.env PRIDE_AUTH_SEED and PRIDE_OPERATOR_SEED
-- (SHA-256 hex passwords, same as AppSeedService)

INSERT INTO shops (id, name, created_at, last_mutation_revision, max_users)
VALUES ('dev', 'dev', NOW(), 0, 5)
ON CONFLICT (id) DO UPDATE SET name = EXCLUDED.name;

INSERT INTO shop_users (id, shop_id, username, password_hash, is_shop_owner, deleted_at)
SELECT
  gen_random_uuid()::text,
  'dev',
  'owner',
  encode(digest('changeme', 'sha256'), 'hex'),
  true,
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM shop_users WHERE shop_id = 'dev' AND username = 'owner' AND deleted_at IS NULL
);

INSERT INTO shop_licenses (shop_id, status, expires_at, trial_started_at)
VALUES ('dev', 'trial_active', NOW() + INTERVAL '15 days', NOW())
ON CONFLICT (shop_id) DO NOTHING;

INSERT INTO shop_users (id, shop_id, username, password_hash, is_shop_owner, deleted_at)
SELECT
  gen_random_uuid()::text,
  'dev',
  'Akbari',
  encode(digest('Princekhan@2026', 'sha256'), 'hex'),
  false,
  NULL
WHERE NOT EXISTS (
  SELECT 1 FROM shop_users WHERE shop_id = 'dev' AND username = 'Akbari' AND deleted_at IS NULL
);

INSERT INTO subscription_billing_config (
  id, payment_steps, activation_delivery_steps, cash_payment_note, is_published, updated_at
)
VALUES ('default', '{}'::jsonb, '{}'::jsonb, '{}'::jsonb, false, NOW())
ON CONFLICT (id) DO NOTHING;
