import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../sync/sync_conflict_record.dart';

const _kPrefsKeyPrefix = 'pride_sync_conflicts_v1_';

/// Persists sync conflicts per shop (SharedPreferences — IO + Web).
class SyncConflictStorage {
  SyncConflictStorage(this._prefs);

  final SharedPreferences _prefs;

  String _key(String shopId) => '$_kPrefsKeyPrefix$shopId';

  Future<List<SyncConflictRecord>> list(String shopId) async {
    final raw = _prefs.getString(_key(shopId));
    if (raw == null || raw.isEmpty) return const [];
    try {
      final decoded = jsonDecode(raw);
      if (decoded is! List<dynamic>) return const [];
      return decoded
          .whereType<Map<String, dynamic>>()
          .map(SyncConflictRecord.fromJson)
          .where((r) => r.internalId.isNotEmpty)
          .toList()
        ..sort((a, b) => b.detectedAt.compareTo(a.detectedAt));
    } catch (_) {
      return const [];
    }
  }

  Future<void> upsert(String shopId, SyncConflictRecord record) async {
    final rows = await list(shopId);
    final next = [
      record,
      ...rows.where((r) => r.internalId != record.internalId),
    ];
    await _prefs.setString(
      _key(shopId),
      jsonEncode(next.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> remove(String shopId, String internalId) async {
    final rows = await list(shopId);
    final next = rows.where((r) => r.internalId != internalId).toList();
    await _prefs.setString(
      _key(shopId),
      jsonEncode(next.map((r) => r.toJson()).toList()),
    );
  }

  Future<void> clearShop(String shopId) async {
    await _prefs.remove(_key(shopId));
  }
}
