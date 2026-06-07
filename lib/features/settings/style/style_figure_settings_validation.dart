/// Validation helpers for shape settings forms.
bool isNonEmptyShapeOptionLabel(String label) => label.trim().isNotEmpty;

/// Allowed chars: digits, spaces, `/`, `.`, `x`, `×`, common fraction glyphs, and letters (e.g. inch).
final _inchMeasurementPattern = RegExp(
  r"^[\d\s\./×x"
  r"½¼¾⅓⅔⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞"
  r"a-zA-Z\-']+$",
);

bool isValidInchMeasurementText(String text) {
  final trimmed = text.trim();
  if (trimmed.isEmpty) return false;
  if (!RegExp(r'\d').hasMatch(trimmed)) return false;
  return _inchMeasurementPattern.hasMatch(trimmed);
}

List<String> normalizeIdList(Iterable<String> ids) {
  return ids.map((e) => e.trim()).where((e) => e.isNotEmpty).toList(growable: false);
}
