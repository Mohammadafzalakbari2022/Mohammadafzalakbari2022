import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/customer_repository_exception.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/data/local/customer_uniqueness.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/memory_customer_repository.dart';

void main() {
  CustomerSummary customer({
    required String internalId,
    required String name,
    String? phone,
  }) {
    return CustomerSummary(
      shopId: kDevShopId,
      internalId: internalId,
      name: name,
      phone: phone,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  group('findCustomerByExactName', () {
    test('matches exact trimmed name only', () {
      final list = [
        customer(internalId: 'a', name: 'Ahmad'),
        customer(internalId: 'b', name: 'احمد'),
      ];
      expect(findCustomerByExactName(list, 'Ahmad')?.internalId, 'a');
      expect(findCustomerByExactName(list, 'احمد')?.internalId, 'b');
      expect(findCustomerByExactName(list, 'Ahm'), isNull);
      expect(findCustomerByExactName(list, '  Ahmad  ')?.internalId, 'a');
    });
  });

  group('findCustomerByPhone', () {
    test('matches normalized digits', () {
      final list = [
        customer(internalId: 'a', name: 'A', phone: '0700123456'),
      ];
      expect(findCustomerByPhone(list, '0700-123-456')?.internalId, 'a');
      expect(findCustomerByPhone(list, '0700999999'), isNull);
      expect(findCustomerByPhone(list, ''), isNull);
    });
  });

  group('MemoryCustomerRepository uniqueness', () {
    test('rejects duplicate name on create', () async {
      final repo = MemoryCustomerRepository();
      await repo.createCustomer(shopId: kDevShopId, name: 'Karim');
      await expectLater(
        repo.createCustomer(shopId: kDevShopId, name: 'Karim'),
        throwsA(isA<CustomerRepositoryException>()),
      );
    });

    test('rejects duplicate phone on create', () async {
      final repo = MemoryCustomerRepository();
      await repo.createCustomer(
        shopId: kDevShopId,
        name: 'One',
        phone: '0700111111',
      );
      await expectLater(
        repo.createCustomer(
          shopId: kDevShopId,
          name: 'Two',
          phone: '0700-111-111',
        ),
        throwsA(
          predicate<CustomerRepositoryException>((e) => e.code == 'duplicate_phone'),
        ),
      );
    });

    test('allows update of same customer', () async {
      final repo = MemoryCustomerRepository();
      final id = await repo.createCustomer(
        shopId: kDevShopId,
        name: 'Sara',
        phone: '0700222222',
      );
      await repo.updateCustomer(
        internalId: id,
        name: 'Sara',
        phone: '0700222222',
      );
    });
  });
}
