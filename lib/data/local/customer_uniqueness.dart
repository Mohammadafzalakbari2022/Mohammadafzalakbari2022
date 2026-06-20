import '../../core/validation/afghan_phone_input.dart';
import 'customer_repository_exception.dart';
import 'customer_summary.dart';

/// Exact customer name key (trimmed; script-sensitive).
String customerNameKey(String name) => name.trim();

/// Normalized phone digits for uniqueness (empty when no phone).
String customerPhoneKey(String? phone) {
  return normalizeAfghanPhoneDigits(phone?.trim() ?? '');
}

/// First customer whose name exactly matches [name] (after trim).
CustomerSummary? findCustomerByExactName(
  Iterable<CustomerSummary> customers,
  String name, {
  String? excludeInternalId,
}) {
  final key = customerNameKey(name);
  if (key.isEmpty) return null;
  for (final c in customers) {
    if (excludeInternalId != null && c.internalId == excludeInternalId) {
      continue;
    }
    if (customerNameKey(c.name) == key) return c;
  }
  return null;
}

/// First customer with the same normalized phone (when phone is non-empty).
CustomerSummary? findCustomerByPhone(
  Iterable<CustomerSummary> customers,
  String? phone, {
  String? excludeInternalId,
}) {
  final key = customerPhoneKey(phone);
  if (key.isEmpty) return null;
  for (final c in customers) {
    if (excludeInternalId != null && c.internalId == excludeInternalId) {
      continue;
    }
    final existing = customerPhoneKey(c.phone);
    if (existing.isNotEmpty && existing == key) return c;
  }
  return null;
}

/// Ensures [name] and optional [phone] are unique within [shopId].
void assertCustomerUniqueInShop({
  required Iterable<CustomerSummary> customers,
  required String shopId,
  required String name,
  String? phone,
  String? excludeInternalId,
}) {
  final active = customers.where((c) => c.shopId == shopId);
  if (findCustomerByExactName(
        active,
        name,
        excludeInternalId: excludeInternalId,
      ) !=
      null) {
    throw const CustomerRepositoryException('duplicate_name');
  }
  if (findCustomerByPhone(
        active,
        phone,
        excludeInternalId: excludeInternalId,
      ) !=
      null) {
    throw const CustomerRepositoryException('duplicate_phone');
  }
}
