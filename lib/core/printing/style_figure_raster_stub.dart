import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;

import '../../data/local/style/style_figure_image_ref.dart';

Future<img.Image?> loadStyleFigureRaster({
  required String imageRef,
  required int maxWidthPx,
}) async {
  try {
    final asset = StyleFigureImageRef.assetPathFromRef(imageRef);
    if (asset == null) return null;
    final data = await rootBundle.load(asset);
    var decoded = img.decodeImage(data.buffer.asUint8List());
    if (decoded == null) return null;
    if (decoded.width <= maxWidthPx) return decoded;
    return img.copyResize(
      decoded,
      width: maxWidthPx,
      interpolation: img.Interpolation.linear,
    );
  } on Object {
    return null;
  }
}
