import 'package:flutter/material.dart';

import 'catalog_tile_image_stub.dart'
    if (dart.library.io) 'catalog_tile_image_io.dart';

class CatalogTileImage extends StatelessWidget {
  const CatalogTileImage({
    super.key,
    this.thumbnailPath,
    this.imagePath,
    this.borderRadius = 12,
    this.dimension,
  });

  final String? thumbnailPath;
  final String? imagePath;
  final double borderRadius;

  /// When set (e.g. 56 for list rows), image is square; otherwise expands in parent.
  final double? dimension;

  @override
  Widget build(BuildContext context) {
    return buildCatalogTileImage(
      context,
      thumbnailPath: thumbnailPath,
      imagePath: imagePath,
      borderRadius: borderRadius,
      dimension: dimension,
    );
  }
}
