import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/settings/style/style_figure_settings_validation.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  group('style_figure_settings_validation', () {
    test('isNonEmptyShapeOptionLabel', () {
      expect(isNonEmptyShapeOptionLabel('Round front'), isTrue);
      expect(isNonEmptyShapeOptionLabel('  '), isFalse);
    });

    test('isValidInchMeasurementText accepts tailor-style measurements', () {
      expect(isValidInchMeasurementText('5 1/2 x 7 1/2 inch'), isTrue);
      expect(isValidInchMeasurementText('5½ x 7½ inch'), isTrue);
      expect(isValidInchMeasurementText('5.5 x 7.5 inch'), isTrue);
      expect(isValidInchMeasurementText('5 inch'), isTrue);
      expect(isValidInchMeasurementText('2.5'), isTrue);
    });

    test('isValidInchMeasurementText rejects empty input', () {
      expect(isValidInchMeasurementText(''), isFalse);
      expect(isValidInchMeasurementText('   '), isFalse);
    });

    test('isValidInchMeasurementText rejects invalid characters', () {
      expect(isValidInchMeasurementText('abc'), isFalse);
      expect(isValidInchMeasurementText('5 @ 7 inch'), isFalse);
    });

    test('validation error message explains tailor format', () {
      final l10n = lookupAppLocalizations(const Locale('en'));
      expect(
        l10n.settingsStyleFigureValuePositiveRequired,
        'Enter a valid measurement, for example 5 1/2 x 7 1/2 inch.',
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
