import 'package:flutter/material.dart';

import 'style_figure_image_stub.dart'
    if (dart.library.io) 'style_figure_image_io.dart';

class StyleFigureImage extends StatelessWidget {
  const StyleFigureImage({
    super.key,
    required this.imageRef,
    this.size = 72,
    this.fit = BoxFit.contain,
    this.expand = false,
  });

  final String imageRef;
  final double? size;
  final BoxFit fit;
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final image = buildStyleFigureImage(
      imageRef: imageRef,
      size: expand ? null : size,
      fit: fit,
    );
    if (expand) {
      return SizedBox.expand(child: image);
    }
    return image;
  }
}
