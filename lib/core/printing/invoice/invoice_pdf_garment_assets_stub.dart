import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../../../data/local/catalog/catalog_image_ref.dart';
import '../../../data/local/order_item_summary.dart';
import '../../../data/local/order_style_snapshot_view.dart';
import '../../../data/local/style_figure_summary.dart';
import '../style_figure_raster.dart';
import 'invoice_pdf_constants.dart';

/// Per-garment design images for invoice v2.
class InvoiceGarmentDesignImages {
  const InvoiceGarmentDesignImages({
    this.catalogProvider,
    this.referenceProviders = const [],
  });

  final pw.ImageProvider? catalogProvider;
  final List<pw.ImageProvider> referenceProviders;

  bool get hasContent =>
      catalogProvider != null || referenceProviders.isNotEmpty;
}

Future<pw.ImageProvider?> loadInvoiceShapeImageProvider(String imageRef) async {
  if (imageRef.trim().isEmpty) return null;
  final raster = await loadStyleFigureRaster(
    imageRef: imageRef,
    maxWidthPx: InvoicePdfLayout.shapeImageLoadPx,
  );
  return _rasterToProvider(raster);
}

Future<pw.ImageProvider?> loadCatalogReferenceImageProvider(String? path) async {
  final trimmed = path?.trim();
  if (trimmed == null || trimmed.isEmpty) return null;
  return _rasterToProvider(await _loadCatalogRaster(trimmed));
}

Future<InvoiceGarmentDesignImages> loadGarmentDesignImages({
  required OrderItemSummary item,
  OrderStyleSnapshotView? styleSnap,
  List<StyleFigureSummary> catalogFigures = const [],
}) async {
  final catalogPath = _catalogPathForItem(item);
  pw.ImageProvider? catalog;
  if (catalogPath != null) {
    catalog = _rasterToProvider(await _loadCatalogRaster(catalogPath));
  }

  return InvoiceGarmentDesignImages(
    catalogProvider: catalog,
    referenceProviders: const [],
  );
}

String? _catalogPathForItem(OrderItemSummary item) {
  final image = item.catalogImagePathSnapshot?.trim();
  if (image != null && image.isNotEmpty) return image;
  final thumb = item.catalogThumbnailPathSnapshot?.trim();
  if (thumb != null && thumb.isNotEmpty) return thumb;
  return null;
}

Future<img.Image?> _loadCatalogRaster(String path) async {
  try {
    if (!isCatalogAssetImageRef(path)) return null;
    final assetPath = catalogBundleAssetPath(path);
    if (assetPath == null) return null;
    final data = await rootBundle.load('assets/catalog_seed/$assetPath');
    final decoded = img.decodeImage(data.buffer.asUint8List());
    if (decoded == null) return null;
    return _fitCatalogRaster(decoded);
  } on Object {
    return null;
  }
}

img.Image _fitCatalogRaster(img.Image decoded) {
  final w = decoded.width;
  final h = decoded.height;
  if (w <= 0 || h <= 0) return decoded;

  final scaleW = InvoicePdfLayout.catalogMaxWidthPx / w;
  final scaleH = InvoicePdfLayout.catalogMaxHeightPx / h;
  final scale = scaleW < scaleH ? scaleW : scaleH;
  if (scale >= 1) return decoded;

  final targetW =
      (w * scale).round().clamp(1, InvoicePdfLayout.catalogMaxWidthPx);
  final targetH =
      (h * scale).round().clamp(1, InvoicePdfLayout.catalogMaxHeightPx);
  return img.copyResize(
    decoded,
    width: targetW,
    height: targetH,
    interpolation: img.Interpolation.linear,
  );
}

pw.ImageProvider? _rasterToProvider(img.Image? raster) {
  if (raster == null) return null;
  return pw.MemoryImage(img.encodePng(raster));
}
