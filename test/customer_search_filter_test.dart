import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/customer_summary.dart';
import 'package:pride_v3/features/customers/customer_search_filter.dart';

void main() {
  CustomerSummary customer({
    required String internalId,
    required String name,
    String? phone,
    String displayCustomerNo = '',
  }) {
    return CustomerSummary(
      shopId: 'shop-1',
      internalId: internalId,
      name: name,
      displayCustomerNo: displayCustomerNo,
      phone: phone,
      createdAt: DateTime(2026, 1, 1),
    );
  }

  final sampleCustomers = [
    customer(
      internalId: '1',
      name: 'Ahmad Khan',
      phone: '0700123456',
      displayCustomerNo: '00000001',
    ),
    customer(
      internalId: '2',
      name: 'Sara Ali',
      phone: '+93 70 765 4321',
      displayCustomerNo: '00000042',
    ),
    customer(internalId: '3', name: 'No Phone Customer'),
  ];

  group('filterCustomersBySearchQuery', () {
    test('empty query returns all customers in source order', () {
      final result = filterCustomersBySearchQuery(sampleCustomers, '');
      expect(result, sampleCustomers);
      expect(result, filterCustomersBySearchQuery(sampleCustomers, '   '));
    });

    test('matches customer name case-insensitively', () {
      final result = filterCustomersBySearchQuery(sampleCustomers, '  aHMaD  ');
      expect(result.map((c) => c.internalId), ['1']);
    });

    test('matches phone substring case-insensitively', () {
      final result = filterCustomersBySearchQuery(sampleCustomers, '7654321');
      expect(result.map((c) => c.internalId), ['2']);
    });

    test('matches phone digits ignoring formatting', () {
      final result = filterCustomersBySearchQuery(sampleCustomers, '70 765');
      expect(result.map((c) => c.internalId), ['2']);
    });

    test('returns empty list when nothing matches', () {
      expect(
        filterCustomersBySearchQuery(sampleCustomers, 'missing'),
        isEmpty,
      );
    });

    test('matches customer ID by partial digits', () {
      expect(
        filterCustomersBySearchQuery(sampleCustomers, '42')
            .map((c) => c.internalId),
        ['2'],
      );
    });

    test('matches customer ID by formatted digits', () {
      expect(
        filterCustomersBySearchQuery(sampleCustomers, '00042')
            .map((c) => c.internalId),
        ['2'],
      );
    });
  });

  group('findFirstCustomerBySearchQuery', () {
    test('returns first match in source order', () {
      final match = findFirstCustomerBySearchQuery(sampleCustomers, '70');
      expect(match?.internalId, '1');
    });

    test('returns null for empty query', () {
      expect(findFirstCustomerBySearchQuery(sampleCustomers, ''), isNull);
    });
  });
}
