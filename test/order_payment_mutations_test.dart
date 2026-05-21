import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/orders/order_payment_mutations.dart';

void main() {
  group('OrderPaymentMutations payloads', () {
    test('appendPayloadJson matches server sync fields', () {
      final json = OrderPaymentMutations.appendPayloadJson(
        orderInternalId: 'order-1',
        amountMinor: 2500,
        createdAt: DateTime.utc(2026, 5, 21, 12),
      );
      final m = jsonDecode(json) as Map<String, dynamic>;
      expect(m['order_internal_id'], 'order-1');
      expect(m['amount_minor'], 2500);
      expect(m['method'], 'cash');
      expect(m['is_adjustment'], false);
      expect(m['created_at'], '2026-05-21T12:00:00.000Z');
    });

    test('updatePayloadJson includes updated_at', () {
      final created = DateTime.utc(2026, 1, 1);
      final updated = DateTime.utc(2026, 5, 21);
      final json = OrderPaymentMutations.updatePayloadJson(
        orderInternalId: 'order-1',
        amountMinor: 1500,
        method: 'cash',
        isAdjustment: false,
        createdAt: created,
        updatedAt: updated,
      );
      final m = jsonDecode(json) as Map<String, dynamic>;
      expect(m['amount_minor'], 1500);
      expect(m['updated_at'], '2026-05-21T00:00:00.000Z');
      expect(m['created_at'], '2026-01-01T00:00:00.000Z');
    });
  });
}
