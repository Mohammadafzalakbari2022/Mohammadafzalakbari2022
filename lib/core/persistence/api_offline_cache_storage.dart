import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

/// Last-fetched API payloads for read-only offline display (`plan-04` / `plan-18`).
abstract final class ApiOfflineCacheStorage {
  static String _shopUsersKey(String shopId) =>
      'pride_cache_shop_users_${shopId.trim()}';

  static const adminShopsKey = 'pride_cache_admin_shops';
  static const adminCodesKey = 'pride_cache_admin_activation_codes';
  static const adminResetsKey = 'pride_cache_admin_password_resets';
  static const adminStatsKey = 'pride_cache_admin_stats';
  static const adminBillingKey = 'pride_cache_admin_billing';

  static List<Map<String, dynamic>> _decodeMapList(dynamic raw) {
    if (raw is! List) return const [];
    final out = <Map<String, dynamic>>[];
    for (final e in raw) {
      if (e is Map<String, dynamic>) out.add(e);
    }
    return out;
  }

  static Future<void> saveShopUsers(
    SharedPreferences prefs,
    String shopId, {
    required List<Map<String, dynamic>> users,
    Map<String, dynamic>? limits,
  }) async {
    final sid = shopId.trim();
    if (sid.isEmpty) return;
    await prefs.setString(
      _shopUsersKey(sid),
      jsonEncode({
        'users': users,
        'limits': limits,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static ({
    List<Map<String, dynamic>> users,
    Map<String, dynamic>? limits,
  })? readShopUsers(SharedPreferences prefs, String shopId) {
    final raw = prefs.getString(_shopUsersKey(shopId.trim()));
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final lim = decoded['limits'];
      return (
        users: _decodeMapList(decoded['users']),
        limits: lim is Map<String, dynamic> ? lim : null,
      );
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdminShops(
    SharedPreferences prefs,
    List<Map<String, dynamic>> shops,
  ) async {
    await prefs.setString(
      adminShopsKey,
      jsonEncode({
        'shops': shops,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static List<Map<String, dynamic>>? readAdminShops(SharedPreferences prefs) {
    final raw = prefs.getString(adminShopsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return _decodeMapList(decoded['shops']);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdminActivationCodes(
    SharedPreferences prefs,
    List<Map<String, dynamic>> rows,
  ) async {
    await prefs.setString(
      adminCodesKey,
      jsonEncode({
        'rows': rows,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static List<Map<String, dynamic>>? readAdminActivationCodes(
    SharedPreferences prefs,
  ) {
    final raw = prefs.getString(adminCodesKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return _decodeMapList(decoded['rows']);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdminPasswordResets(
    SharedPreferences prefs,
    List<Map<String, dynamic>> rows,
  ) async {
    await prefs.setString(
      adminResetsKey,
      jsonEncode({
        'rows': rows,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static List<Map<String, dynamic>>? readAdminPasswordResets(
    SharedPreferences prefs,
  ) {
    final raw = prefs.getString(adminResetsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      return _decodeMapList(decoded['rows']);
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdminStats(
    SharedPreferences prefs,
    Map<String, dynamic> stats,
  ) async {
    await prefs.setString(
      adminStatsKey,
      jsonEncode({
        'stats': stats,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static Map<String, dynamic>? readAdminStats(SharedPreferences prefs) {
    final raw = prefs.getString(adminStatsKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final stats = decoded['stats'];
      return stats is Map<String, dynamic> ? stats : null;
    } catch (_) {
      return null;
    }
  }

  static Future<void> saveAdminBilling(
    SharedPreferences prefs,
    Map<String, dynamic> data,
  ) async {
    await prefs.setString(
      adminBillingKey,
      jsonEncode({
        'data': data,
        'saved_at': DateTime.now().toUtc().toIso8601String(),
      }),
    );
  }

  static Map<String, dynamic>? readAdminBilling(SharedPreferences prefs) {
    final raw = prefs.getString(adminBillingKey);
    if (raw == null || raw.isEmpty) return null;
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! Map<String, dynamic>) return null;
      final data = decoded['data'];
      return data is Map<String, dynamic> ? data : null;
    } catch (_) {
      return null;
    }
  }
}
