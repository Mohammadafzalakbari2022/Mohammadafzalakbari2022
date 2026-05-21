import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/catalog/catalog_image_ref.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import 'style_figure_raster.dart';

/// Max style figure thumbnails on the invoice design rail.
const int kInvoicePdfMaxStyleFigures = 6;

const int kInvoicePdfStyleFigurePx = 36;
const int kInvoicePdfCatalogMaxWidthPx = 100;
const int kInvoicePdfCatalogMaxHeightPx = 90;

/// Raster images for the PDF side design rail (style figures + catalog).
class InvoicePdfDesignRail {
  const InvoicePdfDesignRail({
    this.figureProviders = const [],
    this.catalogProvider,
  });

  final List<pw.ImageProvider> figureProviders;
  final pw.ImageProvider? catalogProvider;

  bool get hasContent =>
      figureProviders.isNotEmpty || catalogProvider != null;
}

Future<InvoicePdfDesignRail> loadInvoicePdfDesignRail({
  required OrderSummary order,
  OrderStyleSnapshotView? styleSnap,
}) async {
  final figureProviders = <pw.ImageProvider>[];
  final figures = styleSnap?.figures ?? [];
  if (figures.isNotEmpty) {
    final sorted = List<OrderStyleSnapshotFigureView>.from(figures)
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    for (final f in sorted.take(kInvoicePdfMaxStyleFigures)) {
      final ref = f.imageRefSnapshot.trim();
      if (ref.isEmpty) continue;
      final raster = await loadStyleFigureRaster(
        imageRef: ref,
        maxWidthPx: kInvoicePdfStyleFigurePx,
      );
      final provider = _rasterToProvider(raster);
      if (provider != null) figureProviders.add(provider);
    }
  }

  final catalogPath = _catalogPathForInvoice(order);
  pw.ImageProvider? catalogProvider;
  if (catalogPath != null) {
    final raster = await _loadCatalogRaster(catalogPath);
    catalogProvider = _rasterToProvider(raster);
  }

  return InvoicePdfDesignRail(
    figureProviders: figureProviders,
    catalogProvider: catalogProvider,
  );
}

String? _catalogPathForInvoice(OrderSummary order) {
  final thumb = order.catalogThumbnailPathSnapshot?.trim();
  if (thumb != null && thumb.isNotEmpty) return thumb;
  final image = order.catalogImagePathSnapshot?.trim();
  if (image != null && image.isNotEmpty) return image;
  return null;
}

Future<img.Image?> _loadCatalogRaster(String path) async {
  try {
    img.Image? decoded;
    if (isCatalogAssetImageRef(path)) {
      final assetPath = catalogBundleAssetPath(path);
      if (assetPath == null) return null;
      final data = await rootBundle.load('assets/catalog_seed/$assetPath');
      decoded = img.decodeImage(data.buffer.asUint8List());
    } else {
      final file = File(path);
      if (!await file.exists()) return null;
      decoded = img.decodeImage(await file.readAsBytes());
    }
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

  final scaleW = kInvoicePdfCatalogMaxWidthPx / w;
  final scaleH = kInvoicePdfCatalogMaxHeightPx / h;
  final scale = scaleW < scaleH ? scaleW : scaleH;
  if (scale >= 1) return decoded;

  final targetW = (w * scale).round().clamp(1, kInvoicePdfCatalogMaxWidthPx);
  return img.copyResize(
    decoded,
    width: targetW,
    interpolation: img.Interpolation.linear,
  );
}

pw.ImageProvider? _rasterToProvider(img.Image? raster) {
  if (raster == null) return null;
  final png = Uint8List.fromList(img.encodePng(raster));
  return pw.MemoryImage(png);
}
