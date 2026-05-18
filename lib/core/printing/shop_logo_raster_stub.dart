import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

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

Future<img.Image?> loadShopLogoRasterIfPresent({
  required String? relativePath,
  required int maxWidthPx,
}) async =>
    null;

/// User-uploaded logo, or bundled default when none is saved (web has no upload).
Future<img.Image?> loadReceiptHeaderLogoRaster({
  required String? userLogoRelativePath,
  required int maxWidthPx,
}) async {
  return loadBundledDefaultShopLogoRaster(maxWidthPx: maxWidthPx);
}
