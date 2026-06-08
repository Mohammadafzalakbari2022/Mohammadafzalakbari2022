import 'package:isar/isar.dart';
import 'package:uuid/uuid.dart';

import 'customer_display_no.dart';
import 'customer_list_repository.dart';
import 'customer_summary.dart';
import 'dev_shop_constants.dart';
import 'entities/customer_entity.dart';
import 'sync_pull_payload.dart';

class IsarCustomerRepository implements CustomerListRepository {
  IsarCustomerRepository(this._isar);

  final Isar _isar;
  final _uuid = const Uuid();

  static String? _opt(String? v) {
    if (v == null || v.trim().isEmpty) return null;
    return v.trim();
  }

  CustomerSummary _toSummary(CustomerEntity c) {
    return CustomerSummary(
      shopId: c.shopId,
      internalId: c.internalId,
      name: c.name,
      displayCustomerNo: c.displayCustomerNo,
      phone: c.phone,
      address: c.address,
      notes: c.notes,
      lastCatalogDesignName: c.lastCatalogDesignName,
      lastCatalogThumbnailPath: c.lastCatalogThumbnailPath,
      lastCatalogItemInternalId: c.lastCatalogItemInternalId,
      lastCatalogDesignerShopName: c.lastCatalogDesignerShopName,
      createdAt: c.createdAt,
    );
  }

  Future<void> _backfillDisplayCustomerNos(String shopId) async {
    final rows = await _isar.customerEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    final needs = rows
        .where((r) => parseStoredDisplayCustomerNo(r.displayCustomerNo) == 0)
        .toList();
    if (needs.isEmpty) return;

    needs.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    var max = 0;
    for (final r in rows) {
      final n = parseStoredDisplayCustomerNo(r.displayCustomerNo);
      if (n > max) max = n;
    }

    await _isar.writeTxn(() async {
      for (final r in needs) {
        max++;
        r.displayCustomerNo = formatStoredDisplayCustomerNo(max);
        await _isar.customerEntitys.putByInternalId(r);
      }
    });
  }

  Future<int> _nextDisplayCustomerNo(String shopId) async {
    await _backfillDisplayCustomerNos(shopId);
    final rows = await _isar.customerEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .findAll();
    return nextDisplayCustomerNoFromSummaries(rows.map(_toSummary), shopId);
  }

  @override
  Future<void> seedIfEmpty() async {
    // Seed happens in IsarOrderRepository so customers exist together with orders.
    // Keep this no-op so callers can always invoke seedIfEmpty() safely.
    if (await _isar.customerEntitys.count() == 0) {
      // no-op
    }
  }

  @override
  Stream<List<CustomerSummary>> watchCustomers([String shopId = kDevShopId]) {
    final query = _isar.customerEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .and()
        .deletedAtIsNull()
        .sortByCreatedAtDesc()
        .watch(fireImmediately: true);

    return query.asyncMap((rows) async {
      await _backfillDisplayCustomerNos(shopId);
      final refreshed = await _isar.customerEntitys
          .filter()
          .shopIdEqualTo(shopId)
          .and()
          .deletedAtIsNull()
          .sortByCreatedAtDesc()
          .findAll();
      return refreshed.map(_toSummary).toList();
    });
  }

  @override
  Future<String> createCustomer({
    required String shopId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    final id = _uuid.v4();
    final now = DateTime.now();
    final nextNo = await _nextDisplayCustomerNo(shopId);
    final e = CustomerEntity()
      ..internalId = id
      ..shopId = shopId
      ..name = name.trim()
      ..displayCustomerNo = formatStoredDisplayCustomerNo(nextNo)
      ..phone = _opt(phone)
      ..address = _opt(address)
      ..notes = _opt(notes)
      ..createdAt = now;

    await _isar.writeTxn(() async {
      await _isar.customerEntitys.putByInternalId(e);
    });
    return id;
  }

  Future<CustomerEntity?> getByInternalId(String id) {
    return _isar.customerEntitys.getByInternalId(id);
  }

  @override
  Future<void> updateCustomer({
    required String internalId,
    required String name,
    String? phone,
    String? address,
    String? notes,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null || existing.deletedAt != null) return;
      existing.name = name.trim();
      existing.phone = _opt(phone);
      existing.address = _opt(address);
      existing.notes = _opt(notes);
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> updateCustomerLastCatalogDesign({
    required String internalId,
    required String designName,
    String? designerShopName,
    String? catalogItemInternalId,
    String? thumbnailPath,
  }) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null || existing.deletedAt != null) return;
      existing
        ..lastCatalogDesignName = designName.trim()
        ..lastCatalogDesignerShopName = designerShopName?.trim() ?? ''
        ..lastCatalogItemInternalId = catalogItemInternalId
        ..lastCatalogThumbnailPath = thumbnailPath;
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> softDeleteCustomer(String internalId) async {
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null || existing.deletedAt != null) return;
      existing.deletedAt = DateTime.now();
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }

  @override
  Future<void> mergeRemoteCustomer({
    required String shopId,
    required String internalId,
    required String operation,
    Object? data,
  }) async {
    if (operation == 'delete') {
      await softDeleteCustomer(internalId);
      return;
    }
    final m = syncPullDataMap(data);
    final name = syncPullString(m, const ['name']);
    if (name == null || name.trim().isEmpty) return;
    final createdAt =
        syncPullDateTime(m, const ['created_at', 'createdAt']) ?? DateTime.now();
    final lastCatalogDesignName = syncPullString(
          m,
          const ['last_catalog_design_name', 'lastCatalogDesignName'],
        ) ??
        '';
    final lastCatalogDesignerShopName = syncPullString(
          m,
          const [
            'last_catalog_designer_shop_name',
            'lastCatalogDesignerShopName',
          ],
        ) ??
        '';
    final lastCatalogItemInternalId = syncPullString(
      m,
      const ['last_catalog_item_internal_id', 'lastCatalogItemInternalId'],
    );
    final lastCatalogThumbnailPath = syncPullString(
      m,
      const ['last_catalog_thumbnail_path', 'lastCatalogThumbnailPath'],
    );
    final remoteDisplayNo = syncPullString(
      m,
      const ['display_customer_no', 'displayCustomerNo'],
    );
    await _isar.writeTxn(() async {
      final existing = await _isar.customerEntitys.getByInternalId(internalId);
      if (existing == null) {
        var displayNo = remoteDisplayNo?.trim() ?? '';
        if (parseStoredDisplayCustomerNo(displayNo) == 0) {
          final nextNo = await _nextDisplayCustomerNo(shopId);
          displayNo = formatStoredDisplayCustomerNo(nextNo);
        }
        final e = CustomerEntity()
          ..internalId = internalId
          ..shopId = shopId
          ..name = name.trim()
          ..displayCustomerNo = displayNo
          ..phone = _opt(syncPullString(m, const ['phone']))
          ..address = _opt(syncPullString(m, const ['address']))
          ..notes = _opt(syncPullString(m, const ['notes']))
          ..lastCatalogDesignName = lastCatalogDesignName
          ..lastCatalogDesignerShopName = lastCatalogDesignerShopName
          ..lastCatalogItemInternalId = lastCatalogItemInternalId
          ..lastCatalogThumbnailPath = lastCatalogThumbnailPath
          ..createdAt = createdAt
          ..deletedAt = null;
        await _isar.customerEntitys.putByInternalId(e);
        return;
      }
      final mergedDisplayNo = remoteDisplayNo?.trim();
      final resolvedDisplayNo =
          (mergedDisplayNo != null &&
                  parseStoredDisplayCustomerNo(mergedDisplayNo) > 0)
              ? mergedDisplayNo
              : (parseStoredDisplayCustomerNo(existing.displayCustomerNo) > 0
                  ? existing.displayCustomerNo
                  : formatStoredDisplayCustomerNo(
                      await _nextDisplayCustomerNo(shopId),
                    ));
      existing
        ..shopId = shopId
        ..name = name.trim()
        ..displayCustomerNo = resolvedDisplayNo
        ..phone = _opt(syncPullString(m, const ['phone']))
        ..address = _opt(syncPullString(m, const ['address']))
        ..notes = _opt(syncPullString(m, const ['notes']))
        ..lastCatalogDesignName = lastCatalogDesignName.isNotEmpty
            ? lastCatalogDesignName
            : existing.lastCatalogDesignName
        ..lastCatalogDesignerShopName =
            lastCatalogDesignerShopName.isNotEmpty
                ? lastCatalogDesignerShopName
                : existing.lastCatalogDesignerShopName
        ..lastCatalogItemInternalId =
            lastCatalogItemInternalId ?? existing.lastCatalogItemInternalId
        ..lastCatalogThumbnailPath =
            lastCatalogThumbnailPath ?? existing.lastCatalogThumbnailPath
        ..deletedAt = null;
      await _isar.customerEntitys.putByInternalId(existing);
    });
  }
}
