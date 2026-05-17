import 'dart:async';

import 'package:uuid/uuid.dart';

import 'customer_list_repository.dart';
import 'customer_summary.dart';
import 'dev_shop_constants.dart';
import 'seed_data.dart';
import 'sync_pull_payload.dart';

/// Web: in-memory customers list (derived from seed IDs).
class MemoryCustomerRepository implements CustomerListRepository {
  final List<CustomerSummary> _customers = [];
  final Set<String> _softDeletedIds = {};
  final _controller = StreamController<List<CustomerSummary>>.broadcast();
  final _uuid = const Uuid();

  static String? _opt(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  @override
  Future<void> seedIfEmpty() async {
    if (_customers.isNotEmpty) return;
    _customers.addAll(
      [
        CustomerSummary(
          shopId: kDevShopId,
          internalId: DevSeedIds.customer1,
          name: 'Ahmad Karimi',
          phone: '0700000001',
          address: 'Kabul',
          notes: 'Prefers Friday fittings',
          createdAt: DateTime(2024, 6, 1),
        ),
        CustomerSummary(
          shopId: kDevShopId,
          internalId: DevSeedIds.customer2,
          name: 'Sara Mohseni',
          phone: '0700000002',
          address: null,
          notes: null,
          createdAt: DateTime(2024, 6, 15),
        ),
      ],
    );
  }

  @override
  Stream<List<CustomerSummary>> watchCustomers([String shopId = kDevShopId]) async* {
    await seedIfEmpty();
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) => _sortedForShop(shopId));
  }

  List<CustomerSummary> _sortedForShop(String shopId) {
    final list = _customers
        .where(
          (c) => c.shopId == shopId && !_softDeletedIds.contains(c.internalId),
        )
        .toList()
      ..sort((a, b) => a.name.compareTo(b.name));
    return list;
  }

  void _emit() => _controller.add(const []);

  @override
  Future<String> createCustomer({
    required String shopId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    await seedIfEmpty();
    final id = _uuid.v4();
    final createdAt = DateTime.now();
    _customers.add(
      CustomerSummary(
        shopId: shopId,
        internalId: id,
        name: name.trim(),
        phone: _opt(phone),
        address: _opt(address),
        notes: _opt(notes),
        createdAt: createdAt,
      ),
    );
    _emit();
    return id;
  }

  @override
  Future<void> updateCustomer({
    required String internalId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    await seedIfEmpty();
    if (_softDeletedIds.contains(internalId)) return;
    for (var i = 0; i < _customers.length; i++) {
      if (_customers[i].internalId != internalId) continue;
      final prev = _customers[i];
      _customers[i] = CustomerSummary(
        shopId: prev.shopId,
        internalId: internalId,
        name: name.trim(),
        phone: _opt(phone),
        address: _opt(address),
        notes: _opt(notes),
        lastCatalogDesignName: prev.lastCatalogDesignName,
        lastCatalogThumbnailPath: prev.lastCatalogThumbnailPath,
        lastCatalogItemInternalId: prev.lastCatalogItemInternalId,
        lastCatalogDesignerShopName: prev.lastCatalogDesignerShopName,
        createdAt: prev.createdAt,
      );
      _emit();
      return;
    }
  }

  @override
  Future<void> updateCustomerLastCatalogDesign({
    required String internalId,
    required String designName,
    String? designerShopName,
    String? catalogItemInternalId,
    String? thumbnailPath,
  }) async {
    await seedIfEmpty();
    if (_softDeletedIds.contains(internalId)) return;
    for (var i = 0; i < _customers.length; i++) {
      if (_customers[i].internalId != internalId) continue;
      final prev = _customers[i];
      _customers[i] = CustomerSummary(
        shopId: prev.shopId,
        internalId: internalId,
        name: prev.name,
        phone: prev.phone,
        address: prev.address,
        notes: prev.notes,
        lastCatalogDesignName: designName.trim(),
        lastCatalogThumbnailPath: thumbnailPath,
        lastCatalogItemInternalId: catalogItemInternalId,
        lastCatalogDesignerShopName: designerShopName?.trim() ?? '',
        createdAt: prev.createdAt,
      );
      _emit();
      return;
    }
  }

  @override
  Future<void> softDeleteCustomer(String internalId) async {
    await seedIfEmpty();
    _softDeletedIds.add(internalId);
    _emit();
  }

  @override
  Future<void> mergeRemoteCustomer({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    await seedIfEmpty();
    if (operation == 'delete') {
      await softDeleteCustomer(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null || name.trim().isEmpty) return;
    final createdAt =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();
    _softDeletedIds.remove(internalId);
    for (var i = 0; i < _customers.length; i++) {
      if (_customers[i].internalId != internalId) continue;
      final prev = _customers[i];
      _customers[i] = CustomerSummary(
        shopId: shopId,
        internalId: internalId,
        name: name.trim(),
        phone: _opt(syncPullString(m, const ['phone'])),
        address: _opt(syncPullString(m, const ['address'])),
        notes: _opt(syncPullString(m, const ['notes'])),
        lastCatalogDesignName: syncPullString(
              m,
              const ['last_catalog_design_name', 'lastCatalogDesignName'],
            ) ??
            prev.lastCatalogDesignName,
        lastCatalogThumbnailPath: syncPullString(
              m,
              const [
                'last_catalog_thumbnail_path',
                'lastCatalogThumbnailPath',
              ],
            ) ??
            prev.lastCatalogThumbnailPath,
        lastCatalogItemInternalId: syncPullString(
              m,
              const [
                'last_catalog_item_internal_id',
                'lastCatalogItemInternalId',
              ],
            ) ??
            prev.lastCatalogItemInternalId,
        lastCatalogDesignerShopName: syncPullString(
              m,
              const [
                'last_catalog_designer_shop_name',
                'lastCatalogDesignerShopName',
              ],
            ) ??
            prev.lastCatalogDesignerShopName,
        createdAt: prev.createdAt,
      );
      _emit();
      return;
    }
    _customers.add(
      CustomerSummary(
        shopId: shopId,
        internalId: internalId,
        name: name.trim(),
        phone: _opt(syncPullString(m, const ['phone'])),
        address: _opt(syncPullString(m, const ['address'])),
        notes: _opt(syncPullString(m, const ['notes'])),
        createdAt: createdAt,
      ),
    );
    _emit();
  }
}
