import 'package:flutter/services.dart';

/// Afghan local mobile numbers: up to 10 digits (no country code in the field).
const kAfghanPhoneMaxDigits = 10;

/// Keeps only digits and caps length at [kAfghanPhoneMaxDigits].
class AfghanPhoneInputFormatter extends TextInputFormatter {
  const AfghanPhoneInputFormatter();

  @override
  TextEditingValue formatEditUpdate(
    TextEditingValue oldValue,
    TextEditingValue newValue,
  ) {
    final digits = newValue.text.replaceAll(RegExp(r'\D'), '');
    final clamped = digits.length > kAfghanPhoneMaxDigits
        ? digits.substring(0, kAfghanPhoneMaxDigits)
        : digits;
    if (clamped == newValue.text) return newValue;
    return TextEditingValue(
      text: clamped,
      selection: TextSelection.collapsed(offset: clamped.length),
    );
  }
}

String normalizeAfghanPhoneDigits(String raw) {
  final digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.length <= kAfghanPhoneMaxDigits) return digits;
  return digits.substring(0, kAfghanPhoneMaxDigits);
}
