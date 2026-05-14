/// Single dev shop until auth + multi-shop exist (plan-02).
const String kDevShopId = '00000000-0000-4000-8000-000000000001';

/// API session shop id when present; otherwise [kDevShopId] (local seed / offline).
String effectiveShopIdFromAuth(String? authShopId) {
  final s = authShopId?.trim();
  if (s != null && s.isNotEmpty) return s;
  return kDevShopId;
}

/// Fake peer shop for local “community catalog” seed (plan-14; replaces placeholder directory).
const String kDevCommunityCatalogShopId =
    '00000000-0000-4000-8000-000000000099';
