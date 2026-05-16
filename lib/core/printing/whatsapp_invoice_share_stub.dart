/// Shares a PDF invoice directly to WhatsApp when possible.
///
/// Returns `true` when WhatsApp was opened with the file, `false` to fall back
/// to the system share sheet.
Future<bool> shareInvoicePdfToWhatsApp({
  required String filePath,
  required String phoneDigits,
  String? caption,
}) async =>
    false;
