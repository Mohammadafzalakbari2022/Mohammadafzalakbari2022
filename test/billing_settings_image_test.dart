import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/subscription/billing_settings_image.dart';

void main() {
  test('decodeBillingSettingsImageBytes returns bytes when present', () {
    final png = base64Encode([0x89, 0x50, 0x4E, 0x47]);
    final bytes = decodeBillingSettingsImageBytes({
      'has_settings_image': true,
      'settings_image_base64': png,
    });
    expect(bytes, isNotNull);
    expect(bytes!.length, 4);
  });

  test('decodeBillingSettingsImageBytes returns null when missing', () {
    expect(decodeBillingSettingsImageBytes(null), isNull);
    expect(
      decodeBillingSettingsImageBytes({'has_settings_image': false}),
      isNull,
    );
  });
}
