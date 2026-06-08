/// Bundled PNG under [kStyleFigureAssetPrefix] or user file under app documents.
abstract final class StyleFigureImageRef {
  static const assetPrefix = 'asset:';
  static const filePrefix = 'file:';

  static const waistcoatAssetPrefix = 'asset:wc:';

  static String bundledAssetKey(int shapeNumber) =>
      '${assetPrefix}shape_$shapeNumber';

  static String waistcoatAssetKey(String relativePathWithoutExt) =>
      '$waistcoatAssetPrefix$relativePathWithoutExt';

  /// Bundled PNG index from refs like [assetPrefix]shape_3, or null.
  static int? bundledShapeNumber(String imageRef) {
    if (!imageRef.startsWith(assetPrefix)) return null;
    final key = imageRef.substring(assetPrefix.length);
    if (!key.startsWith('shape_')) return null;
    return int.tryParse(key.substring('shape_'.length));
  }

  static bool isBundledAssetRef(String imageRef) =>
      bundledShapeNumber(imageRef) != null ||
      isWaistcoatBundledAssetRef(imageRef);

  static bool isWaistcoatBundledAssetRef(String imageRef) =>
      imageRef.startsWith(waistcoatAssetPrefix);

  static String? waistcoatAssetPathFromRef(String imageRef) {
    if (!imageRef.startsWith(waistcoatAssetPrefix)) return null;
    final rel = imageRef.substring(waistcoatAssetPrefix.length);
    if (rel.isEmpty) return null;
    return 'assets/style_figures_waistcoat/$rel.png';
  }

  static String? assetPathFromRef(String imageRef) {
    final waistcoat = waistcoatAssetPathFromRef(imageRef);
    if (waistcoat != null) return waistcoat;
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
