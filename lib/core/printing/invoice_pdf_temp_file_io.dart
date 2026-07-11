import 'dart:io';

import 'package:flutter/foundation.dart';

import '../persistence/pride_path_provider_io.dart';
import 'invoice_pdf_validation.dart';

/// Writes [bytes] to a temp file when not on web. Returns null on web.
Future<String?> writeInvoicePdfToTempFile({
  required List<int> bytes,
  required String filename,
}) async {
  if (kIsWeb) return null;
  if (!isValidPdfBytes(bytes)) {
    throw StateError('Invalid PDF bytes');
  }
  final dir = await prideTemporaryDirectory();
  final path = '${dir.path}/$filename';
  await File(path).writeAsBytes(bytes, flush: true);
  return path;
}
