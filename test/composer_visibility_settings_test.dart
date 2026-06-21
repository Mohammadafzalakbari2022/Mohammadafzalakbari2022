import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:pride_v3/core/persistence/shop_composer_settings_storage.dart';

void main() {
  group('ComposerVisibilitySettings', () {
    test('defaults all visible when prefs empty', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      const settings = ComposerVisibilitySettings();
      expect(settings.showStyleName, isTrue);
      expect(settings.showCatalogPicker, isTrue);
      expect(settings.showClothBlock, isTrue);
      expect(
        readComposerVisibilitySettings(prefs, 'shop-a').showStyleName,
        isTrue,
      );
      expect(
        readComposerVisibilitySettings(prefs, 'shop-a').showClothBlock,
        isTrue,
      );
    });

    test('persists per shop', () async {
      SharedPreferences.setMockInitialValues({});
      final prefs = await SharedPreferences.getInstance();
      await persistComposerVisibilitySettings(
        prefs,
        'shop-a',
        const ComposerVisibilitySettings(
          showStyleName: false,
          showCatalogPicker: true,
          showClothBlock: false,
        ),
      );
      final read = readComposerVisibilitySettings(prefs, 'shop-a');
      expect(read.showStyleName, isFalse);
      expect(read.showCatalogPicker, isTrue);
      expect(read.showClothBlock, isFalse);
      expect(
        readComposerVisibilitySettings(prefs, 'shop-b').showStyleName,
        isTrue,
      );
    });
  });
}
