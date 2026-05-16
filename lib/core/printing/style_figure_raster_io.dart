import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image/image.dart' as img;
import 'package:path_provider/path_provider.dart';

import '../../data/local/style/style_figure_image_ref.dart';

Future<img.Image?> loadStyleFigureRaster({
  required String imageRef,
  required int maxWidthPx,
}) async {
  try {
    img.Image? decoded;
    final asset = StyleFigureImageRef.assetPathFromRef(imageRef);
    if (asset != null) {
      final data = await rootBundle.load(asset);
      decoded = img.decodeImage(data.buffer.asUint8List());
    } else {
      final rel = StyleFigureImageRef.fileRelativePathFromRef(imageRef);
      if (rel == null) return null;
      final dir = await getApplicationDocumentsDirectory();
      final segments = rel.split('/');
      final file = File(
        '${dir.path}${Platform.pathSeparator}${segments.join(Platform.pathSeparator)}',
      );
      if (!await file.exists()) return null;
      decoded = img.decodeImage(await file.readAsBytes());
    }
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
