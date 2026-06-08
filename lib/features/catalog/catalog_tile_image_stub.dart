import 'package:flutter/material.dart';

import '../../data/local/catalog/catalog_image_ref.dart';

Widget buildCatalogTileImage(
  BuildContext context, {
  required String? thumbnailPath,
  required String? imagePath,
  required double borderRadius,
  double? dimension,
}) {
  final path = (thumbnailPath != null && thumbnailPath.isNotEmpty)
      ? thumbnailPath
      : imagePath;
  final bg = Theme.of(context).colorScheme.surface;
  final placeholder = Icon(
    Icons.image_outlined,
    color: Theme.of(context).colorScheme.outline,
  );

  if (isCatalogAssetImageRef(path)) {
    final assetPath = catalogBundleAssetPath(path);
    if (assetPath != null) {
      Widget image = ColoredBox(
        color: bg,
        child: Image.asset(
          'assets/catalog_seed/$assetPath',
          fit: BoxFit.contain,
          width: dimension,
          height: dimension,
          errorBuilder: (context, error, stackTrace) {
            return Center(child: placeholder);
          },
        ),
      );
      image = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
      if (dimension != null) {
        return SizedBox(width: dimension, height: dimension, child: image);
      }
      return SizedBox.expand(child: image);
    }
  }

  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: ColoredBox(
      color: bg,
      child: Center(child: placeholder),
    ),
  );
}
