import 'package:flutter/material.dart';

import 'catalog_item_image_stub.dart'
    if (dart.library.io) 'catalog_item_image_io.dart';

class CatalogItemImage extends StatelessWidget {
  const CatalogItemImage({
    super.key,
    required this.imagePath,
  });

  final String? imagePath;

  @override
  Widget build(BuildContext context) {
    return buildCatalogItemImage(context, imagePath);
  }
}

