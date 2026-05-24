import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../branding/app_branding.dart';
import 'invoice_pdf_icons.dart';

const _kGooglePlayBadgeAsset =
    'assets/branding/invoice_google_play_badge.png';
const _kAppStoreBadgeAsset = 'assets/branding/invoice_app_store_badge.png';

/// Pride app icon + store badge images for the invoice promo footer.
class InvoicePdfPromoAssets {
  const InvoicePdfPromoAssets({
    this.prideIconProvider,
    this.googlePlayProvider,
    this.appStoreProvider,
  });

  final pw.ImageProvider? prideIconProvider;
  final pw.ImageProvider? googlePlayProvider;
  final pw.ImageProvider? appStoreProvider;
}

Future<InvoicePdfPromoAssets> loadInvoicePdfPromoAssets() async {
  return InvoicePdfPromoAssets(
    prideIconProvider: await _loadAssetProvider(
      kAppBrandIconAsset,
      maxHeightPx: 14,
    ),
    googlePlayProvider: await _loadAssetProvider(
      _kGooglePlayBadgeAsset,
      maxHeightPx: 18,
    ),
    appStoreProvider: await _loadAssetProvider(
      _kAppStoreBadgeAsset,
      maxHeightPx: 18,
    ),
  );
}

Future<pw.ImageProvider?> _loadAssetProvider(
  String assetPath, {
  required int maxHeightPx,
}) async {
  try {
    final data = await rootBundle.load(assetPath);
    var decoded = img.decodeImage(data.buffer.asUint8List());
    if (decoded == null) return null;
    if (decoded.height > maxHeightPx) {
      final w = (decoded.width * maxHeightPx / decoded.height).round();
      decoded = img.copyResize(
        decoded,
        width: w.clamp(1, 9999),
        height: maxHeightPx,
        interpolation: img.Interpolation.linear,
      );
    }
    return pw.MemoryImage(Uint8List.fromList(img.encodePng(decoded)));
  } on Object {
    return null;
  }
}

/// Fallback store platform icons when badge PNGs are missing from the bundle.
pw.Widget buildInvoiceStoreBadgeFallback({
  required bool isGooglePlay,
  double size = 12,
  PdfColor? color,
}) {
  final c = color ?? PdfColors.grey600;
  return isGooglePlay
      ? InvoicePdfIcons.android(size: size, color: c)
      : InvoicePdfIcons.apple(size: size, color: c);
}
