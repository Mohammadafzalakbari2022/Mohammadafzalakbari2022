import 'dart:io';

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
  final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
  final icon = Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.outline);

  if (path == null || path.isEmpty) {
    Widget inner = ColoredBox(
      color: bg,
      child: Center(child: icon),
    );
    inner = ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: inner,
    );
    if (dimension != null) {
      return SizedBox(width: dimension, height: dimension, child: inner);
    }
    return SizedBox.expand(child: inner);
  }

  if (isCatalogAssetImageRef(path)) {
    final assetPath = catalogBundleAssetPath(path);
    if (assetPath != null) {
      Widget image = Image.asset(
        'assets/catalog_seed/$assetPath',
        fit: BoxFit.cover,
        width: dimension,
        height: dimension,
        errorBuilder: (context, error, stackTrace) {
          return ColoredBox(
            color: bg,
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: Theme.of(context).colorScheme.outline,
              ),
            ),
          );
        },
      );
      image = ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: image,
      );
      if (dimension == null) {
        return SizedBox.expand(child: image);
      }
      return SizedBox(width: dimension, height: dimension, child: image);
    }
  }

  final file = File(path);
  Widget image = Image.file(
    file,
    fit: BoxFit.cover,
    width: dimension,
    height: dimension,
    errorBuilder: (context, error, stackTrace) {
      return ColoredBox(
        color: bg,
        child: Center(
          child: Icon(
            Icons.broken_image_outlined,
            color: Theme.of(context).colorScheme.outline,
          ),
        ),
      );
    },
  );

  image = ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: image,
  );

  if (dimension == null) {
    return SizedBox.expand(child: image);
  }
  return SizedBox(width: dimension, height: dimension, child: image);
}
