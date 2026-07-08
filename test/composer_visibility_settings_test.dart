import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/persistence/shop_composer_settings_storage.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  group('ComposerVisibilitySettings storage', () {
    setUp(() async {
      SharedPreferences.setMockInitialValues({});
    });

    test('persists measurements and style shapes toggles per shop', () async {
      final prefs = await SharedPreferences.getInstance();
      const shopId = 'shop-a';
      const settings = ComposerVisibilitySettings(
        showMeasurementsBlock: false,
        showStyleName: true,
        showCatalogPicker: false,
        showStyleShapes: true,
        showClothBlock: false,
      );

      await persistComposerVisibilitySettings(prefs, shopId, settings);
      final loaded = readComposerVisibilitySettings(prefs, shopId);

      expect(loaded.showMeasurementsBlock, isFalse);
      expect(loaded.showStyleName, isTrue);
      expect(loaded.showCatalogPicker, isFalse);
      expect(loaded.showStyleShapes, isTrue);
      expect(loaded.showClothBlock, isFalse);
      expect(loaded.showAnyStyleSection, isTrue);
    });

    test('showAnyStyleSection false when all style sections hidden', () {
      const settings = ComposerVisibilitySettings(
        showStyleName: false,
        showCatalogPicker: false,
        showStyleShapes: false,
      );
      expect(settings.showAnyStyleSection, isFalse);
    });
  });
}
