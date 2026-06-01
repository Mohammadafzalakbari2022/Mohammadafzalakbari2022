import 'catalog_item_detail.dart';
import 'catalog_item_summary.dart';
import 'dev_shop_constants.dart';

abstract class CatalogRepository {
  Stream<List<CatalogItemSummary>> watchMyDesigns([String shopId = kDevShopId]);

  /// Other shops’ public listings (local seed / future sync). Excludes [myShopId].
  Stream<List<CatalogItemSummary>> watchCommunityDesigns(
      [String myShopId = kDevShopId]);

  Future<void> seedIfEmpty(String shopId);

  Stream<CatalogItemDetail?> watchItem(String internalId);

  Future<String> createItem({
    required String shopId,
    required String designName,
    required String designerShopName,
    String? notes,
    String? imagePath,
    String? thumbnailPath,
    bool isSharedPublic = false,
  });

  Future<void> updateMetadata({
    required String internalId,
    required String designName,
    required String designerShopName,
    String? notes,
  });

  Future<void> setSharedPublic({
    required String internalId,
    required bool isSharedPublic,
  });

  Future<void> softDelete(String internalId);

  /// Apply `catalog_item` from `GET /sync/pull` (`plan-03`).
  Future<void> mergeRemoteCatalogItem({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  });
}

