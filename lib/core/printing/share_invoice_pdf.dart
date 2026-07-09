import 'package:flutter/foundation.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

/// Shares invoice PDF bytes via [Printing.sharePdf] on mobile or [Share.shareXFiles] on web.
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
  } else {
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: filename,
    );
  }
}
