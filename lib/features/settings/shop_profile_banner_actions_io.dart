import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';

/// Picks and saves a wide shop banner (~3:1) under app documents.
Future<String?> pickShopBannerRelativePath() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1800,
    maxHeight: 600,
    imageQuality: 88,
  );
  if (picked == null) return null;
  final bytes = await File(picked.path).readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;

  const maxW = 1200;
  const targetH = 400;
  img.Image raster = decoded;
  if (decoded.width > maxW) {
    raster = img.copyResize(
      decoded,
      width: maxW,
      interpolation: img.Interpolation.linear,
    );
  }
  if (raster.height > targetH) {
    raster = img.copyResize(
      raster,
      height: targetH,
      interpolation: img.Interpolation.linear,
    );
  }

  final dir = await getApplicationDocumentsDirectory();
  final brandingDir = Directory(
    '${dir.path}${Platform.pathSeparator}branding',
  );
  if (!await brandingDir.exists()) {
    await brandingDir.create(recursive: true);
  }
  final outFile = File(
    '${dir.path}${Platform.pathSeparator}branding${Platform.pathSeparator}shop_banner.png',
  );
  await outFile.writeAsBytes(img.encodePng(raster));
  return 'branding/shop_banner.png';
}

Future<void> deleteShopBannerFile() async {
  final dir = await getApplicationDocumentsDirectory();
  final f = File(
    '${dir.path}${Platform.pathSeparator}branding${Platform.pathSeparator}shop_banner.png',
  );
  if (await f.exists()) {
    await f.delete();
  }
}
