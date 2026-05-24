import 'dart:convert';

import '../../data/local/sync_pull_payload.dart';

/// Builds a compact JSON snapshot for conflict UI.
Map<String, dynamic> orderConflictSnapshotFromPullData(
  Map<String, dynamic> data, {
  String? displayOrderNo,
  String? customerName,
  DateTime? updatedAt,
}) {
  return {
    'display_order_no': displayOrderNo ??
        syncPullString(data, const ['display_order_no', 'displayOrderNo']),
    'customer_snapshot_name': customerName ??
        syncPullString(data, const [
          'customer_snapshot_name',
          'customerSnapshotName',
        ]),
    'status_index':
        syncPullInt(data, const ['status_index', 'statusIndex']),
    'total_amount_minor': syncPullInt(
      data,
      const ['total_amount_minor', 'totalAmountMinor'],
    ),
    'delivery_date': syncPullString(data, const [
      'delivery_date',
      'deliveryDate',
    ]),
    'internal_notes':
        syncPullString(data, const ['internal_notes', 'internalNotes']),
    'updated_at': updatedAt?.toUtc().toIso8601String(),
  };
}

String formatConflictSnapshotForDisplay(String jsonRaw) {
  try {
    final m = jsonDecode(jsonRaw);
    if (m is! Map<String, dynamic>) return jsonRaw;
    final parts = <String>[];
    final orderNo = m['display_order_no'];
    if (orderNo != null) parts.add('#$orderNo');
    final name = m['customer_snapshot_name'];
    if (name != null && '$name'.trim().isNotEmpty) parts.add('$name');
    final status = m['status_index'];
    if (status != null) parts.add('status=$status');
    final total = m['total_amount_minor'];
    if (total != null) parts.add('total=$total');
    if (parts.isEmpty) return jsonRaw;
    return parts.join(' · ');
  } catch (_) {
    return jsonRaw;
  }
}
