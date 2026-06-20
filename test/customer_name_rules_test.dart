import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/customer_name_rules.dart';

void main() {
  group('isValidCustomerName', () {
    test('rejects null, empty, and single character', () {
      expect(isValidCustomerName(null), isFalse);
      expect(isValidCustomerName(''), isFalse);
      expect(isValidCustomerName('   '), isFalse);
      expect(isValidCustomerName('A'), isFalse);
    });

    test('accepts trimmed names with at least two characters', () {
      expect(isValidCustomerName('Ab'), isTrue);
      expect(isValidCustomerName('  Ahmad Khan  '), isTrue);
    });
  });

  group('assertValidCustomerName', () {
    test('throws for invalid names', () {
      expect(() => assertValidCustomerName(''), throwsArgumentError);
      expect(() => assertValidCustomerName('x'), throwsArgumentError);
    });
  });
}
