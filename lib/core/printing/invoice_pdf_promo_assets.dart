import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../branding/app_branding.dart';

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
      maxHeightPx: 13,
    ),
    appStoreProvider: await _loadAssetProvider(
      _kAppStoreBadgeAsset,
      maxHeightPx: 13,
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

/// Fallback store icons when badge PNGs are missing from the bundle.
pw.Widget buildInvoiceStoreBadgeFallback({
  required bool isGooglePlay,
  double size = 13,
}) {
  return pw.SizedBox(
    width: size,
    height: size,
    child: pw.CustomPaint(
      size: PdfPoint(size, size),
      painter: (canvas, bounds) {
        final grey = PdfColors.grey600;
        canvas.setStrokeColor(grey);
        canvas.setLineWidth(0.4);
        canvas.drawRect(0, 0, bounds.x, bounds.y);
        if (isGooglePlay) {
          canvas.setFillColor(grey);
          final cx = bounds.x * 0.38;
          final cy = bounds.y * 0.5;
          final s = bounds.x * 0.22;
          canvas.moveTo(cx - s * 0.3, cy - s);
          canvas.lineTo(cx + s, cy);
          canvas.lineTo(cx - s * 0.3, cy + s);
          canvas.closePath();
          canvas.fillPath();
        } else {
          canvas.setFillColor(grey);
          final r = bounds.x * 0.22;
          canvas.drawEllipse(
            bounds.x * 0.5,
            bounds.y * 0.52,
            r,
            r * 1.1,
          );
          canvas.drawRect(
            bounds.x * 0.38,
            bounds.y * 0.35,
            bounds.x * 0.24,
            bounds.y * 0.22,
          );
        }
      },
    ),
  );
}
