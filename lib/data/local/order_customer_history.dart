import 'dart:convert';

/// One customer name/phone change recorded on an order.
class OrderCustomerHistoryEntry {
  const OrderCustomerHistoryEntry({
    required this.fromName,
    this.fromPhone,
    required this.toName,
    this.toPhone,
    required this.changedAt,
  });

  final String fromName;
  final String? fromPhone;
  final String toName;
  final String? toPhone;
  final DateTime changedAt;

  Map<String, dynamic> toJson() => {
        'from_name': fromName,
        if (fromPhone != null && fromPhone!.trim().isNotEmpty)
          'from_phone': fromPhone!.trim(),
        'to_name': toName,
        if (toPhone != null && toPhone!.trim().isNotEmpty)
          'to_phone': toPhone!.trim(),
        'changed_at': changedAt.toUtc().toIso8601String(),
      };

  static OrderCustomerHistoryEntry? fromJsonMap(Map<String, dynamic> m) {
    final fromName = (m['from_name'] as String? ?? '').trim();
    final toName = (m['to_name'] as String? ?? '').trim();
    if (fromName.isEmpty || toName.isEmpty) return null;
    final changedRaw = m['changed_at'] as String?;
    final changedAt = changedRaw != null
        ? DateTime.tryParse(changedRaw)
        : null;
    if (changedAt == null) return null;
    return OrderCustomerHistoryEntry(
      fromName: fromName,
      fromPhone: (m['from_phone'] as String?)?.trim(),
      toName: toName,
      toPhone: (m['to_phone'] as String?)?.trim(),
      changedAt: changedAt,
    );
  }
}

List<OrderCustomerHistoryEntry> parseOrderCustomerHistoryJson(String? json) {
  if (json == null || json.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return const [];
    final out = <OrderCustomerHistoryEntry>[];
    for (final item in decoded) {
      if (item is Map<String, dynamic>) {
        final e = OrderCustomerHistoryEntry.fromJsonMap(item);
        if (e != null) out.add(e);
      } else if (item is Map) {
        final e = OrderCustomerHistoryEntry.fromJsonMap(
          Map<String, dynamic>.from(item),
        );
        if (e != null) out.add(e);
      }
    }
    return out;
  } catch (_) {
    return const [];
  }
}

String encodeOrderCustomerHistory(List<OrderCustomerHistoryEntry> entries) {
  if (entries.isEmpty) return '';
  return jsonEncode(entries.map((e) => e.toJson()).toList());
}

List<OrderCustomerHistoryEntry> appendOrderCustomerHistory({
  required List<OrderCustomerHistoryEntry> existing,
  required String fromName,
  String? fromPhone,
  required String toName,
  String? toPhone,
  required DateTime changedAt,
}) {
  final prevName = fromName.trim();
  final nextName = toName.trim();
  final prevPhone = fromPhone?.trim() ?? '';
  final nextPhone = toPhone?.trim() ?? '';
  if (prevName == nextName && prevPhone == nextPhone) return existing;
  return [
    ...existing,
    OrderCustomerHistoryEntry(
      fromName: prevName,
      fromPhone: prevPhone.isEmpty ? null : prevPhone,
      toName: nextName,
      toPhone: nextPhone.isEmpty ? null : nextPhone,
      changedAt: changedAt,
    ),
  ];
}
