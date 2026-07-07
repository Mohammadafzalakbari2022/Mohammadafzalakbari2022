import 'dart:io';

import 'package:flutter/services.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

import 'catalog_image_ref.dart';
import '../../../features/catalog/catalog_stored_image_paths.dart';
import '../../../features/catalog/catalog_thumbnail_io.dart';

/// Copies catalog image (+ thumb) into order-private snapshot folder.
Future<CatalogStoredImagePaths?> copyCatalogPathsToOrderSnapshot({
  required String orderInternalId,
  String? imagePath,
  String? thumbnailPath,
}) async {
  final srcImage = imagePath?.trim();
  if (srcImage == null || srcImage.isEmpty) return null;

  final dir = await prideApplicationDocumentsDirectory();
  final folder = Directory(
    '${dir.path}${Platform.pathSeparator}catalog${Platform.pathSeparator}order_snapshots',
  );
  if (!await folder.exists()) {
    await folder.create(recursive: true);
  }

  Uint8List? imageBytes;
  if (isCatalogAssetImageRef(srcImage)) {
    final assetPath = catalogBundleAssetPath(srcImage);
    if (assetPath != null) {
      final data = await rootBundle.load('assets/catalog_seed/$assetPath');
      imageBytes = data.buffer.asUint8List();
    }
  } else {
    final file = File(srcImage);
    if (await file.exists()) {
      imageBytes = await file.readAsBytes();
    }
  }
  if (imageBytes == null || imageBytes.isEmpty) return null;

  final imageOut =
      '${folder.path}${Platform.pathSeparator}$orderInternalId.jpg';
  await File(imageOut).writeAsBytes(imageBytes, flush: true);

  String? thumbOut;
  if (thumbnailPath != null && thumbnailPath.isNotEmpty) {
    if (isCatalogAssetImageRef(thumbnailPath)) {
      final assetPath = catalogBundleAssetPath(thumbnailPath);
      if (assetPath != null) {
        final data = await rootBundle.load('assets/catalog_seed/$assetPath');
        thumbOut =
            '${folder.path}${Platform.pathSeparator}$orderInternalId.thumb.png';
        await File(thumbOut).writeAsBytes(
          data.buffer.asUint8List(),
          flush: true,
        );
      }
    } else {
      final thumbFile = File(thumbnailPath);
      if (await thumbFile.exists()) {
        thumbOut =
            '${folder.path}${Platform.pathSeparator}$orderInternalId.thumb.png';
        await thumbFile.copy(thumbOut);
      }
    }
  }

  thumbOut ??= await _generateThumb(imageBytes, folder.path, orderInternalId);

  return CatalogStoredImagePaths(
    imagePath: imageOut,
    thumbnailPath: thumbOut,
  );
}

Future<String?> _generateThumb(
  Uint8List imageBytes,
  String folderPath,
  String orderInternalId,
) async {
  final thumbBytes = await encodeCatalogThumbnailPng(imageBytes);
  if (thumbBytes == null || thumbBytes.isEmpty) return null;
  final thumbOut =
      '$folderPath${Platform.pathSeparator}$orderInternalId.thumb.png';
  await File(thumbOut).writeAsBytes(thumbBytes, flush: true);
  return thumbOut;
}
