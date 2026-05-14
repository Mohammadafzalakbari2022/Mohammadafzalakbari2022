/// ESC/POS [Generator] encodes non-Chinese text as Latin-1. Replace other runes
/// so Persian/Dari names do not throw at encode time (may appear as `?`).
String receiptLatin1Safe(String input) {
  final buffer = StringBuffer();
  for (final r in input.runes) {
    if (r <= 0xff) {
      buffer.writeCharCode(r);
    } else {
      buffer.writeCharCode(0x3f);
    }
  }
  return buffer.toString();
}
