import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/customer_display_no.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/memory_customer_repository.dart';

void main() {
  CustomerSummary customer({
    required String internalId,
    String displayCustomerNo = '',
    DateTime? createdAt,
  }) {
    return CustomerSummary(
      shopId: 'shop-1',
      internalId: internalId,
      name: 'Test',
      displayCustomerNo: displayCustomerNo,
      createdAt: createdAt ?? DateTime(2026, 1, 1),
    );
  }

  group('customer display number helpers', () {
    test('formatStoredDisplayCustomerNo pads to 8 digits', () {
      expect(formatStoredDisplayCustomerNo(1), '00000001');
      expect(formatStoredDisplayCustomerNo(42), '00000042');
      expect(formatStoredDisplayCustomerNo(100000), '00100000');
    });

    test('customerDisplayNoMatchesQuery supports partial and full digits', () {
      expect(customerDisplayNoMatchesQuery('00000042', '42'), isTrue);
      expect(customerDisplayNoMatchesQuery('00000042', '00042'), isTrue);
      expect(customerDisplayNoMatchesQuery('00000042', '7'), isFalse);
    });

    test('nextDisplayCustomerNoFromSummaries returns max + 1 per shop', () {
      final next = nextDisplayCustomerNoFromSummaries(
        [
          customer(internalId: 'a', displayCustomerNo: '00000005'),
          customer(internalId: 'b', displayCustomerNo: '00000012'),
          customer(
            internalId: 'other-shop',
            displayCustomerNo: '00000099',
          ).copyWithShop('shop-2'),
        ],
        'shop-1',
      );
      expect(next, 13);
    });
  });

  group('MemoryCustomerRepository customer numbers', () {
    test('createCustomer assigns incrementing display numbers', () async {
      final repo = MemoryCustomerRepository();
      final first = await repo.createCustomer(
        shopId: kDevShopId,
        name: 'One',
      );
      final second = await repo.createCustomer(
        shopId: kDevShopId,
        name: 'Two',
      );
      final list = await repo.watchCustomers(kDevShopId).first;
      final a = list.firstWhere((c) => c.internalId == first);
      final b = list.firstWhere((c) => c.internalId == second);
      expect(parseStoredDisplayCustomerNo(a.displayCustomerNo), 3);
      expect(parseStoredDisplayCustomerNo(b.displayCustomerNo), 4);
    });
  });
}

extension on CustomerSummary {
  CustomerSummary copyWithShop(String shopId) {
    return CustomerSummary(
      shopId: shopId,
      internalId: internalId,
      name: name,
      displayCustomerNo: displayCustomerNo,
      phone: phone,
      address: address,
      notes: notes,
      createdAt: createdAt,
    );
  }
}
