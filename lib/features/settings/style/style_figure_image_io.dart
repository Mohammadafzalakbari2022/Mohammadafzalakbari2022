import 'dart:io';

import 'package:flutter/material.dart';
import 'package:pride_v3/core/persistence/pride_path_provider_io.dart';

import '../../../data/local/style/style_figure_image_ref.dart';

int? _styleFigureCachePx(double? size) {
  if (size == null) return null;
  return (size * 3).round().clamp(48, 512);
}

Widget buildStyleFigureImage({
  required String imageRef,
  double? size,
  BoxFit fit = BoxFit.contain,
}) {
  final iconSize = (size ?? 48) * 0.5;
  final cachePx = _styleFigureCachePx(size);
  final asset = StyleFigureImageRef.assetPathFromRef(imageRef);
  if (asset != null) {
    return Image.asset(
      asset,
      width: size,
      height: size,
      fit: fit,
      cacheWidth: cachePx,
      cacheHeight: cachePx,
      errorBuilder: (_, _, _) =>
          Icon(Icons.image_not_supported_outlined, size: iconSize),
    );
  }
  final rel = StyleFigureImageRef.fileRelativePathFromRef(imageRef);
  if (rel != null) {
    return FutureBuilder<File?>(
      future: _fileForRelative(rel),
      builder: (context, snap) {
        final file = snap.data;
        if (file == null || !file.existsSync()) {
          return Icon(Icons.image_outlined, size: iconSize);
        }
        return Image.file(
          file,
          width: size,
          height: size,
          fit: fit,
          cacheWidth: cachePx,
          cacheHeight: cachePx,
          errorBuilder: (_, _, _) =>
              Icon(Icons.broken_image_outlined, size: iconSize),
        );
      },
    );
  }
  return Icon(Icons.image_outlined, size: iconSize);
}

Future<File?> _fileForRelative(String rel) async {
  final dir = await prideApplicationDocumentsDirectory();
  final path = rel.replaceAll('/', Platform.pathSeparator);
  return File('${dir.path}${Platform.pathSeparator}$path');
}
