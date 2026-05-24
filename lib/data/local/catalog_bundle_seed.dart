import 'catalog/catalog_image_ref.dart';

/// Stable ids for bundled catalog designs shipped with the app.
abstract final class CatalogBundleSeedIds {
  static const design1 = 'cat-bundle-1';
  static const design2 = 'cat-bundle-2';
  static const design3 = 'cat-bundle-3';
  static const design4 = 'cat-bundle-4';
}

class CatalogBundleSeedEntry {
  const CatalogBundleSeedEntry({
    required this.internalId,
    required this.assetFileName,
    required this.designName,
    this.designerShopName = 'Khayat',
  });

  final String internalId;
  final String assetFileName;
  final String designName;
  final String designerShopName;
}

const catalogBundleSeedEntries = <CatalogBundleSeedEntry>[
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design1,
    assetFileName: 'design_1.png',
    designName: 'Classic Perahan',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design2,
    assetFileName: 'design_2.png',
    designName: 'Modern Kameez',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design3,
    assetFileName: 'design_3.png',
    designName: 'Formal Suit',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design4,
    assetFileName: 'design_4.png',
    designName: 'Wedding Coat',
  ),
];

/// Web memory repo: metadata + asset refs only.
List<({
  String internalId,
  String designName,
  String designerShopName,
  String imagePath,
  String? thumbnailPath,
})> catalogBundleMemorySeedRows() {
  return [
    for (final entry in catalogBundleSeedEntries)
      (
        internalId: entry.internalId,
        designName: entry.designName,
        designerShopName: entry.designerShopName,
        imagePath: catalogAssetRefFromBundleFile(entry.assetFileName),
        thumbnailPath: catalogAssetRefFromBundleFile(entry.assetFileName),
      ),
  ];
}
