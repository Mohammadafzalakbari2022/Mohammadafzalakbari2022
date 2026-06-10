/// Legacy numeric fallback for rows saved before label was authoritative.
String _legacyNumericInchLabel(double valueInches) {
  if (valueInches <= 0) return '';
  if (valueInches == valueInches.roundToDouble()) {
    return '${valueInches.toInt()}';
  }
  return _trimTrailingZeros(valueInches);
}

String _trimTrailingZeros(double value) {
  final fixed = value.toStringAsFixed(2);
  return fixed
      .replaceFirst(RegExp(r'\.?0+$'), '')
      .replaceFirst(RegExp(r'\.$'), '');
}

/// Parsed inch input ready for catalog persistence.
class InchMeasurementStorage {
  const InchMeasurementStorage({
    required this.label,
    required this.valueInches,
  });

  final String label;
  final double valueInches;
}

/// Stores [text] exactly in [label]; optional [valueInches] when purely numeric (sync only).
InchMeasurementStorage parseInchMeasurementForStorage(String text) {
  final trimmed = text.trim();
  final numeric = double.tryParse(trimmed);
  final valueInches =
      numeric != null && numeric > 0 ? numeric : 0.0;
  return InchMeasurementStorage(label: trimmed, valueInches: valueInches);
}

/// Shows the saved label text exactly; legacy rows without label use numeric string only.
String displayInchOptionLabel({
  required double valueInches,
  required String label,
}) {
  final trimmed = label.trim();
  if (trimmed.isNotEmpty) return trimmed;
  return _legacyNumericInchLabel(valueInches);
}
