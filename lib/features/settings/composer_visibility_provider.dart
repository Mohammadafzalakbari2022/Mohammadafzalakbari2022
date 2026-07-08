import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../auth/auth_providers.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../core/persistence/shop_composer_settings_storage.dart';
import '../../data/local/dev_shop_constants.dart';

class ComposerVisibilityNotifier extends Notifier<ComposerVisibilitySettings> {
  @override
  ComposerVisibilitySettings build() {
    final shopId = effectiveShopIdFromAuth(ref.watch(authSessionProvider).shopId);
    final prefs = ref.watch(sharedPreferencesProvider);
    return readComposerVisibilitySettings(prefs, shopId);
  }

  Future<void> setMeasurementsBlockVisible(bool value) async {
    final next = state.copyWith(showMeasurementsBlock: value);
    state = next;
    await _persist(next);
  }

  Future<void> setStyleNameVisible(bool value) async {
    final next = state.copyWith(showStyleName: value);
    state = next;
    await _persist(next);
  }

  Future<void> setCatalogPickerVisible(bool value) async {
    final next = state.copyWith(showCatalogPicker: value);
    state = next;
    await _persist(next);
  }

  Future<void> setStyleShapesVisible(bool value) async {
    final next = state.copyWith(showStyleShapes: value);
    state = next;
    await _persist(next);
  }

  Future<void> setClothBlockVisible(bool value) async {
    final next = state.copyWith(showClothBlock: value);
    state = next;
    await _persist(next);
  }

  Future<void> _persist(ComposerVisibilitySettings settings) async {
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final prefs = ref.read(sharedPreferencesProvider);
    await persistComposerVisibilitySettings(prefs, shopId, settings);
  }
}

final composerVisibilitySettingsProvider =
    NotifierProvider<ComposerVisibilityNotifier, ComposerVisibilitySettings>(
  ComposerVisibilityNotifier.new,
);
