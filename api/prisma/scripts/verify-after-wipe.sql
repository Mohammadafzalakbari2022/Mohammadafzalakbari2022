SELECT 'shops' AS entity, COUNT(*)::text AS n FROM shops
UNION ALL SELECT 'shop_users', COUNT(*)::text FROM shop_users WHERE deleted_at IS NULL
UNION ALL SELECT 'activation_codes', COUNT(*)::text FROM activation_codes;
