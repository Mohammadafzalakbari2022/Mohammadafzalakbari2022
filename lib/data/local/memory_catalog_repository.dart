import 'dart:async';

import 'catalog_item_summary.dart';
import 'catalog_item_detail.dart';
import 'catalog_repository.dart';
import 'dev_shop_constants.dart';
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
}

