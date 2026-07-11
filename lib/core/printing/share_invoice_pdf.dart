import 'package:flutter/foundation.dart';
import 'package:share_plus/share_plus.dart';

/// Shares invoice PDF bytes via the system share sheet on all platforms.
Future<void> shareInvoicePdfBytes({
  required Uint8List pdfBytes,
  required String filename,
  String? subject,
  String? text,
}) async {
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
}
