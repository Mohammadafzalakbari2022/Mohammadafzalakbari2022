/// Prefix for bundled catalog seed images (web + before IO materialization).
const String kCatalogAssetRefPrefix = 'asset:catalog_seed/';

bool isCatalogAssetImageRef(String? path) {
  if (path == null || path.isEmpty) return false;
  return path.startsWith(kCatalogAssetRefPrefix);
}

String catalogAssetRefFromBundleFile(String fileName) {
  return '$kCatalogAssetRefPrefix$fileName';
}

String? catalogBundleAssetPath(String? imageRef) {
  if (!isCatalogAssetImageRef(imageRef)) return null;
  return imageRef!.substring(kCatalogAssetRefPrefix.length);
}
