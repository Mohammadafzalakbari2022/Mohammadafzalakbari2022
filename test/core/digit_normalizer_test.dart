import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';

void main() {
  test('normalizes Persian digits', () {
    expect(normalizeWesternDigits('۱۲۳۴'), '1234');
  });

  test('tryParseMoneyAmount accepts mixed scripts', () {
    expect(tryParseMoneyAmount('۵۰۰'), 500);
    expect(tryParseMoneyAmount('1500'), 1500);
  });
}
