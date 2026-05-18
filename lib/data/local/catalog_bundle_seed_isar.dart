import 'package:flutter/services.dart';
import 'package:isar/isar.dart';

import '../../features/catalog/catalog_storage_stub.dart'
    if (dart.library.io) '../../features/catalog/catalog_storage_io.dart';
import 'catalog/catalog_image_ref.dart';
import 'catalog_bundle_seed.dart';
import 'entities/catalog_item_entity.dart';

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
  await _repairCatalogBundleAssetRefs(isar);
}

/// Re-materializes bundled rows still pointing at [asset:catalog_seed/] refs
/// (e.g. after JPEG → PNG asset rename or a failed first-run copy).
Future<void> _repairCatalogBundleAssetRefs(Isar isar) async {
  for (final entry in catalogBundleSeedEntries) {
    final existing =
        await isar.catalogItemEntitys.getByInternalId(entry.internalId);
    if (existing == null) continue;

    final imageIsAsset = isCatalogAssetImageRef(existing.imagePath);
    final thumbIsAsset = isCatalogAssetImageRef(existing.thumbnailPath);
    if (!imageIsAsset && !thumbIsAsset) continue;

    final paths = await _materializeBundleAsset(entry.assetFileName);
    if (isCatalogAssetImageRef(paths.imagePath)) continue;

    existing
      ..imagePath = paths.imagePath
      ..thumbnailPath = paths.thumbnailPath
      ..updatedAt = DateTime.now();

    await isar.writeTxn(() async {
      await isar.catalogItemEntitys.putByInternalId(existing);
    });
  }
}
