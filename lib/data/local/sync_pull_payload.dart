/// Shared parsing for `GET /sync/pull` `data` blobs (snake_case from API; camelCase tolerated).
Map<String, dynamic> syncPullDataMap(Object? data) {
  if (data == null) return const {};
  if (data is Map<String, dynamic>) return data;
  if (data is Map) return Map<String, dynamic>.from(data);
  return const {};
}

String? syncPullString(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    final v = m[k];
    if (v == null) continue;
    if (v is String) {
      final t = v.trim();
      if (t.isEmpty) continue;
      return t;
    }
    final s = v.toString().trim();
    if (s.isEmpty) continue;
    return s;
  }
  return null;
}

int? syncPullInt(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    final v = m[k];
    if (v == null) continue;
    if (v is int) return v;
    if (v is num) return v.toInt();
    if (v is String) return int.tryParse(v.trim());
  }
  return null;
}

bool? syncPullBool(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    final v = m[k];
    if (v == null) continue;
    if (v is bool) return v;
    if (v is String) {
      final s = v.trim().toLowerCase();
      if (s == 'true' || s == '1') return true;
      if (s == 'false' || s == '0') return false;
    }
    if (v is num) return v != 0;
  }
  return null;
}

DateTime? syncPullDateTime(Map<String, dynamic> m, List<String> keys) {
  for (final k in keys) {
    final v = m[k];
    if (v is String && v.isNotEmpty) {
      final d = DateTime.tryParse(v);
      if (d != null) return d;
    }
  }
  return null;
}
