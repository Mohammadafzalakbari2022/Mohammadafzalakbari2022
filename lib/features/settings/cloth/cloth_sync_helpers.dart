import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/sync_outbox_kinds.dart';
import '../../../shell/shell_sync_providers.dart';

void enqueueClothSkuUpsert(
  WidgetRef ref, {
  required String internalId,
  required String skuCode,
  required String name,
  String color = '',
  String? fabricNamePresetInternalId,
  String? fabricColorPresetInternalId,
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothSkuUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode({
      'sku_code': skuCode,
      'name': name,
      if (color.trim().isNotEmpty) 'color': color.trim(),
      if (fabricNamePresetInternalId != null)
        'fabric_name_preset_internal_id': fabricNamePresetInternalId,
      if (fabricColorPresetInternalId != null)
        'fabric_color_preset_internal_id': fabricColorPresetInternalId,
    }),
  );
}

void enqueueClothSkuDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothSkuDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueClothSupplierUpsert(
  WidgetRef ref, {
  required String internalId,
  required String name,
  String phone = '',
  String notes = '',
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothSupplierUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode({
      'name': name,
      if (phone.trim().isNotEmpty) 'phone': phone.trim(),
      if (notes.trim().isNotEmpty) 'notes': notes.trim(),
    }),
  );
}

void enqueueClothSupplierDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothSupplierDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueClothPurchaseUpsert(
  WidgetRef ref, {
  required String internalId,
  required String supplierInternalId,
  required DateTime purchaseDate,
  required List<Map<String, dynamic>> lines,
  String note = '',
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothPurchaseUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode({
      'supplier_internal_id': supplierInternalId,
      'purchase_date': purchaseDate.toUtc().toIso8601String(),
      if (note.trim().isNotEmpty) 'note': note.trim(),
      'lines': lines,
    }),
  );
}

void enqueueClothPurchasePaymentAppend(
  WidgetRef ref, {
  required String internalId,
  required String purchaseInternalId,
  required int amountMinor,
  required DateTime paidAt,
  String note = '',
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothPurchasePaymentAppend,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode({
      'purchase_internal_id': purchaseInternalId,
      'amount_minor': amountMinor,
      'paid_at': paidAt.toUtc().toIso8601String(),
      if (note.trim().isNotEmpty) 'note': note.trim(),
    }),
  );
}

void enqueueClothMovementAppend(
  WidgetRef ref, {
  required String internalId,
  required String skuInternalId,
  required int movementTypeIndex,
  required int qtyMilliDelta,
  String? orderItemInternalId,
  String? purchaseLineInternalId,
  String note = '',
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.clothMovementAppend,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode({
      'sku_internal_id': skuInternalId,
      'movement_type_index': movementTypeIndex,
      'qty_milli_delta': qtyMilliDelta,
      if (orderItemInternalId != null)
        'order_item_internal_id': orderItemInternalId,
      if (purchaseLineInternalId != null)
        'purchase_line_internal_id': purchaseLineInternalId,
      if (note.trim().isNotEmpty) 'note': note.trim(),
    }),
  );
}
