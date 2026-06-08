import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';

/// Filters [customers] by [query] using the same rules as the Customers tab
/// and Orders list customer search: trim, case-insensitive name/phone match,
/// preserving source order (no re-sort).
List<CustomerSummary> filterCustomersBySearchQuery(
  List<CustomerSummary> customers,
  String query,
) {
  final q = query.trim().toLowerCase();
  if (q.isEmpty) return List<CustomerSummary>.of(customers);

  final qDigits = q.replaceAll(RegExp(r'\D'), '');

  return customers.where((c) {
    if (c.name.toLowerCase().contains(q)) return true;
    final phone = (c.phone ?? '').toLowerCase();
    if (phone.contains(q)) return true;
    if (qDigits.isNotEmpty) {
      final phoneDigits = phone.replaceAll(RegExp(r'\D'), '');
      if (phoneDigits.contains(qDigits)) return true;
      if (customerDisplayNoMatchesQuery(c.displayCustomerNo, q)) return true;
    }
    return false;
  }).toList();
}

/// Returns the first customer matching [query], or null when [query] is empty
/// or no customer matches.
CustomerSummary? findFirstCustomerBySearchQuery(
  List<CustomerSummary> customers,
  String query,
) {
  if (query.trim().isEmpty) return null;
  final matches = filterCustomersBySearchQuery(customers, query);
  if (matches.isEmpty) return null;
  return matches.first;
}
