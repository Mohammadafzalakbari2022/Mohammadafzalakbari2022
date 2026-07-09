import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/sync/outbox_push_batch.dart';
import 'package:pride_v3/data/local/sync_outbox_kinds.dart';

void main() {
  test('cloth outbox kinds map to sync entity types', () {
    expect(
      syncPushMetaForOutboxKind(SyncOutboxKinds.clothSkuUpsert),
      (entityType: 'cloth_sku', operation: 'upsert'),
    );
    expect(
      syncPushMetaForOutboxKind(SyncOutboxKinds.clothSupplierUpsert),
      (entityType: 'cloth_supplier', operation: 'upsert'),
    );
    expect(
      syncPushMetaForOutboxKind(SyncOutboxKinds.clothPurchaseUpsert),
      (entityType: 'cloth_purchase', operation: 'upsert'),
    );
    expect(
      syncPushMetaForOutboxKind(SyncOutboxKinds.clothPurchasePaymentAppend),
      (entityType: 'cloth_purchase_payment', operation: 'upsert'),
    );
    expect(
      syncPushMetaForOutboxKind(SyncOutboxKinds.clothMovementAppend),
      (entityType: 'cloth_stock_movement', operation: 'upsert'),
    );
  });
}
