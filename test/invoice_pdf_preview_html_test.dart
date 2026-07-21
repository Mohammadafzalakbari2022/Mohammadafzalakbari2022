import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/printing/invoice_pdf_preview_html.dart';

void main() {
  test('invoicePdfPreviewHtml embeds valid PDF header in base64 for pdf.js', () {
    const header = '%PDF-1.4';
    final bytes = Uint8List.fromList(header.codeUnits);
    final html = invoicePdfPreviewHtml(bytes);
    expect(html, contains('pdfjsLib.getDocument'));
    expect(html, contains('atob('));
    final encoded = html.split("atob('").last.split("'").first;
    final decoded = utf8.decode(base64Decode(encoded));
    expect(decoded, startsWith('%PDF'));
  });
}
