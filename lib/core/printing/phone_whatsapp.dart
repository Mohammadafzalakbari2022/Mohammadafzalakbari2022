/// Normalizes a phone string for WhatsApp (`wa.me` / Android `jid`).
///
/// Best-effort for Afghan numbers (`07…` → `93…`).
String? normalizePhoneForWhatsApp(String raw) {
  var digits = raw.replaceAll(RegExp(r'\D'), '');
  if (digits.isEmpty) return null;

  if (digits.startsWith('00')) {
    digits = digits.substring(2);
  }

  if (digits.startsWith('0') && digits.length >= 9) {
    digits = '93${digits.substring(1)}';
  } else if (digits.length == 9 && !digits.startsWith('93')) {
    digits = '93$digits';
  }

  return digits.isEmpty ? null : digits;
}
