import 'dart:io';

import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';

import '../../../data/local/style/style_figure_image_ref.dart';

Widget buildStyleFigureImage({
  required String imageRef,
  double? size,
  BoxFit fit = BoxFit.contain,
}) {
  final iconSize = (size ?? 48) * 0.5;
  final asset = StyleFigureImageRef.assetPathFromRef(imageRef);
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
          errorBuilder: (_, _, _) =>
              Icon(Icons.broken_image_outlined, size: iconSize),
        );
      },
    );
  }
  return Icon(Icons.image_outlined, size: iconSize);
}

Future<File?> _fileForRelative(String rel) async {
  final dir = await getApplicationDocumentsDirectory();
  final path = rel.replaceAll('/', Platform.pathSeparator);
  return File('${dir.path}${Platform.pathSeparator}$path');
}
