import 'dart:math';

/// Six-digit fabric ID for customer-supplied cloth (000000–999999).
String generateFabricId([Random? random]) {
  final r = random ?? Random();
  return r.nextInt(1000000).toString().padLeft(6, '0');
}
