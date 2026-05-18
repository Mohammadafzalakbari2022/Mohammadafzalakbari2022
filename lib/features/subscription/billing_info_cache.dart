import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

const _billingCacheKey = 'pride_license_billing_info_v1';
const _billingCacheAtKey = 'pride_license_billing_info_at_v1';

Future<void> cacheBillingInfo(Map<String, dynamic> data) async {
  final prefs = await SharedPreferences.getInstance();
  await prefs.setString(_billingCacheKey, jsonEncode(data));
  await prefs.setInt(
    _billingCacheAtKey,
    DateTime.now().millisecondsSinceEpoch,
  );
}

Future<({Map<String, dynamic>? data, DateTime? fetchedAt})>
    readCachedBillingInfo() async {
  final prefs = await SharedPreferences.getInstance();
  final raw = prefs.getString(_billingCacheKey);
  final atMs = prefs.getInt(_billingCacheAtKey);
  if (raw == null) return (data: null, fetchedAt: null);
  try {
    final decoded = jsonDecode(raw);
    if (decoded is Map<String, dynamic>) {
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
