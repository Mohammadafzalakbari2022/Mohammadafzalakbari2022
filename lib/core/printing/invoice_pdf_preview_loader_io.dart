import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

import 'invoice_pdf_preview_data.dart';
import 'invoice_pdf_preview_html.dart';
import 'invoice_pdf_temp_file.dart';

const _androidChannel = MethodChannel('com.pridev3.pride_v3/invoice_pdf');

Future<List<Uint8List>> _rasterPdfOnAndroid(String path) async {
  final raw = await _androidChannel.invokeMethod<List<dynamic>>(
    'rasterPages',
    <String, Object>{
      'path': path,
      'scale': 2.0,
    },
  );
  if (raw == null || raw.isEmpty) {
    throw StateError('Android PDF preview returned no pages');
  }
  return [
    for (final page in raw)
      switch (page) {
        Uint8List bytes => bytes,
        List<int> bytes => Uint8List.fromList(bytes),
        _ => throw StateError('Unexpected Android preview page type'),
      },
  ];
}

/// Builds in-app invoice preview from the same PDF bytes used for share.
Future<InvoicePdfPreviewData> loadInvoicePdfPreview({
  required Uint8List pdfBytes,
}) async {
  if (Platform.isAndroid) {
    final path = await writeInvoicePdfToTempFile(
      bytes: pdfBytes,
      filename: 'invoice_view.pdf',
    );
    if (path == null) {
      throw StateError('Could not write invoice PDF for preview');
    }
    final images = await _rasterPdfOnAndroid(path);
    return InvoicePdfPreviewData.pageImages(images);
  }

  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    final path = await writeInvoicePdfToTempFile(
      bytes: pdfBytes,
      filename: 'invoice_view.pdf',
    );
    if (path == null) {
      throw StateError('Could not write invoice PDF for preview');
    }
    return InvoicePdfPreviewData.webFileUrl(Uri.file(path).toString());
  }

  return InvoicePdfPreviewData.webHtml(invoicePdfPreviewHtml(pdfBytes));
}
