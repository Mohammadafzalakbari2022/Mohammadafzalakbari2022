import 'dart:async';

import 'package:uuid/uuid.dart';

import '../../core/validation/afghan_phone_input.dart';
import 'customer_display_no.dart';
import 'customer_list_repository.dart';
import 'customer_name_rules.dart';
import 'customer_repository_exception.dart';
import 'customer_summary.dart';
import 'customer_uniqueness.dart';
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

  static String? _optPhone(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    final digits = normalizeAfghanPhoneDigits(v.trim());
    return digits.isEmpty ? null : digits;
  }

  List<CustomerSummary> _activeCustomersForShop(String shopId) {
    return _customers
        .where(
          (c) => c.shopId == shopId && !_softDeletedIds.contains(c.internalId),
        )
        .toList(growable: false);
  }

  void _backfillDisplayCustomerNos(String shopId) {
    final needs = _customers
        .where(
          (c) =>
              c.shopId == shopId &&
              !_softDeletedIds.contains(c.internalId) &&
              parseStoredDisplayCustomerNo(c.displayCustomerNo) == 0,
        )
        .toList();
    if (needs.isEmpty) return;

    needs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    var max = 0;
    for (final c in _customers) {
      if (c.shopId != shopId || _softDeletedIds.contains(c.internalId)) {
        continue;
      }
      final n = parseStoredDisplayCustomerNo(c.displayCustomerNo);
      if (n > max) max = n;
    }

    for (final c in needs) {
      max++;
      final idx = _customers.indexWhere((x) => x.internalId == c.internalId);
      if (idx < 0) continue;
      final prev = _customers[idx];
      _customers[idx] = CustomerSummary(
        shopId: prev.shopId,
        internalId: prev.internalId,
        name: prev.name,
        displayCustomerNo: formatStoredDisplayCustomerNo(max),
        phone: prev.phone,
        address: prev.address,
        notes: prev.notes,
        lastCatalogDesignName: prev.lastCatalogDesignName,
        lastCatalogThumbnailPath: prev.lastCatalogThumbnailPath,
        lastCatalogItemInternalId: prev.lastCatalogItemInternalId,
        lastCatalogDesignerShopName: prev.lastCatalogDesignerShopName,
        createdAt: prev.createdAt,
      );
    }
  }

  int _nextDisplayCustomerNo(String shopId) {
    _backfillDisplayCustomerNos(shopId);
    return nextDisplayCustomerNoFromSummaries(
      _customers.where(
        (c) => c.shopId == shopId && !_softDeletedIds.contains(c.internalId),
      ),
      shopId,
    );
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
          displayCustomerNo: '00000001',
          phone: '0700000001',
          address: 'Kabul',
          notes: 'Prefers Friday fittings',
          createdAt: DateTime(2024, 6, 1),
        ),
        CustomerSummary(
          shopId: kDevShopId,
          internalId: DevSeedIds.customer2,
          name: 'Sara Mohseni',
          displayCustomerNo: '00000002',
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
    _backfillDisplayCustomerNos(shopId);
    yield _sortedForShop(shopId);
    yield* _controller.stream.map((_) {
      _backfillDisplayCustomerNos(shopId);
      return _sortedForShop(shopId);
    });
  }

  List<CustomerSummary> _sortedForShop(String shopId) {
    final list = _customers
        .where(
          (c) => c.shopId == shopId && !_softDeletedIds.contains(c.internalId),
        )
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
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
    assertValidCustomerName(name);
    final trimmedName = name.trim();
    final phoneNorm = _optPhone(phone);
    assertCustomerUniqueInShop(
      customers: _activeCustomersForShop(shopId),
      shopId: shopId,
      name: trimmedName,
      phone: phoneNorm,
    );
    final id = _uuid.v4();
    final createdAt = DateTime.now();
    final nextNo = _nextDisplayCustomerNo(shopId);
    _customers.add(
      CustomerSummary(
        shopId: shopId,
        internalId: id,
        name: trimmedName,
        displayCustomerNo: formatStoredDisplayCustomerNo(nextNo),
        phone: phoneNorm,
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
    assertValidCustomerName(name);
    final trimmedName = name.trim();
    final phoneNorm = _optPhone(phone);
    for (var i = 0; i < _customers.length; i++) {
      if (_customers[i].internalId != internalId) continue;
      final prev = _customers[i];
      assertCustomerUniqueInShop(
        customers: _activeCustomersForShop(prev.shopId),
        shopId: prev.shopId,
        name: trimmedName,
        phone: phoneNorm,
        excludeInternalId: internalId,
      );
      _customers[i] = CustomerSummary(
        shopId: prev.shopId,
        internalId: internalId,
        name: trimmedName,
        displayCustomerNo: prev.displayCustomerNo,
        phone: phoneNorm,
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
        displayCustomerNo: prev.displayCustomerNo,
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
    final remoteDisplayNo = syncPullString(
      m,
      const ['display_customer_no', 'displayCustomerNo'],
    );
    final trimmedName = name.trim();
    final phoneNorm = _optPhone(syncPullString(m, const ['phone']));
    try {
      assertCustomerUniqueInShop(
        customers: _activeCustomersForShop(shopId),
        shopId: shopId,
        name: trimmedName,
        phone: phoneNorm,
        excludeInternalId: internalId,
      );
    } on CustomerRepositoryException {
      return;
    }
    _softDeletedIds.remove(internalId);
    for (var i = 0; i < _customers.length; i++) {
      if (_customers[i].internalId != internalId) continue;
      final prev = _customers[i];
      final resolvedDisplayNo =
          (remoteDisplayNo != null &&
                  parseStoredDisplayCustomerNo(remoteDisplayNo) > 0)
              ? remoteDisplayNo
              : (parseStoredDisplayCustomerNo(prev.displayCustomerNo) > 0
                  ? prev.displayCustomerNo
                  : formatStoredDisplayCustomerNo(_nextDisplayCustomerNo(shopId)));
      _customers[i] = CustomerSummary(
        shopId: shopId,
        internalId: internalId,
        name: trimmedName,
        displayCustomerNo: resolvedDisplayNo,
        phone: phoneNorm,
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
    var displayNo = remoteDisplayNo?.trim() ?? '';
    if (parseStoredDisplayCustomerNo(displayNo) == 0) {
      displayNo = formatStoredDisplayCustomerNo(_nextDisplayCustomerNo(shopId));
    }
    _customers.add(
      CustomerSummary(
        shopId: shopId,
        internalId: internalId,
        name: trimmedName,
        displayCustomerNo: displayNo,
        phone: phoneNorm,
        address: _opt(syncPullString(m, const ['address'])),
        notes: _opt(syncPullString(m, const ['notes'])),
        createdAt: createdAt,
      ),
    );
    _emit();
  }
}
