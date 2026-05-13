import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'catalog_item_detail.dart';
import 'catalog_item_summary.dart';
import 'catalog_repository.dart';
import 'dev_shop_constants.dart';
import 'entities/catalog_item_entity.dart';

class IsarCatalogRepository implements CatalogRepository {
  IsarCatalogRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  @override
  Future<void> seedIfEmpty() async {
    if (await _isar.catalogItemEntitys.count() == 0) {
      final now = DateTime.now();
      final items = [
        CatalogItemEntity()
          ..internalId = 'cat-1'
          ..shopId = kDevShopId
          ..designName = 'Classic Suit'
          ..designerShopName = 'My Shop'
          ..createdAt = now
          ..updatedAt = now
          ..isSharedPublic = false,
        CatalogItemEntity()
          ..internalId = 'cat-2'
          ..shopId = kDevShopId
          ..designName = 'Modern Kameez'
          ..designerShopName = 'My Shop'
          ..createdAt = now.subtract(const Duration(days: 2))
          ..updatedAt = now.subtract(const Duration(days: 2))
          ..isSharedPublic = true,
      ];
      await _isar.writeTxn(() async {
        await _isar.catalogItemEntitys.putAll(items);
      });
    }
    await _ensureCommunityCatalog();
  }

  Future<void> _ensureCommunityCatalog() async {
    final now = DateTime.now();
    final community = [
      CatalogItemEntity()
        ..internalId = 'cat-community-1'
        ..shopId = kDevCommunityCatalogShopId
        ..designName = 'Embroidered vest (sample)'
        ..designerShopName = 'Kabul Tailors Co-op'
        ..notes = 'Sample entry from the shared directory (offline demo).'
        ..createdAt = now.subtract(const Duration(days: 5))
        ..updatedAt = now.subtract(const Duration(days: 5))
        ..isSharedPublic = true,
      CatalogItemEntity()
        ..internalId = 'cat-community-2'
        ..shopId = kDevCommunityCatalogShopId
        ..designName = 'Wedding Perahan'
        ..designerShopName = 'Herat Fine Stitch'
        ..notes = 'Metadata only in demo; images arrive with P2P sync.'
        ..createdAt = now.subtract(const Duration(days: 1))
        ..updatedAt = now.subtract(const Duration(days: 1))
        ..isSharedPublic = true,
    ];
    await _isar.writeTxn(() async {
      for (final e in community) {
        final existing =
            await _isar.catalogItemEntitys.getByInternalId(e.internalId);
        if (existing == null) {
          await _isar.catalogItemEntitys.putByInternalId(e);
        }
      }
    });
  }

  CatalogItemSummary _summaryFromEntity(CatalogItemEntity c) {
    return CatalogItemSummary(
      internalId: c.internalId,
      shopId: c.shopId,
      designName: c.designName,
      designerShopName: c.designerShopName,
      createdAt: c.createdAt,
      isSharedPublic: c.isSharedPublic,
      imagePath: c.imagePath,
      thumbnailPath: c.thumbnailPath,
    );
  }

  @override
  Stream<List<CatalogItemSummary>> watchMyDesigns([String shopId = kDevShopId]) {
    return _isar.catalogItemEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (rows) => rows.map(_summaryFromEntity).toList(),
        );
  }

  @override
  Stream<List<CatalogItemSummary>> watchCommunityDesigns(
      [String myShopId = kDevShopId]) {
    return _isar.catalogItemEntitys
        .where()
        .shopIdNotEqualTo(myShopId)
        .filter()
        .deletedAtIsNull()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true)
        .map(
          (rows) => rows.map(_summaryFromEntity).toList(),
        );
  }

  @override
  Stream<CatalogItemDetail?> watchItem(String internalId) {
    return _isar.catalogItemEntitys
        .filter()
        .internalIdEqualTo(internalId)
        .and()
        .deletedAtIsNull()
        .watch(fireImmediately: true)
        .map((rows) {
      final e = rows.isEmpty ? null : rows.first;
      if (e == null) return null;
      return CatalogItemDetail(
        internalId: e.internalId,
        shopId: e.shopId,
        designName: e.designName,
        designerShopName: e.designerShopName,
        createdAt: e.createdAt,
        updatedAt: e.updatedAt,
        isSharedPublic: e.isSharedPublic,
        notes: e.notes,
        imagePath: e.imagePath,
        thumbnailPath: e.thumbnailPath,
      );
    });
  }

  @override
  Future<String> createItem({
    required String shopId,
    required String designName,
    required String designerShopName,
    String? notes,
    String? imagePath,
    String? thumbnailPath,
    bool isSharedPublic = false,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final e = CatalogItemEntity()
      ..internalId = id
      ..shopId = shopId
      ..designName = designName
      ..designerShopName = designerShopName
      ..notes = notes
      ..imagePath = imagePath
      ..thumbnailPath = thumbnailPath
      ..createdAt = now
      ..updatedAt = now
      ..isSharedPublic = isSharedPublic;

    await _isar.writeTxn(() async {
      await _isar.catalogItemEntitys.putByInternalId(e);
    });
    return id;
  }

  @override
  Future<void> updateMetadata({
    required String internalId,
    required String designName,
    String? notes,
  }) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.catalogItemEntitys.getByInternalId(internalId);
      if (existing == null) return;
      existing.designName = designName;
      existing.notes = notes;
      existing.updatedAt = DateTime.now();
      await _isar.catalogItemEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> setSharedPublic({
    required String internalId,
    required bool isSharedPublic,
  }) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.catalogItemEntitys.getByInternalId(internalId);
      if (existing == null) return;
      existing.isSharedPublic = isSharedPublic;
      existing.updatedAt = DateTime.now();
      await _isar.catalogItemEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> softDelete(String internalId) async {
    await _isar.writeTxn(() async {
      final existing =
          await _isar.catalogItemEntitys.getByInternalId(internalId);
      if (existing == null) return;
      existing.deletedAt = DateTime.now();
      existing.updatedAt = DateTime.now();
      await _isar.catalogItemEntitys.putByInternalId(existing);
    });
  }
}

