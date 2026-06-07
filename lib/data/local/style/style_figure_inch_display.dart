/// Formats a positive inch value for user-visible labels (e.g. 5.5 → "5.5 inch").
String formatInchValueLabel(double valueInches) {
  if (valueInches <= 0) return '';
  final text = valueInches == valueInches.roundToDouble()
      ? '${valueInches.toInt()}'
      : _trimTrailingZeros(valueInches);
  return '$text inch';
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

/// Pure numeric input keeps [valueInches] for sync; tailor text stores [label] only.
InchMeasurementStorage parseInchMeasurementForStorage(String text) {
  final trimmed = text.trim();
  final numeric = double.tryParse(trimmed);
  if (numeric != null && numeric > 0) {
    return InchMeasurementStorage(
      label: formatInchValueLabel(numeric),
      valueInches: numeric,
    );
  }
  return InchMeasurementStorage(label: trimmed, valueInches: 0);
}

/// Shows the saved measurement text; falls back to formatted [valueInches] for legacy rows.
String displayInchOptionLabel({
  required double valueInches,
  required String label,
}) {
  final trimmed = label.trim();
  if (trimmed.isNotEmpty) return trimmed;
  if (valueInches > 0) return formatInchValueLabel(valueInches);
  return '';
}
