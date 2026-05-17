import '../../../features/catalog/catalog_stored_image_paths.dart';
import 'catalog_image_ref.dart';

/// Web: keep asset refs; no filesystem copy.
Future<CatalogStoredImagePaths?> copyCatalogPathsToOrderSnapshot({
  required String orderInternalId,
  String? imagePath,
  String? thumbnailPath,
}) async {
  final srcImage = imagePath?.trim();
  if (srcImage == null || srcImage.isEmpty) return null;
  if (!isCatalogAssetImageRef(srcImage)) {
    return CatalogStoredImagePaths(
      imagePath: srcImage,
      thumbnailPath: thumbnailPath,
    );
  }
  return CatalogStoredImagePaths(
    imagePath: srcImage,
    thumbnailPath: thumbnailPath ?? srcImage,
  );
}
