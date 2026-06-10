/// Validation helpers for shape settings forms.
bool isNonEmptyShapeOptionLabel(String label) => label.trim().isNotEmpty;

List<String> normalizeIdList(Iterable<String> ids) {
  return ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toList(growable: false);
}
