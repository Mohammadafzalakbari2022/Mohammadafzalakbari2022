import 'package:flutter/material.dart';

import '../../data/local/catalog/catalog_image_ref.dart';

Widget buildCatalogItemImage(BuildContext context, String? imagePath) {
  if (isCatalogAssetImageRef(imagePath)) {
    final assetPath = catalogBundleAssetPath(imagePath);
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: 240,
          child: Image.asset(
            'assets/catalog_seed/$assetPath',
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return _placeholder(context);
            },
          ),
        ),
      );
    }
  }

  if (imagePath == null || imagePath.isEmpty) {
    return _placeholder(context);
  }

  return _placeholder(context);
}

Widget _placeholder(BuildContext context) {
  return Container(
    width: double.infinity,
    height: 240,
    decoration: BoxDecoration(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      borderRadius: BorderRadius.circular(16),
    ),
    child: const Center(child: Icon(Icons.image_outlined, size: 56)),
  );
}
