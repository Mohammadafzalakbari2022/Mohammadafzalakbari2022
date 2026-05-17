import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../../features/catalog/catalog_storage_stub.dart'
    if (dart.library.io) '../../features/catalog/catalog_storage_io.dart';
import 'catalog/catalog_image_ref.dart';
import 'entities/catalog_item_entity.dart';

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
    this.designerShopName = 'Afghan Pride',
  });

  final String internalId;
  final String assetFileName;
  final String designName;
  final String designerShopName;
}

const catalogBundleSeedEntries = <CatalogBundleSeedEntry>[
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design1,
    assetFileName: 'design_1.jpeg',
    designName: 'Classic Perahan',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design2,
    assetFileName: 'design_2.jpeg',
    designName: 'Modern Kameez',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design3,
    assetFileName: 'design_3.jpeg',
    designName: 'Formal Suit',
  ),
  CatalogBundleSeedEntry(
    internalId: CatalogBundleSeedIds.design4,
    assetFileName: 'design_4.jpeg',
    designName: 'Wedding Coat',
  ),
];

/// Materializes bundled catalog images from [assets/catalog_seed/].
Future<({String? imagePath, String? thumbnailPath})> _materializeBundleAsset(
  String assetFileName,
) async {
  try {
    final bytes =
        await rootBundle.load('assets/catalog_seed/$assetFileName');
    final stored = await storeCatalogImage(bytes.buffer.asUint8List());
    return (imagePath: stored.imagePath, thumbnailPath: stored.thumbnailPath);
  } catch (_) {
    final ref = catalogAssetRefFromBundleFile(assetFileName);
    return (imagePath: ref, thumbnailPath: ref);
  }
}

/// Inserts bundled catalog rows on first run only (user may edit/delete later).
Future<void> seedCatalogBundleIfMissing(Isar isar, String shopId) async {
  final now = DateTime.now();
  for (final entry in catalogBundleSeedEntries) {
    final existing =
        await isar.catalogItemEntitys.getByInternalId(entry.internalId);
    if (existing != null) continue;

    final paths = await _materializeBundleAsset(entry.assetFileName);

    final e = CatalogItemEntity()
      ..internalId = entry.internalId
      ..shopId = shopId
      ..designName = entry.designName
      ..designerShopName = entry.designerShopName
      ..imagePath = paths.imagePath
      ..thumbnailPath = paths.thumbnailPath
      ..isSharedPublic = false
      ..createdAt = now
      ..updatedAt = now;

    await isar.writeTxn(() async {
      await isar.catalogItemEntitys.putByInternalId(e);
    });
  }
}

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
