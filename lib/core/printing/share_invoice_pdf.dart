import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

import 'invoice_pdf_temp_file.dart';

/// Shares invoice PDF bytes via the system share sheet on all platforms.
///
/// On mobile/desktop, writes a temp file first — [XFile.fromData] is unreliable
/// for PDFs on Android.
Future<void> shareInvoicePdfBytes({
  required Uint8List pdfBytes,
  required String filename,
  String? subject,
  String? text,
}) async {
  if (kIsWeb) {
    await Share.shareXFiles(
      [
        XFile.fromData(
          pdfBytes,
          mimeType: 'application/pdf',
          name: filename,
        ),
      ],
      subject: subject,
      text: text,
    );
    return;
  }

  final path = await writeInvoicePdfToTempFile(
    bytes: pdfBytes,
    filename: filename,
  );
  if (path == null) {
    throw StateError('Could not create temporary PDF file for sharing');
  }

  await Share.shareXFiles(
    [
      XFile(
        path,
        mimeType: 'application/pdf',
        name: filename,
      ),
    ],
    subject: subject,
    text: text,
  );
}
