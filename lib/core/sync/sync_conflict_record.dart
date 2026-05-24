import 'dart:convert';

/// One detected sync divergence for owner review (`plan-03`).
class SyncConflictRecord {
  const SyncConflictRecord({
    required this.conflictId,
    required this.shopId,
    required this.entityType,
    required this.internalId,
    required this.direction,
    required this.localSnapshotJson,
    required this.remoteSnapshotJson,
    required this.detectedAt,
    this.displayLabel,
  });

  final String conflictId;
  final String shopId;
  final String entityType;
  final String internalId;
  /// `pull_skipped` or `push_rejected`.
  final String direction;
  final String localSnapshotJson;
  final String remoteSnapshotJson;
  final DateTime detectedAt;
  final String? displayLabel;

  Map<String, dynamic> toJson() => {
        'conflictId': conflictId,
        'shopId': shopId,
        'entityType': entityType,
        'internalId': internalId,
        'direction': direction,
        'localSnapshotJson': localSnapshotJson,
        'remoteSnapshotJson': remoteSnapshotJson,
        'detectedAt': detectedAt.toUtc().toIso8601String(),
        'displayLabel': displayLabel,
      };

  static SyncConflictRecord fromJson(Map<String, dynamic> m) {
    return SyncConflictRecord(
      conflictId: m['conflictId'] as String? ?? '',
      shopId: m['shopId'] as String? ?? '',
      entityType: m['entityType'] as String? ?? 'order',
      internalId: m['internalId'] as String? ?? '',
      direction: m['direction'] as String? ?? 'pull_skipped',
      localSnapshotJson: m['localSnapshotJson'] as String? ?? '{}',
      remoteSnapshotJson: m['remoteSnapshotJson'] as String? ?? '{}',
      detectedAt: DateTime.tryParse(m['detectedAt'] as String? ?? '') ??
          DateTime.now(),
      displayLabel: m['displayLabel'] as String?,
    );
  }
}

String encodeSyncConflictSnapshot(Map<String, dynamic> data) =>
    jsonEncode(data);

Map<String, dynamic> decodeSyncConflictSnapshot(String raw) {
  try {
    final d = jsonDecode(raw);
    return d is Map<String, dynamic> ? d : <String, dynamic>{};
  } catch (_) {
    return <String, dynamic>{};
  }
}
