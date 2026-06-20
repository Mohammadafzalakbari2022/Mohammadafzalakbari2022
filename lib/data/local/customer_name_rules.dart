/// Shared customer-name rules (composer, repositories, print).
bool isValidCustomerName(String? name) {
  final trimmed = name?.trim() ?? '';
  return trimmed.length >= 2;
}

void assertValidCustomerName(String name) {
  if (!isValidCustomerName(name)) {
    throw ArgumentError.value(name, 'name', 'Customer name is required');
  }
}
