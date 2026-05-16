/// Bundled PNG under [kStyleFigureAssetPrefix] or user file under app documents.
abstract final class StyleFigureImageRef {
  static const assetPrefix = 'asset:';
  static const filePrefix = 'file:';

  static String bundledAssetKey(int shapeNumber) =>
      '${assetPrefix}shape_$shapeNumber';

  static String? assetPathFromRef(String imageRef) {
    if (!imageRef.startsWith(assetPrefix)) return null;
    final key = imageRef.substring(assetPrefix.length);
    if (key.isEmpty) return null;
    return 'assets/style_figures/$key.png';
  }

  static String? fileRelativePathFromRef(String imageRef) {
    if (!imageRef.startsWith(filePrefix)) return null;
    final path = imageRef.substring(filePrefix.length);
    return path.isEmpty ? null : path;
  }
}
