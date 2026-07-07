import 'dart:convert';

import 'package:pride_v3/core/persistence/shared_preferences_bootstrap.dart';

const _supportCacheKey = 'pride_license_support_info_v1';
const _supportCacheAtKey = 'pride_license_support_info_at_v1';

Future<void> cacheSupportInfo(Map<String, dynamic> data) async {
  final prefs = await obtainSharedPreferences();
  await prefs.setString(_supportCacheKey, jsonEncode(data));
  await prefs.setInt(
    _supportCacheAtKey,
    DateTime.now().millisecondsSinceEpoch,
  );
}

Future<({Map<String, dynamic>? data, DateTime? fetchedAt})>
    readCachedSupportInfo() async {
  final prefs = await obtainSharedPreferences();
  final raw = prefs.getString(_supportCacheKey);
  final atMs = prefs.getInt(_supportCacheAtKey);
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

