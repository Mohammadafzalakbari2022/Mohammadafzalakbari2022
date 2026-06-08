import 'customer_summary.dart';

/// Parses stored customer number; returns 0 when missing or invalid.
int parseStoredDisplayCustomerNo(String stored) {
  final n = int.tryParse(stored.trim());
  if (n == null || n <= 0) return 0;
  return n;
}

/// Canonical 8-digit storage string for sync/backup.
String formatStoredDisplayCustomerNo(int n) {
  if (n <= 0) return '';
  return n.toString().padLeft(8, '0');
}

/// Next shop-scoped customer number (max existing + 1).
int nextDisplayCustomerNoFromSummaries(
  Iterable<CustomerSummary> customers,
  String shopId,
) {
  var max = 0;
  for (final c in customers) {
    if (c.shopId != shopId) continue;
    final n = parseStoredDisplayCustomerNo(c.displayCustomerNo);
    if (n > max) max = n;
  }
  return max + 1;
}

/// Whether [query] digits match stored or formatted customer number.
bool customerDisplayNoMatchesQuery(String displayCustomerNo, String query) {
  final q = query.trim();
  if (q.isEmpty) return false;
  final qDigits = q.replaceAll(RegExp(r'\D'), '');
  if (qDigits.isEmpty) return false;

  final stored = displayCustomerNo.trim();
  if (stored.isEmpty) return false;

  final storedDigits = stored.replaceAll(RegExp(r'\D'), '');
  if (storedDigits.contains(qDigits)) return true;

  final n = parseStoredDisplayCustomerNo(stored);
  if (n <= 0) return false;
  final formatted = n > 99999 ? n.toString() : n.toString().padLeft(5, '0');
  return formatted.contains(qDigits);
}

/// Sync outbox / pull payload fragment for stable customer display number.
Map<String, dynamic> customerUpsertPayloadExtras({
  required String displayCustomerNo,
}) {
  if (parseStoredDisplayCustomerNo(displayCustomerNo) <= 0) {
    return const {};
  }
  return {'display_customer_no': displayCustomerNo.trim()};
}
