import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/settings/style/style_figure_settings_validation.dart';

void main() {
  group('style_figure_settings_validation', () {
    test('isNonEmptyShapeOptionLabel', () {
      expect(isNonEmptyShapeOptionLabel('Round front'), isTrue);
      expect(isNonEmptyShapeOptionLabel('  '), isFalse);
    });

    test('isPositiveInchesValue', () {
      expect(isPositiveInchesValue('2.5'), isTrue);
      expect(isPositiveInchesValue('0'), isFalse);
      expect(isPositiveInchesValue('-1'), isFalse);
      expect(isPositiveInchesValue('abc'), isFalse);
    });

    test('isNonEmptyPresetName', () {
      expect(isNonEmptyPresetName('Normal Style'), isTrue);
      expect(isNonEmptyPresetName(''), isFalse);
    });

    test('normalizeIdList trims and removes empty ids', () {
      expect(
        normalizeIdList([' a ', '', 'b', '  ']),
        ['a', 'b'],
      );
    });
  });
}
