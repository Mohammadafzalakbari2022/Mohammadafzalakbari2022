/// Parses `server_updated_at` from a `GET /sync/pull` change row (Nest `SyncChangeRow`).
DateTime? parseSyncChangeServerUpdatedAt(Map<String, dynamic> raw) {
  final v = raw['server_updated_at'];
  if (v is! String || v.isEmpty) return null;
  return DateTime.tryParse(v);
}
