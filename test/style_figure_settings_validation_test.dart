import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/settings/style/style_figure_settings_validation.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  group('style_figure_settings_validation', () {
    test('isNonEmptyShapeOptionLabel accepts any non-empty text', () {
      expect(isNonEmptyShapeOptionLabel('Round front'), isTrue);
      expect(isNonEmptyShapeOptionLabel('5 1/2 x 7 1/2 inch'), isTrue);
      expect(isNonEmptyShapeOptionLabel('ABC اردو'), isTrue);
      expect(isNonEmptyShapeOptionLabel('Large @ #'), isTrue);
    });

    test('isNonEmptyShapeOptionLabel rejects empty input', () {
      expect(isNonEmptyShapeOptionLabel(''), isFalse);
      expect(isNonEmptyShapeOptionLabel('   '), isFalse);
    });

    test('validation error message for empty inch value', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(
        l10n.settingsStyleFigureValueRequired,
        'Enter an inch option value.',
      );
    });

    test('normalizeIdList trims and removes empty ids', () {
      expect(
        normalizeIdList([' a ', '', 'b', '  ']),
        ['a', 'b'],
      );
    });
  });
}
