import 'package:flutter/material.dart';

Widget buildStyleFigureImage({
  required String imageRef,
  double? size,
  BoxFit fit = BoxFit.contain,
}) {
  final iconSize = (size ?? 48) * 0.5;
  final asset = _assetPath(imageRef);
  if (asset != null) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: fit,
      errorBuilder: (_, _, _) =>
          Icon(Icons.image_not_supported_outlined, size: iconSize),
    );
  }
  return Icon(Icons.image_outlined, size: iconSize);
}

String? _assetPath(String imageRef) {
  if (!imageRef.startsWith('asset:')) return null;
  final key = imageRef.substring('asset:'.length);
  if (key.isEmpty) return null;
  return 'assets/style_figures/$key.png';
}
