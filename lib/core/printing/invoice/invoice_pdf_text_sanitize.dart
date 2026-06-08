/// Strips characters that render incorrectly in the PDF engine (isolates, stray combining marks on Latin).
String pdfSanitizeLabel(String input) {
  if (input.isEmpty) return input;

  var text = input
      .replaceAll('\u2066', '')
      .replaceAll('\u2069', '')
      .replaceAll('\u200E', '')
      .replaceAll('\u200F', '');

  // Remove combining marks that appear as "dot above A" artifacts on Latin labels.
  final buffer = StringBuffer();
  for (final rune in text.runes) {
    if (rune >= 0x0300 && rune <= 0x036F) continue;
    buffer.writeCharCode(rune);
  }
  return buffer.toString().trim();
}
