import 'dart:async';

import 'catalog_item_summary.dart';
import 'catalog_item_detail.dart';
import 'catalog_repository.dart';
import 'dev_shop_constants.dart';
import 'catalog_bundle_seed.dart';
import 'sync_pull_payload.dart';
import 'package:uuid/uuid.dart';

class MemoryCatalogRepository implements CatalogRepository {
  final List<CatalogItemSummary> _items = [];
  final List<CatalogItemDetail> _details = [];
  final _controller = StreamController<List<void>>.broadcast();
  final _uuid = const Uuid();

  @override
  Future<void> seedIfEmpty() async {
    if (_items.isEmpty) {
      final now = DateTime.now();
      final seed = [
        CatalogItemDetail(
          internalId: 'cat-1',
          shopId: kDevShopId,
          designName: 'Classic Suit',
          designerShopName: 'My Shop',
          createdAt: now,
          updatedAt: now,
          isSharedPublic: false,
          notes: null,
        ),
        CatalogItemDetail(
          internalId: 'cat-2',
          shopId: kDevShopId,
          designName: 'Modern Kameez',
          designerShopName: 'My Shop',
          createdAt: now.subtract(const Duration(days: 2)),
          updatedAt: now.subtract(const Duration(days: 2)),
          isSharedPublic: true,
          notes: 'Shared design (dev seed).',
        ),
      ];
      _details.addAll(seed);
      _items.addAll(seed.map(_toSummary));
    }
    _ensureCommunity();
    _ensureBundleDesigns();
  }

  void _ensureBundleDesigns() {
    final now = DateTime.now();
    var added = false;
    for (final row in catalogBundleMemorySeedRows()) {
      if (_details.any((x) => x.internalId == row.internalId)) continue;
      final detail = CatalogItemDetail(
        internalId: row.internalId,
        shopId: kDevShopId,
        designName: row.designName,
        designerShopName: row.designerShopName,
        createdAt: now,
        updatedAt: now,
        isSharedPublic: false,
        imagePath: row.imagePath,
        thumbnailPath: row.thumbnailPath,
        notes: null,
      );
      _details.add(detail);
      _items.add(_toSummary(detail));
      added = true;
    }
    if (added) _emit();
  }

  void _ensureCommunity() {
    final now = DateTime.now();
    final community = [
      CatalogItemDetail(
        internalId: 'cat-community-1',
        shopId: kDevCommunityCatalogShopId,
        designName: 'Embroidered vest (sample)',
        designerShopName: 'Kabul Tailors Co-op',
        createdAt: now.subtract(const Duration(days: 5)),
        updatedAt: now.subtract(const Duration(days: 5)),
        isSharedPublic: true,
        notes: 'Sample entry from the shared directory (offline demo).',
      ),
      CatalogItemDetail(
        internalId: 'cat-community-2',
        shopId: kDevCommunityCatalogShopId,
        designName: 'Wedding Perahan',
        designerShopName: 'Herat Fine Stitch',
        createdAt: now.subtract(const Duration(days: 1)),
        updatedAt: now.subtract(const Duration(days: 1)),
        isSharedPublic: true,
        notes: 'Metadata only in demo; images arrive with P2P sync.',
      ),
    ];
    var added = false;
    for (final d in community) {
      if (_details.any((x) => x.internalId == d.internalId)) continue;
      _details.add(d);
      _items.add(_toSummary(d));
      added = true;
    }
    if (added) _emit();
  }

  @override
  Stream<List<CatalogItemSummary>> watchMyDesigns([String shopId = kDevShopId]) async* {
    await seedIfEmpty();
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) => _sortedForShop(shopId));
  }

  @override
  Stream<List<CatalogItemSummary>> watchCommunityDesigns(
      [String myShopId = kDevShopId]) async* {
    await seedIfEmpty();
    yield _communitySorted(myShopId);
    yield* _controller.stream.map((_) => _communitySorted(myShopId));
  }

  List<CatalogItemSummary> _sortedForShop(String shopId) {
    final list = _items.where((i) => i.shopId == shopId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  List<CatalogItemSummary> _communitySorted(String myShopId) {
    final list = _items.where((i) => i.shopId != myShopId).toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return list;
  }

  void _emit() => _controller.add(const []);

  CatalogItemSummary _toSummary(CatalogItemDetail d) => CatalogItemSummary(
        internalId: d.internalId,
        shopId: d.shopId,
        designName: d.designName,
        designerShopName: d.designerShopName,
        createdAt: d.createdAt,
        isSharedPublic: d.isSharedPublic,
        imagePath: d.imagePath,
        thumbnailPath: d.thumbnailPath,
      );

  @override
  Stream<CatalogItemDetail?> watchItem(String internalId) async* {
    await seedIfEmpty();
    yield _details
        .where((d) => d.internalId == internalId)
        .cast<CatalogItemDetail?>()
        .firstWhere((d) => d != null, orElse: () => null);
    yield* _controller.stream.map((_) {
      return _details
          .where((d) => d.internalId == internalId)
          .cast<CatalogItemDetail?>()
          .firstWhere((d) => d != null, orElse: () => null);
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
    await seedIfEmpty();
    final id = _uuid.v4();
    final now = DateTime.now();
    final next = CatalogItemDetail(
      internalId: id,
      shopId: shopId,
      designName: designName,
      designerShopName: designerShopName,
      createdAt: now,
      updatedAt: now,
      isSharedPublic: isSharedPublic,
      notes: notes,
      imagePath: imagePath,
      thumbnailPath: thumbnailPath,
    );
    _details.add(next);
    _items.add(_toSummary(next));
    _emit();
    return id;
  }

  @override
  Future<void> updateMetadata({
    required String internalId,
    required String designName,
    String? notes,
  }) async {
    for (var i = 0; i < _details.length; i++) {
      final d = _details[i];
      if (d.internalId != internalId) continue;
      final next = CatalogItemDetail(
        internalId: d.internalId,
        shopId: d.shopId,
        designName: designName,
        designerShopName: d.designerShopName,
        createdAt: d.createdAt,
        updatedAt: DateTime.now(),
        isSharedPublic: d.isSharedPublic,
        notes: notes,
        imagePath: d.imagePath,
        thumbnailPath: d.thumbnailPath,
      );
      _details[i] = next;
      final idx = _items.indexWhere((s) => s.internalId == internalId);
      if (idx >= 0) _items[idx] = _toSummary(next);
      _emit();
      return;
    }
  }

  @override
  Future<void> setSharedPublic({
    required String internalId,
    required bool isSharedPublic,
  }) async {
    for (var i = 0; i < _details.length; i++) {
      final d = _details[i];
      if (d.internalId != internalId) continue;
      final next = CatalogItemDetail(
        internalId: d.internalId,
        shopId: d.shopId,
        designName: d.designName,
        designerShopName: d.designerShopName,
        createdAt: d.createdAt,
        updatedAt: DateTime.now(),
        isSharedPublic: isSharedPublic,
        notes: d.notes,
        imagePath: d.imagePath,
        thumbnailPath: d.thumbnailPath,
      );
      _details[i] = next;
      final idx = _items.indexWhere((s) => s.internalId == internalId);
      if (idx >= 0) _items[idx] = _toSummary(next);
      _emit();
      return;
    }
  }

  @override
  Future<void> softDelete(String internalId) async {
    _details.removeWhere((d) => d.internalId == internalId);
    _items.removeWhere((s) => s.internalId == internalId);
    _emit();
  }

  @override
  Future<void> mergeRemoteCatalogItem({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    await seedIfEmpty();
    if (operation == 'delete') {
      await softDelete(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final designName = syncPullString(m, const ['design_name', 'designName']);
    if (designName == null || designName.trim().isEmpty) return;
    final designerShopName = syncPullString(m, const [
          'designer_shop_name',
          'designerShopName',
        ]) ??
        '';
    final notes = syncPullString(m, const ['notes']);
    final isShared =
        syncPullBool(m, const ['is_shared_public', 'isSharedPublic']) ?? false;
    final created =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();
    final updated =
        syncPullDateTime(m, const ['updated_at', 'updatedAt']) ?? DateTime.now();
    final imagePath = syncPullString(m, const ['image_path', 'imagePath']);
    final thumbPath =
        syncPullString(m, const ['thumbnail_path', 'thumbnailPath']);

    final idx = _details.indexWhere((d) => d.internalId == internalId);
    if (idx == -1) {
      final d = CatalogItemDetail(
        internalId: internalId,
        shopId: shopId,
        designName: designName.trim(),
        designerShopName: designerShopName.trim().isEmpty
            ? designName.trim()
            : designerShopName.trim(),
        createdAt: created,
        updatedAt: updated,
        isSharedPublic: isShared,
        notes: notes,
        imagePath: imagePath,
        thumbnailPath: thumbPath,
      );
      _details.add(d);
      _items.add(_toSummary(d));
    } else {
      final prev = _details[idx];
      final next = CatalogItemDetail(
        internalId: prev.internalId,
        shopId: shopId,
        designName: designName.trim(),
        designerShopName: designerShopName.trim().isEmpty
            ? prev.designerShopName
            : designerShopName.trim(),
        createdAt: prev.createdAt,
        updatedAt: updated,
        isSharedPublic: isShared,
        notes: notes ?? prev.notes,
        imagePath: imagePath ?? prev.imagePath,
        thumbnailPath: thumbPath ?? prev.thumbnailPath,
      );
      _details[idx] = next;
      final si = _items.indexWhere((s) => s.internalId == internalId);
      if (si >= 0) _items[si] = _toSummary(next);
    }
    _emit();
  }
}

