import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/sync/outbox_push_batch.dart';
import 'package:pride_v3/data/local/sync_outbox_kinds.dart';

void main() {
  test('payment_append and payment_update map to payment upsert', () {
    final append = syncPushMetaForOutboxKind(SyncOutboxKinds.paymentAppend);
    final update = syncPushMetaForOutboxKind(SyncOutboxKinds.paymentUpdate);
    expect(append, isNotNull);
    expect(update, isNotNull);
    expect(append!.entityType, 'payment');
    expect(append.operation, 'upsert');
    expect(update!.entityType, 'payment');
    expect(update.operation, 'upsert');
  });
}
