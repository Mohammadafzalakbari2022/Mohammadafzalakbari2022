/// Validation helpers for shape settings forms.
bool isNonEmptyShapeOptionLabel(String label) => label.trim().isNotEmpty;

bool isPositiveInchesValue(String text) {
  final value = double.tryParse(text.trim());
  return value != null && value > 0;
}

bool isNonEmptyPresetName(String name) => name.trim().isNotEmpty;

List<String> normalizeIdList(Iterable<String> ids) {
  return ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toList(growable: false);
}
