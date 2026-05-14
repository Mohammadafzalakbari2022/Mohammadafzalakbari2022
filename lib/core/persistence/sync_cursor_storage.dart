import 'package:shared_preferences/shared_preferences.dart';

/// Stores last successful `GET /sync/pull` `next_cursor` per shop (`plan-03`).
abstract final class SyncCursorStorage {
  static String _key(String shopId) => 'pride_sync_pull_cursor_$shopId';

  static String? read(SharedPreferences prefs, String shopId) {
    final v = prefs.getString(_key(shopId));
    if (v == null || v.isEmpty) return null;
    return v;
  }

  static Future<void> write(
    SharedPreferences prefs,
    String shopId,
    String cursor,
  ) async {
    await prefs.setString(_key(shopId), cursor);
  }

  static Future<void> clearForShop(
    SharedPreferences prefs,
    String shopId,
  ) async {
    await prefs.remove(_key(shopId));
  }
}
