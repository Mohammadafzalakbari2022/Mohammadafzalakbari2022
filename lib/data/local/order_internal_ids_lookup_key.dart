/// Stable Riverpod family key for batch order lookups.
///
/// [List] uses identity equality — never use a raw list as a provider family
/// parameter when it is recreated each build.
String orderInternalIdsLookupKey(Iterable<String> internalIds) {
  final sorted = internalIds
      .map((id) => id.trim())
      .where((id) => id.isNotEmpty)
      .toSet()
      .toList()
    ..sort();
  if (sorted.isEmpty) return '';
  return sorted.join('\x1e');
}

List<String> orderInternalIdsFromLookupKey(String lookupKey) {
  if (lookupKey.isEmpty) return const [];
  return lookupKey.split('\x1e');
}
