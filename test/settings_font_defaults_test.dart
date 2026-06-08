import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pride_v3/features/settings/settings_providers.dart';

void main() {
  group('font preference defaults', () {
    test('missing keys default to Noto Naskh Arabic and Medium', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();

      expect(fontFamilyPresetFromPrefs(prefs), PrideFontFamilyPreset.notoNaskh);
      expect(fontSizePresetFromPrefs(prefs), PrideFontSizePreset.medium);
    });

    test('saved preferences are preserved', () async {
      SharedPreferences.setMockInitialValues({
        prideFontFamilyPresetKey: 'vazirmatn',
        prideFontSizePresetKey: 'large',
      });
      final prefs = await SharedPreferences.getInstance();

      expect(fontFamilyPresetFromPrefs(prefs), PrideFontFamilyPreset.vazirmatn);
      expect(fontSizePresetFromPrefs(prefs), PrideFontSizePreset.large);
      expect(fontScaleFromPreset(PrideFontSizePreset.large), 1.20);
    });
  });
}
