import 'dart:convert';

import '../../data/local/sync_outbox_kinds.dart';
import '../../data/local/sync_outbox_pending_view.dart';

const int kSyncPushOutboxBatchLimit = 100;

/// Maps [SyncOutboxKinds] to plan-04 `entity_type` and `operation`.
({String entityType, String operation})? syncPushMetaForOutboxKind(String kind) {
  switch (kind) {
    case SyncOutboxKinds.orderCreate:
    case SyncOutboxKinds.orderStatus:
    case SyncOutboxKinds.orderInternalNotes:
    case SyncOutboxKinds.orderUpdate:
      return (entityType: 'order', operation: 'upsert');
    case SyncOutboxKinds.orderDelete:
      return (entityType: 'order', operation: 'delete');
    case SyncOutboxKinds.paymentAppend:
    case SyncOutboxKinds.paymentUpdate:
      return (entityType: 'payment', operation: 'upsert');
    case SyncOutboxKinds.notificationAppend:
      return (entityType: 'notification', operation: 'upsert');
    case SyncOutboxKinds.measurementTypeUpsert:
      return (entityType: 'measurement_type', operation: 'upsert');
    case SyncOutboxKinds.measurementTypeDelete:
      return (entityType: 'measurement_type', operation: 'delete');
    case SyncOutboxKinds.customerUpsert:
      return (entityType: 'customer', operation: 'upsert');
    case SyncOutboxKinds.customerDelete:
      return (entityType: 'customer', operation: 'delete');
    case SyncOutboxKinds.taskUpsert:
      return (entityType: 'task', operation: 'upsert');
    case SyncOutboxKinds.taskDelete:
      return (entityType: 'task', operation: 'delete');
    case SyncOutboxKinds.measurementProfileUpsert:
      return (entityType: 'measurement_profile', operation: 'upsert');
    case SyncOutboxKinds.measurementProfileDelete:
      return (entityType: 'measurement_profile', operation: 'delete');
    case SyncOutboxKinds.catalogItemUpsert:
      return (entityType: 'catalog_item', operation: 'upsert');
    case SyncOutboxKinds.catalogItemDelete:
      return (entityType: 'catalog_item', operation: 'delete');
    case SyncOutboxKinds.styleNameUpsert:
      return (entityType: 'style_name', operation: 'upsert');
    case SyncOutboxKinds.styleNameDelete:
      return (entityType: 'style_name', operation: 'delete');
    case SyncOutboxKinds.stylePartUpsert:
      return (entityType: 'style_part', operation: 'upsert');
    case SyncOutboxKinds.stylePartDelete:
      return (entityType: 'style_part', operation: 'delete');
    case SyncOutboxKinds.styleFigureUpsert:
      return (entityType: 'style_figure', operation: 'upsert');
    case SyncOutboxKinds.styleFigureDelete:
      return (entityType: 'style_figure', operation: 'delete');
    case SyncOutboxKinds.fabricNameUpsert:
      return (entityType: 'fabric_name', operation: 'upsert');
    case SyncOutboxKinds.fabricNameDelete:
      return (entityType: 'fabric_name', operation: 'delete');
    case SyncOutboxKinds.fabricColorUpsert:
      return (entityType: 'fabric_color', operation: 'upsert');
    case SyncOutboxKinds.fabricColorDelete:
      return (entityType: 'fabric_color', operation: 'delete');
    case SyncOutboxKinds.shopRentUpsert:
      return (entityType: 'shop_rent', operation: 'upsert');
    case SyncOutboxKinds.shopRentPaymentAppend:
      return (entityType: 'shop_rent_payment', operation: 'upsert');
    case SyncOutboxKinds.shopExpenseUpsert:
      return (entityType: 'shop_expense', operation: 'upsert');
    case SyncOutboxKinds.shopExpenseDelete:
      return (entityType: 'shop_expense', operation: 'delete');
    default:
      return null;
  }
}

/// Batch built from local outbox for `POST /sync/push`.
class OutboxPushBatch {
  OutboxPushBatch({required this.mutations, required this.entryIdsToClear});

  final List<Map<String, dynamic>> mutations;

  /// Outbox [SyncOutboxPendingView.entryId] rows aligned with [mutations].
  final List<String> entryIdsToClear;
}

OutboxPushBatch buildOutboxPushBatch(List<SyncOutboxPendingView> pending) {
  final mutations = <Map<String, dynamic>>[];
  final entryIds = <String>[];
  for (final v in pending) {
    if (mutations.length >= kSyncPushOutboxBatchLimit) break;
    final meta = syncPushMetaForOutboxKind(v.kind);
    if (meta == null) continue;
    final internalId =
        v.entityRef.trim().isNotEmpty ? v.entityRef.trim() : v.entryId;
    Map<String, dynamic> data;
    try {
      final decoded = jsonDecode(v.payloadJson);
      data = decoded is Map<String, dynamic> ? decoded : <String, dynamic>{};
    } catch (_) {
      data = {};
    }
    final row = <String, dynamic>{
      'internal_id': internalId,
      'entity_type': meta.entityType,
      'operation': meta.operation,
      'client_updated_at': v.queuedAt.toUtc().toIso8601String(),
    };
    if (meta.operation == 'upsert') {
      row['data'] = data;
    }
    mutations.add(row);
    entryIds.add(v.entryId);
  }
  return OutboxPushBatch(mutations: mutations, entryIdsToClear: entryIds);
}
