import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pdf/widgets.dart' as pw;

import '../../data/local/catalog/catalog_image_ref.dart';
import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/style/order_style_figures_resolver.dart';
import '../../data/local/style_figure_summary.dart';
import 'style_figure_raster.dart';

/// Max style figure thumbnails on the invoice.
const int kInvoicePdfMaxStyleFigures = 8;

/// Style figure raster size (px) — loaded at this resolution for PDF clarity.
const int kInvoicePdfStyleFigurePx = 140;

/// Catalog image max bounds (px) for the design column.
const int kInvoicePdfCatalogMaxWidthPx = 280;
const int kInvoicePdfCatalogMaxHeightPx = 520;

/// PDF layout height (points) for the image column — compact for one-page fit.
const double kInvoicePdfCatalogDisplayHeightPt = 185;
const double kInvoicePdfStyleFigureDisplayPt = 72;

/// Raster images for style figures and catalog design on the invoice.
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
  List<StyleFigureSummary> catalogFigures = const [],
}) async {
  final figureProviders = <pw.ImageProvider>[];

  final snapFigures = styleSnap?.figures ?? [];
  if (snapFigures.isNotEmpty) {
    final sorted = List<OrderStyleSnapshotFigureView>.from(snapFigures)
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
  } else {
    final selected = resolveOrderStyleFigures(
      styleSelectionJson: order.styleSelectionJson,
      allFigures: catalogFigures,
    );
    for (final figure in selected.take(kInvoicePdfMaxStyleFigures)) {
      final raster = await loadStyleFigureRaster(
        imageRef: figure.imageRef,
        maxWidthPx: kInvoicePdfStyleFigurePx,
      );
      final provider = _rasterToProvider(raster);
      if (provider != null) figureProviders.add(provider);
    }
  }

  pw.ImageProvider? catalogProvider;
  final catalogPath = _catalogPathForInvoice(order);
  if (catalogPath != null) {
    final raster = await _loadCatalogRaster(catalogPath);
    catalogProvider = _rasterToProvider(raster);
  }

  return InvoicePdfDesignRail(
    figureProviders: figureProviders,
    catalogProvider: catalogProvider,
  );
}

/// Prefer full design image over thumbnail for PDF clarity.
String? _catalogPathForInvoice(OrderSummary order) {
  final image = order.catalogImagePathSnapshot?.trim();
  if (image != null && image.isNotEmpty) return image;
  final thumb = order.catalogThumbnailPathSnapshot?.trim();
  if (thumb != null && thumb.isNotEmpty) return thumb;
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
  final targetH = (h * scale).round().clamp(1, kInvoicePdfCatalogMaxHeightPx);
  return img.copyResize(
    decoded,
    width: targetW,
    height: targetH,
    interpolation: img.Interpolation.linear,
  );
}

pw.ImageProvider? _rasterToProvider(img.Image? raster) {
  if (raster == null) return null;
  final png = Uint8List.fromList(img.encodePng(raster));
  return pw.MemoryImage(png);
}
