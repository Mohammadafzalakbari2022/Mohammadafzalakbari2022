/// Wrap plain text for thermal receipt columns (monospace-ish; conservative).
List<String> wrapReceiptLines(String input, int maxChars) {
  if (maxChars < 8) return [input];
  final out = <String>[];
  for (final segment in input.split('\n')) {
    var line = segment;
    while (line.isNotEmpty) {
      if (line.length <= maxChars) {
        out.add(line);
        break;
      }
      var cut = maxChars;
      final space = line.lastIndexOf(' ', maxChars);
      if (space > maxChars ~/ 4) {
        cut = space;
      }
      out.add(line.substring(0, cut).trimRight());
      line = line.substring(cut).trimLeft();
    }
  }
  return out;
}

int receiptWrapCharsForPaperMm(String paperMm) =>
    paperMm == '80' ? 42 : 28;
