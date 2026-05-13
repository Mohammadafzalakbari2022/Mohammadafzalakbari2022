import 'dart:typed_data';

import 'catalog_stored_image_paths.dart';

Future<CatalogStoredImagePaths> storeCatalogImage(Uint8List bytes) async {
  throw UnsupportedError('Catalog image storage is not supported on web.');
}
