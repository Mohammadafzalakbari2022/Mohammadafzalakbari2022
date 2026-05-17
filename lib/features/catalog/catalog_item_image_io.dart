import 'dart:io';

import 'package:flutter/material.dart';

import '../../data/local/catalog/catalog_image_ref.dart';

Widget buildCatalogItemImage(BuildContext context, String? imagePath) {
  if (imagePath == null || imagePath.isEmpty) {
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

  if (isCatalogAssetImageRef(imagePath)) {
    final assetPath = catalogBundleAssetPath(imagePath);
    if (assetPath != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: SizedBox(
          width: double.infinity,
          height: 240,
          child: InteractiveViewer(
            minScale: 1,
            maxScale: 4,
            child: Center(
              child: Image.asset(
                'assets/catalog_seed/$assetPath',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    width: double.infinity,
                    height: 240,
                    color: Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    child: const Center(
                      child: Icon(Icons.broken_image_outlined, size: 56),
                    ),
                  );
                },
              ),
            ),
          ),
        ),
      );
    }
  }

  final file = File(imagePath);
  return ClipRRect(
    borderRadius: BorderRadius.circular(16),
    child: SizedBox(
      width: double.infinity,
      height: 240,
      child: InteractiveViewer(
        minScale: 1,
        maxScale: 4,
        child: Center(
          child: Image.file(
            file,
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                height: 240,
                color: Theme.of(context).colorScheme.surfaceContainerHighest,
                child: const Center(child: Icon(Icons.broken_image_outlined, size: 56)),
              );
            },
          ),
        ),
      ),
    ),
  );
}

