import 'package:flutter/foundation.dart';

import 'invoice_pdf_preview_data.dart';
import 'invoice_pdf_preview_html.dart';

/// Web: embed PDF in HTML for WebView preview.
Future<InvoicePdfPreviewData> loadInvoicePdfPreview({
  required Uint8List pdfBytes,
}) async {
  return InvoicePdfPreviewData.webHtml(invoicePdfPreviewHtml(pdfBytes));
}
