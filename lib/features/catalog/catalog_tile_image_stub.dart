import 'package:flutter/material.dart';

Widget buildCatalogTileImage(
  BuildContext context, {
  required String? thumbnailPath,
  required String? imagePath,
  required double borderRadius,
  double? dimension,
}) {
  final bg = Theme.of(context).colorScheme.surfaceContainerHighest;
  final child = Icon(Icons.image_outlined, color: Theme.of(context).colorScheme.outline);
  return ClipRRect(
    borderRadius: BorderRadius.circular(borderRadius),
    child: ColoredBox(
      color: bg,
      child: Center(child: child),
    ),
  );
}
