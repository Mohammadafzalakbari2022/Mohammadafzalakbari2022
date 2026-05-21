/// Maps Eastern Arabic / Persian digits to Western (0–9) for parsing and display.
String normalizeWesternDigits(String input) {
  if (input.isEmpty) return input;
  final buffer = StringBuffer();
  for (final code in input.runes) {
    final ch = String.fromCharCode(code);
    if (ch == '۰' || ch == '٠') {
      buffer.write('0');
    } else if (ch == '۱' || ch == '١') {
      buffer.write('1');
    } else if (ch == '۲' || ch == '٢') {
      buffer.write('2');
    } else if (ch == '۳' || ch == '٣') {
      buffer.write('3');
    } else if (ch == '۴' || ch == '٤') {
      buffer.write('4');
    } else if (ch == '۵' || ch == '٥') {
      buffer.write('5');
    } else if (ch == '۶' || ch == '٦') {
      buffer.write('6');
    } else if (ch == '۷' || ch == '٧') {
      buffer.write('7');
    } else if (ch == '۸' || ch == '٨') {
      buffer.write('8');
    } else if (ch == '۹' || ch == '٩') {
      buffer.write('9');
    } else {
      buffer.write(ch);
    }
  }
  return buffer.toString();
}

/// Parses money entered with Western, Persian, or Arabic-Indic digits.
int? tryParseMoneyAmount(String? raw) {
  if (raw == null) return null;
  final normalized = normalizeWesternDigits(raw.trim());
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}

/// Parses signed money (Western / Persian / Arabic-Indic digits, optional leading `-`).
int? tryParseSignedMoneyAmount(String? raw) {
  if (raw == null) return null;
  final normalized = normalizeWesternDigits(raw.trim());
  if (normalized.isEmpty) return null;
  return int.tryParse(normalized);
}
