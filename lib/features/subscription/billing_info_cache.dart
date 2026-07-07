import 'dart:convert';

import 'package:pride_v3/core/persistence/shared_preferences_bootstrap.dart';

const _billingCacheKey = 'pride_license_billing_info_v1';
const _billingCacheAtKey = 'pride_license_billing_info_at_v1';

Future<void> cacheBillingInfo(Map<String, dynamic> data) async {
  final prefs = await obtainSharedPreferences();
  await prefs.setString(_billingCacheKey, jsonEncode(data));
  await prefs.setInt(
    _billingCacheAtKey,
    DateTime.now().millisecondsSinceEpoch,
  );
}

Future<({Map<String, dynamic>? data, DateTime? fetchedAt})>
    readCachedBillingInfo() async {
  final prefs = await obtainSharedPreferences();
  final raw = prefs.getString(_billingCacheKey);
  final atMs = prefs.getInt(_billingCacheAtKey);
  if (raw == null) return (data: null, fetchedAt: null);
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
      final schema = decoded['schema_version'];
      if (schema is int && schema < 2) {
        return (data: null, fetchedAt: null);
      }
      if (schema is String && (int.tryParse(schema) ?? 0) < 2) {
        return (data: null, fetchedAt: null);
      }
      return (
        data: decoded,
        fetchedAt: atMs != null
            ? DateTime.fromMillisecondsSinceEpoch(atMs)
            : null,
      );
    }
  } catch (_) {}
  return (data: null, fetchedAt: null);
}
