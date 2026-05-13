import 'package:flutter/material.dart';

Widget buildCatalogItemImage(BuildContext context, String? imagePath) {
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

