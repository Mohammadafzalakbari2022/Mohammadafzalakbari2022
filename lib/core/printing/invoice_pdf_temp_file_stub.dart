/// Web / non-IO platforms: no filesystem temp file for PDF share.
Future<String?> writeInvoicePdfToTempFile({
  required List<int> bytes,
  required String filename,
}) async {
  return null;
}
