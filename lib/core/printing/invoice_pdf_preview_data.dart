import 'package:flutter/foundation.dart';

/// Preview payload: page images (Android) or WebView HTML/file (desktop/web).
class InvoicePdfPreviewData {
  const InvoicePdfPreviewData._({
    this.pageImages,
    this.webHtml,
    this.webFileUrl,
  });

  final List<Uint8List>? pageImages;
  final String? webHtml;
  final String? webFileUrl;

  bool get usesWebView =>
      (webHtml != null && webHtml!.isNotEmpty) ||
      (webFileUrl != null && webFileUrl!.isNotEmpty);
  bool get usesPageImages => pageImages != null && pageImages!.isNotEmpty;

  factory InvoicePdfPreviewData.webHtml(String html) =>
      InvoicePdfPreviewData._(webHtml: html);

  factory InvoicePdfPreviewData.webFileUrl(String url) =>
      InvoicePdfPreviewData._(webFileUrl: url);

  factory InvoicePdfPreviewData.pageImages(List<Uint8List> images) =>
      InvoicePdfPreviewData._(pageImages: images);
}
