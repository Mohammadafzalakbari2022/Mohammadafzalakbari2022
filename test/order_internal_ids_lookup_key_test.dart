import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/order_internal_ids_lookup_key.dart';

void main() {
  test('orderInternalIdsLookupKey is stable for same ids', () {
    const a = ['order-b', 'order-a', 'order-a'];
    const b = ['order-a', 'order-b'];
    expect(orderInternalIdsLookupKey(a), orderInternalIdsLookupKey(b));
  });

  test('orderInternalIdsLookupKey empty for no ids', () {
    expect(orderInternalIdsLookupKey(const []), '');
    expect(orderInternalIdsFromLookupKey(''), isEmpty);
  });

  test('orderInternalIdsFromLookupKey round-trips sorted ids', () {
    const ids = ['z-order', 'a-order'];
    final key = orderInternalIdsLookupKey(ids);
    expect(orderInternalIdsFromLookupKey(key), ['a-order', 'z-order']);
  });
}
