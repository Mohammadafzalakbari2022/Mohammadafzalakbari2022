import 'dart:convert';
import 'dart:io';

import 'package:isar/isar.dart';
import 'package:path_provider/path_provider.dart';

import '../local/entities/catalog_item_entity.dart';
import '../local/entities/app_notification_entity.dart';
import '../local/entities/customer_entity.dart';
import '../local/entities/measurement_profile_entity.dart';
import '../local/entities/measurement_profile_item_entity.dart';
import '../local/entities/measurement_type_entity.dart';
import '../local/entities/order_entity.dart';
import '../local/entities/order_measurement_snapshot_entity.dart';
import '../local/entities/order_measurement_snapshot_item_entity.dart';
import '../local/entities/payment_entity.dart';
import 'backup_merge_result.dart';

/// JSON backup (plan-15). Exports as [currentExportVersion]; imports v1 and v2.
abstract final class IsarBackupV1 {
  static const schemaKey = 'afghan_pride_backup';
  static const currentExportVersion = 3;
  static const minImportVersion = 1;

  static int _versionFromRoot(Map<String, dynamic> root) {
    final v = root['version'];
    if (v is int) return v;
    if (v is num) return v.toInt();
    return -1;
  }

  static void assertValidRoot(Map<String, dynamic> root) {
    if (root['schema'] != schemaKey) {
      throw const FormatException('Not an Afghan Pride backup file');
    }
    final vn = _versionFromRoot(root);
    if (vn < minImportVersion || vn > currentExportVersion) {
      throw FormatException('Unsupported backup version: ${root['version']}');
    }
  }

  static Future<Map<String, dynamic>> buildDocument(Isar isar, String shopId) async {
    final customers = await isar.customerEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final orders =
        await isar.orderEntitys.filter().shopIdEqualTo(shopId).findAll();
    final payments = await isar.paymentEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final snapshots = await isar.orderMeasurementSnapshotEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final items = await isar.orderMeasurementSnapshotItemEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final notifications = await isar.appNotificationEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final measurementTypes = await isar.measurementTypeEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final measurementProfiles = await isar.measurementProfileEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();
    final measurementProfileItems =
        await isar.measurementProfileItemEntitys
            .filter()
            .shopIdEqualTo(shopId)
            .findAll();
    final catalogItems = await isar.catalogItemEntitys
        .filter()
        .shopIdEqualTo(shopId)
        .findAll();

    final catalogAssets = <String, String>{};
    for (final c in catalogItems) {
      for (final path in [c.imagePath, c.thumbnailPath]) {
        if (path == null || path.isEmpty) continue;
        try {
          final f = File(path);
          if (!f.existsSync()) continue;
          final bytes = await f.readAsBytes();
          catalogAssets[path] = base64Encode(bytes);
        } catch (_) {
          // Skip unreadable paths on export.
        }
      }
    }

    return {
      'schema': schemaKey,
      'version': currentExportVersion,
      'exportedAt': DateTime.now().toUtc().toIso8601String(),
      'shopId': shopId,
      'measurementTypes': [
        for (final t in measurementTypes) _measurementTypeToMap(t),
      ],
      'measurementProfiles': [
        for (final p in measurementProfiles) _measurementProfileToMap(p),
      ],
      'measurementProfileItems': [
        for (final i in measurementProfileItems) _profileItemToMap(i),
      ],
      'customers': [for (final c in customers) _customerToMap(c)],
      'orders': [for (final o in orders) _orderToMap(o)],
      'payments': [for (final p in payments) _paymentToMap(p)],
      'orderMeasurementSnapshots': [
        for (final s in snapshots) _snapshotToMap(s),
      ],
      'orderMeasurementSnapshotItems': [
        for (final i in items) _snapshotItemToMap(i),
      ],
      'appNotifications': [
        for (final n in notifications) _notificationToMap(n),
      ],
      'catalogItems': [
        for (final c in catalogItems) _catalogItemToMap(c),
      ],
      'catalogAssets': catalogAssets,
    };
  }

  static String encodePretty(Map<String, dynamic> doc) =>
      const JsonEncoder.withIndent('  ').convert(doc);

  static Map<String, dynamic> decodeObject(String json) {
    final raw = jsonDecode(json);
    if (raw is! Map<String, dynamic>) {
      throw const FormatException('Backup root must be a JSON object');
    }
    assertValidRoot(raw);
    return raw;
  }

  static Future<BackupMergeResult> importMerge(
    Isar isar,
    Map<String, dynamic> root,
  ) async {
    assertValidRoot(root);
    final shopId = root['shopId'] as String? ?? '';

    var customersInserted = 0;
    var customersUpdated = 0;
    var measurementTypesUpserted = 0;
    var measurementProfilesUpserted = 0;
    var measurementProfileItemsWritten = 0;
    var ordersUpserted = 0;
    var paymentsInserted = 0;
    var paymentsSkippedExisting = 0;
    var snapshotsUpserted = 0;
    var snapshotItemsWritten = 0;
    var notificationsInserted = 0;
    var notificationsSkippedExisting = 0;

    await isar.writeTxn(() async {
      for (final raw in _asMapList(root['measurementTypes'])) {
        final e = _measurementTypeFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.measurementTypeEntitys.putByInternalId(e);
        measurementTypesUpserted++;
      }

      for (final raw in _asMapList(root['customers'])) {
        final e = _customerFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        final existing = await isar.customerEntitys.getByInternalId(e.internalId);
        if (existing == null) {
          await isar.customerEntitys.putByInternalId(e);
          customersInserted++;
        } else {
          existing.name = e.name;
          existing.phone = e.phone;
          existing.address = e.address;
          existing.notes = e.notes;
          existing.createdAt = e.createdAt;
          existing.deletedAt = e.deletedAt;
          await isar.customerEntitys.putByInternalId(existing);
          customersUpdated++;
        }
      }

      for (final raw in _asMapList(root['measurementProfiles'])) {
        final e = _measurementProfileFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.measurementProfileEntitys.putByInternalId(e);
        measurementProfilesUpserted++;
      }

      final profileItemRows = _asMapList(root['measurementProfileItems']);
      final profileIds = <String>{};
      for (final raw in profileItemRows) {
        final pid = raw['profileInternalId'] as String? ?? '';
        if (pid.isNotEmpty) profileIds.add(pid);
      }
      for (final pid in profileIds) {
        await isar.measurementProfileItemEntitys
            .filter()
            .profileInternalIdEqualTo(pid)
            .deleteAll();
      }
      for (final raw in profileItemRows) {
        final e = _profileItemFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.measurementProfileItemEntitys.put(e);
        measurementProfileItemsWritten++;
      }

      for (final raw in _asMapList(root['orders'])) {
        final e = _orderFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.orderEntitys.putByInternalId(e);
        ordersUpserted++;
      }

      for (final raw in _asMapList(root['payments'])) {
        final e = _paymentFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        final existing = await isar.paymentEntitys.getByInternalId(e.internalId);
        if (existing != null) {
          paymentsSkippedExisting++;
          continue;
        }
        await isar.paymentEntitys.putByInternalId(e);
        paymentsInserted++;
      }

      for (final raw in _asMapList(root['orderMeasurementSnapshots'])) {
        final e = _snapshotFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.orderMeasurementSnapshotEntitys.putByInternalId(e);
        snapshotsUpserted++;
      }

      final itemRows = _asMapList(root['orderMeasurementSnapshotItems']);
      final snapIds = <String>{};
      for (final raw in itemRows) {
        final sid = raw['snapshotInternalId'] as String? ?? '';
        if (sid.isNotEmpty) snapIds.add(sid);
      }
      for (final snapId in snapIds) {
        await isar.orderMeasurementSnapshotItemEntitys
            .filter()
            .snapshotInternalIdEqualTo(snapId)
            .deleteAll();
      }

      for (final raw in itemRows) {
        final e = _snapshotItemFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        await isar.orderMeasurementSnapshotItemEntitys.put(e);
        snapshotItemsWritten++;
      }

      for (final raw in _asMapList(root['appNotifications'])) {
        final e = _notificationFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        final existing =
            await isar.appNotificationEntitys.getByInternalId(e.internalId);
        if (existing != null) {
          notificationsSkippedExisting++;
          continue;
        }
        await isar.appNotificationEntitys.putByInternalId(e);
        notificationsInserted++;
      }

      final assetsRaw = root['catalogAssets'];
      final assets = assetsRaw is Map
          ? Map<String, String>.fromEntries(
              assetsRaw.entries.map(
                (e) => MapEntry('${e.key}', '${e.value}'),
              ),
            )
          : <String, String>{};

      for (final raw in _asMapList(root['catalogItems'])) {
        var e = _catalogItemFromMap(raw);
        if (shopId.isNotEmpty && e.shopId != shopId) continue;
        final imageKey = raw['imagePath'] as String?;
        final thumbKey = raw['thumbnailPath'] as String?;
        if (imageKey != null && assets.containsKey(imageKey)) {
          e.imagePath = await _restoreCatalogAssetPath(
            e.internalId,
            'full',
            assets[imageKey]!,
          );
        }
        if (thumbKey != null && assets.containsKey(thumbKey)) {
          e.thumbnailPath = await _restoreCatalogAssetPath(
            e.internalId,
            'thumb',
            assets[thumbKey]!,
          );
        }
        await isar.catalogItemEntitys.putByInternalId(e);
      }
    });

    return BackupMergeResult(
      customersInserted: customersInserted,
      customersUpdated: customersUpdated,
      measurementTypesUpserted: measurementTypesUpserted,
      measurementProfilesUpserted: measurementProfilesUpserted,
      measurementProfileItemsWritten: measurementProfileItemsWritten,
      ordersUpserted: ordersUpserted,
      paymentsInserted: paymentsInserted,
      paymentsSkippedExisting: paymentsSkippedExisting,
      snapshotsUpserted: snapshotsUpserted,
      snapshotItemsWritten: snapshotItemsWritten,
      notificationsInserted: notificationsInserted,
      notificationsSkippedExisting: notificationsSkippedExisting,
    );
  }

  static List<Map<String, dynamic>> _asMapList(Object? value) {
    if (value is! List) return [];
    final out = <Map<String, dynamic>>[];
    for (final e in value) {
      if (e is Map<String, dynamic>) {
        out.add(e);
      } else if (e is Map) {
        out.add(Map<String, dynamic>.from(e));
      }
    }
    return out;
  }

  static Map<String, dynamic> _customerToMap(CustomerEntity c) => {
        'internalId': c.internalId,
        'shopId': c.shopId,
        'name': c.name,
        'displayCustomerNo': c.displayCustomerNo,
        'phone': c.phone,
        'address': c.address,
        'notes': c.notes,
        'createdAt': c.createdAt.toUtc().toIso8601String(),
        'deletedAt': c.deletedAt?.toUtc().toIso8601String(),
      };

  static CustomerEntity _customerFromMap(Map<String, dynamic> m) {
    final c = CustomerEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..name = m['name']! as String
      ..displayCustomerNo = (m['displayCustomerNo'] as String?)?.trim() ?? ''
      ..phone = m['phone'] as String?
      ..address = m['address'] as String?
      ..notes = m['notes'] as String?
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal();
    final del = m['deletedAt'] as String?;
    c.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return c;
  }

  static Map<String, dynamic> _orderToMap(OrderEntity o) => {
        'internalId': o.internalId,
        'shopId': o.shopId,
        'customerInternalId': o.customerInternalId,
        'displayOrderNo': o.displayOrderNo,
        'statusIndex': o.statusIndex,
        'deliveryDate': o.deliveryDate.toUtc().toIso8601String(),
        'createdAt': o.createdAt?.toUtc().toIso8601String(),
        'updatedAt': o.updatedAt.toUtc().toIso8601String(),
        'totalAmountMinor': o.totalAmountMinor,
        'measurementsSnapshot': o.measurementsSnapshot,
        'internalNotes': o.internalNotes,
        'sourceMeasurementProfileId': o.sourceMeasurementProfileId,
        'sourceMeasurementProfileLabel': o.sourceMeasurementProfileLabel,
        'styleName': o.styleName,
        'styleNameInternalId': o.styleNameInternalId,
        'styleSelectionJson': o.styleSelectionJson,
        'styleSummary': o.styleSummary,
        'deletedAt': o.deletedAt?.toUtc().toIso8601String(),
      };

  static OrderEntity _orderFromMap(Map<String, dynamic> m) {
    final o = OrderEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..customerInternalId = m['customerInternalId']! as String
      ..displayOrderNo = m['displayOrderNo']! as String
      ..statusIndex = (m['statusIndex'] as num).toInt()
      ..deliveryDate = DateTime.parse(m['deliveryDate']! as String).toLocal()
      ..updatedAt = DateTime.parse(m['updatedAt']! as String).toLocal()
      ..totalAmountMinor = (m['totalAmountMinor'] as num).toInt()
      ..measurementsSnapshot = m['measurementsSnapshot'] as String? ?? ''
      ..internalNotes = m['internalNotes'] as String? ?? ''
      ..sourceMeasurementProfileId =
          m['sourceMeasurementProfileId'] as String?
      ..sourceMeasurementProfileLabel =
          m['sourceMeasurementProfileLabel'] as String? ?? ''
      ..styleName = m['styleName'] as String? ?? ''
      ..styleNameInternalId = m['styleNameInternalId'] as String?
      ..styleSelectionJson = m['styleSelectionJson'] as String? ?? ''
      ..styleSummary = m['styleSummary'] as String? ?? '';
    final createdRaw = m['createdAt'] as String?;
    o.createdAt =
        createdRaw == null ? null : DateTime.parse(createdRaw).toLocal();
    final del = m['deletedAt'] as String?;
    o.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return o;
  }

  static Map<String, dynamic> _paymentToMap(PaymentEntity p) => {
        'internalId': p.internalId,
        'shopId': p.shopId,
        'orderInternalId': p.orderInternalId,
        'amountMinor': p.amountMinor,
        'method': p.method,
        'isAdjustment': p.isAdjustment,
        'createdAt': p.createdAt.toUtc().toIso8601String(),
      };

  static PaymentEntity _paymentFromMap(Map<String, dynamic> m) {
    return PaymentEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..orderInternalId = m['orderInternalId']! as String
      ..amountMinor = (m['amountMinor'] as num).toInt()
      ..method = m['method']! as String
      ..isAdjustment = m['isAdjustment']! as bool
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal();
  }

  static Map<String, dynamic> _snapshotToMap(OrderMeasurementSnapshotEntity s) =>
      {
        'internalId': s.internalId,
        'orderInternalId': s.orderInternalId,
        'shopId': s.shopId,
        'sourceMeasurementProfileId': s.sourceMeasurementProfileId,
        'createdAt': s.createdAt.toUtc().toIso8601String(),
      };

  static OrderMeasurementSnapshotEntity _snapshotFromMap(
    Map<String, dynamic> m,
  ) {
    return OrderMeasurementSnapshotEntity()
      ..internalId = m['internalId']! as String
      ..orderInternalId = m['orderInternalId']! as String
      ..shopId = m['shopId']! as String
      ..sourceMeasurementProfileId =
          m['sourceMeasurementProfileId'] as String?
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal();
  }

  static Map<String, dynamic> _snapshotItemToMap(
    OrderMeasurementSnapshotItemEntity i,
  ) =>
      {
        'snapshotInternalId': i.snapshotInternalId,
        'shopId': i.shopId,
        'measurementTypeInternalId': i.measurementTypeInternalId,
        'typeNameSnapshot': i.typeNameSnapshot,
        'value': i.value,
        'unitCode': i.unitCode,
        'sortOrder': i.sortOrder,
      };

  static OrderMeasurementSnapshotItemEntity _snapshotItemFromMap(
    Map<String, dynamic> m,
  ) {
    return OrderMeasurementSnapshotItemEntity()
      ..snapshotInternalId = m['snapshotInternalId']! as String
      ..shopId = m['shopId']! as String
      ..measurementTypeInternalId = m['measurementTypeInternalId']! as String
      ..typeNameSnapshot = m['typeNameSnapshot']! as String
      ..value = m['value']! as String
      ..unitCode = (m['unitCode'] as num).toInt()
      ..sortOrder = (m['sortOrder'] as num).toInt();
  }

  static Map<String, dynamic> _notificationToMap(AppNotificationEntity n) =>
      {
        'internalId': n.internalId,
        'shopId': n.shopId,
        'title': n.title,
        'body': n.body,
        'createdAt': n.createdAt.toUtc().toIso8601String(),
        'readAt': n.readAt?.toUtc().toIso8601String(),
        'relatedOrderInternalId': n.relatedOrderInternalId,
      };

  static AppNotificationEntity _notificationFromMap(Map<String, dynamic> m) {
    final n = AppNotificationEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..title = m['title']! as String
      ..body = m['body']! as String
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal()
      ..relatedOrderInternalId = m['relatedOrderInternalId'] as String?;
    final read = m['readAt'] as String?;
    n.readAt = read == null ? null : DateTime.parse(read).toLocal();
    return n;
  }

  static Map<String, dynamic> _measurementTypeToMap(MeasurementTypeEntity t) =>
      {
        'internalId': t.internalId,
        'shopId': t.shopId,
        'name': t.name,
        'sortOrder': t.sortOrder,
        'isActive': t.isActive,
        'createdAt': t.createdAt.toUtc().toIso8601String(),
        'updatedAt': t.updatedAt.toUtc().toIso8601String(),
        'deletedAt': t.deletedAt?.toUtc().toIso8601String(),
      };

  static MeasurementTypeEntity _measurementTypeFromMap(Map<String, dynamic> m) {
    final t = MeasurementTypeEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..name = m['name']! as String
      ..sortOrder = (m['sortOrder'] as num).toInt()
      ..isActive = (m['isActive'] as bool?) ?? true
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal()
      ..updatedAt = DateTime.parse(m['updatedAt']! as String).toLocal();
    final del = m['deletedAt'] as String?;
    t.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return t;
  }

  static Map<String, dynamic> _measurementProfileToMap(
    MeasurementProfileEntity p,
  ) =>
      {
        'internalId': p.internalId,
        'shopId': p.shopId,
        'customerInternalId': p.customerInternalId,
        'label': p.label,
        'body': p.body,
        'unitCode': p.unitCode,
        'createdAt': p.createdAt.toUtc().toIso8601String(),
        'updatedAt': p.updatedAt.toUtc().toIso8601String(),
        'deletedAt': p.deletedAt?.toUtc().toIso8601String(),
      };

  static MeasurementProfileEntity _measurementProfileFromMap(
    Map<String, dynamic> m,
  ) {
    final p = MeasurementProfileEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..customerInternalId = m['customerInternalId']! as String
      ..label = m['label']! as String
      ..body = m['body']! as String
      ..unitCode = (m['unitCode'] as num).toInt()
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal()
      ..updatedAt = DateTime.parse(m['updatedAt']! as String).toLocal();
    final del = m['deletedAt'] as String?;
    p.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return p;
  }

  static Map<String, dynamic> _profileItemToMap(MeasurementProfileItemEntity i) =>
      {
        'profileInternalId': i.profileInternalId,
        'shopId': i.shopId,
        'measurementTypeInternalId': i.measurementTypeInternalId,
        'value': i.value,
        'unitCode': i.unitCode,
        'deletedAt': i.deletedAt?.toUtc().toIso8601String(),
      };

  static MeasurementProfileItemEntity _profileItemFromMap(
    Map<String, dynamic> m,
  ) {
    final i = MeasurementProfileItemEntity()
      ..profileInternalId = m['profileInternalId']! as String
      ..shopId = m['shopId']! as String
      ..measurementTypeInternalId = m['measurementTypeInternalId']! as String
      ..value = m['value']! as String
      ..unitCode = (m['unitCode'] as num).toInt();
    final del = m['deletedAt'] as String?;
    i.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return i;
  }

  static Map<String, dynamic> _catalogItemToMap(CatalogItemEntity c) => {
        'internalId': c.internalId,
        'shopId': c.shopId,
        'designName': c.designName,
        'designerShopName': c.designerShopName,
        'imagePath': c.imagePath,
        'thumbnailPath': c.thumbnailPath,
        'notes': c.notes,
        'createdAt': c.createdAt.toUtc().toIso8601String(),
        'updatedAt': c.updatedAt.toUtc().toIso8601String(),
        'isSharedPublic': c.isSharedPublic,
        'deletedAt': c.deletedAt?.toUtc().toIso8601String(),
      };

  static CatalogItemEntity _catalogItemFromMap(Map<String, dynamic> m) {
    final c = CatalogItemEntity()
      ..internalId = m['internalId']! as String
      ..shopId = m['shopId']! as String
      ..designName = m['designName']! as String
      ..designerShopName = m['designerShopName']! as String
      ..imagePath = m['imagePath'] as String?
      ..thumbnailPath = m['thumbnailPath'] as String?
      ..notes = m['notes'] as String?
      ..createdAt = DateTime.parse(m['createdAt']! as String).toLocal()
      ..updatedAt = DateTime.parse(m['updatedAt']! as String).toLocal()
      ..isSharedPublic = (m['isSharedPublic'] as bool?) ?? false;
    final del = m['deletedAt'] as String?;
    c.deletedAt = del == null ? null : DateTime.parse(del).toLocal();
    return c;
  }

  static Future<String> _restoreCatalogAssetPath(
    String internalId,
    String kind,
    String base64Data,
  ) async {
    final dir = await getApplicationDocumentsDirectory();
    final folder = Directory('${dir.path}${Platform.pathSeparator}catalog');
    if (!await folder.exists()) {
      await folder.create(recursive: true);
    }
    final ext = kind == 'thumb' ? 'thumb.png' : 'jpg';
    final path =
        '${folder.path}${Platform.pathSeparator}backup_${internalId}_$kind.$ext';
    await File(path).writeAsBytes(base64Decode(base64Data), flush: true);
    return path;
  }
}
