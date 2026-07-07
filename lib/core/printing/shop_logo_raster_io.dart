import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

import '../defaults/effective_shop_profile.dart';

Future<img.Image?> _decodeAndResizeLogoBytes(
  List<int> raw,
  int maxWidthPx,
) async {
  final bytes = raw is Uint8List ? raw : Uint8List.fromList(raw);
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  if (decoded.width <= maxWidthPx) return decoded;
  return img.copyResize(
    decoded,
    width: maxWidthPx,
    interpolation: img.Interpolation.linear,
  );
}

Future<img.Image?> loadBundledDefaultShopLogoRaster({
  required int maxWidthPx,
}) async {
  try {
    final data = await rootBundle.load(kDefaultShopLogoAsset);
    return _decodeAndResizeLogoBytes(
      data.buffer.asUint8List(),
      maxWidthPx,
    );
  } on Object {
    return null;
  }
}

/// User-uploaded logo, or bundled default when none is saved.
Future<img.Image?> loadReceiptHeaderLogoRaster({
  required String? userLogoRelativePath,
  required int maxWidthPx,
}) async {
  final user = await loadShopLogoRasterIfPresent(
    relativePath: userLogoRelativePath,
    maxWidthPx: maxWidthPx,
  );
  if (user != null) return user;
  return loadBundledDefaultShopLogoRaster(maxWidthPx: maxWidthPx);
}

Future<img.Image?> loadShopLogoRasterIfPresent({
  required String? relativePath,
  required int maxWidthPx,
}) async {
  final path = relativePath?.trim();
  if (path == null || path.isEmpty) return null;
  try {
    final dir = await prideApplicationDocumentsDirectory();
    final segments = path.split('/');
    final file = File(
      '${dir.path}${Platform.pathSeparator}${segments.join(Platform.pathSeparator)}',
    );
    if (!await file.exists()) return null;
    final raw = await file.readAsBytes();
    return _decodeAndResizeLogoBytes(raw, maxWidthPx);
  } on Object {
    return null;
  }
}

Future<img.Image?> loadShopBannerRasterIfPresent({
  required String? relativePath,
  required int maxWidthPx,
}) async {
  final path = relativePath?.trim();
  if (path == null || path.isEmpty) return null;
  try {
    final dir = await prideApplicationDocumentsDirectory();
    final segments = path.split('/');
    final file = File(
      '${dir.path}${Platform.pathSeparator}${segments.join(Platform.pathSeparator)}',
    );
    if (!await file.exists()) return null;
    final raw = await file.readAsBytes();
    return _decodeAndResizeLogoBytes(raw, maxWidthPx);
  } on Object {
    return null;
  }
}
