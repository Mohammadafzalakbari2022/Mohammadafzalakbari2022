import 'dart:typed_data';
import 'dart:ui' as ui;

/// Downscales for list/grid; PNG output. Returns null if decoding fails.
Future<Uint8List?> encodeCatalogThumbnailPng(
  Uint8List bytes, {
  int targetWidth = 320,
}) async {
  try {
    final codec = await ui.instantiateImageCodec(
      bytes,
      targetWidth: targetWidth,
      allowUpscaling: false,
    );
    final frame = await codec.getNextFrame();
    final image = frame.image;
    final byteData = await image.toByteData(format: ui.ImageByteFormat.png);
    image.dispose();
    if (byteData == null) return null;
    return byteData.buffer.asUint8List();
  } catch (_) {
    return null;
  }
}
