import 'dart:io';
import 'dart:typed_data';

import 'package:path_provider/path_provider.dart';
import 'package:uuid/uuid.dart';

import 'catalog_stored_image_paths.dart';
import 'catalog_thumbnail_io.dart';

final _uuid = const Uuid();

Future<CatalogStoredImagePaths> storeCatalogImage(Uint8List bytes) async {
  final dir = await getApplicationDocumentsDirectory();
  final folder = Directory('${dir.path}${Platform.pathSeparator}catalog');
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }
  final id = _uuid.v4();
  final imagePath = '${folder.path}${Platform.pathSeparator}$id.jpg';
  await File(imagePath).writeAsBytes(bytes, flush: true);

  String? thumbnailPath;
  final thumbBytes = await encodeCatalogThumbnailPng(bytes);
  if (thumbBytes != null && thumbBytes.isNotEmpty) {
    thumbnailPath = '${folder.path}${Platform.pathSeparator}$id.thumb.png';
    await File(thumbnailPath).writeAsBytes(thumbBytes, flush: true);
  }

  return CatalogStoredImagePaths(
    imagePath: imagePath,
    thumbnailPath: thumbnailPath,
  );
}
