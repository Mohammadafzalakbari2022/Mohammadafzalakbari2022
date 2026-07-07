import 'dart:io';

import 'package:image/image.dart' as img;
import 'package:image_picker/image_picker.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

Future<String?> pickShopLogoRelativePath() async {
  final picker = ImagePicker();
  final picked = await picker.pickImage(
    source: ImageSource.gallery,
    maxWidth: 1200,
    maxHeight: 1200,
    imageQuality: 88,
  );
  if (picked == null) return null;
  final bytes = await File(picked.path).readAsBytes();
  final decoded = img.decodeImage(bytes);
  if (decoded == null) return null;
  const maxW = 558;
  final raster = decoded.width > maxW
      ? img.copyResize(
          decoded,
          width: maxW,
          interpolation: img.Interpolation.linear,
        )
      : decoded;
  final dir = await prideApplicationDocumentsDirectory();
  final brandingDir = Directory(
    '${dir.path}${Platform.pathSeparator}branding',
  );
  if (!await brandingDir.exists()) {
    await brandingDir.create(recursive: true);
  }
  final outFile = File(
    '${dir.path}${Platform.pathSeparator}branding${Platform.pathSeparator}shop_logo.png',
  );
  await outFile.writeAsBytes(img.encodePng(raster));
  return 'branding/shop_logo.png';
}

Future<void> deleteShopLogoFile() async {
  final dir = await prideApplicationDocumentsDirectory();
  final f = File(
    '${dir.path}${Platform.pathSeparator}branding${Platform.pathSeparator}shop_logo.png',
  );
  if (await f.exists()) {
    await f.delete();
  }
}
