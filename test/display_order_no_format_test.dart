import 'package:flutter_test/flutter_test.dart';

import 'package:pride_v3/core/formatting/display_order_no_format.dart';

void main() {
  group('formatDisplayOrderNo', () {
    test('pads small numbers to 5 digits', () {
      expect(formatDisplayOrderNo('00000001'), '00001');
      expect(formatDisplayOrderNo('00000042'), '00042');
    });

    test('shows five digits at 99999', () {
      expect(formatDisplayOrderNo('00099999'), '99999');
    });

    test('grows beyond 5 digits when above 99999', () {
      expect(formatDisplayOrderNo('00100000'), '100000');
      expect(formatDisplayOrderNo('000100000'), '100000');
    });

    test('returns original for invalid values', () {
      expect(formatDisplayOrderNo(''), '');
      expect(formatDisplayOrderNo('ABC-1'), 'ABC-1');
      expect(formatDisplayOrderNo('00000000'), '00000000');
    });

    test('trims whitespace before parsing', () {
      expect(formatDisplayOrderNo('  00000007  '), '00007');
    });
  });

  group('displayOrderNoMatchesQuery', () {
    test('matches formatted and stored digits', () {
      expect(displayOrderNoMatchesQuery('00000042', '42'), isTrue);
      expect(displayOrderNoMatchesQuery('00000042', '00042'), isTrue);
      expect(displayOrderNoMatchesQuery('00100000', '100000'), isTrue);
    });

    test('returns false for unrelated queries', () {
      expect(displayOrderNoMatchesQuery('00000042', 'ahmad'), isFalse);
      expect(displayOrderNoMatchesQuery('', '42'), isFalse);
    });
  });
}
