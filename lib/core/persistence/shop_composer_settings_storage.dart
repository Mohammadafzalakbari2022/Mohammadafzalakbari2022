import 'package:shared_preferences/shared_preferences.dart';

/// Shop-scoped Orders composer field visibility (offline-first local prefs).
class ComposerVisibilitySettings {
  const ComposerVisibilitySettings({
    this.showStyleName = true,
    this.showCatalogPicker = true,
    this.showClothBlock = true,
  });

  final bool showStyleName;
  final bool showCatalogPicker;
  final bool showClothBlock;

  ComposerVisibilitySettings copyWith({
    bool? showStyleName,
    bool? showCatalogPicker,
    bool? showClothBlock,
  }) {
    return ComposerVisibilitySettings(
      showStyleName: showStyleName ?? this.showStyleName,
      showCatalogPicker: showCatalogPicker ?? this.showCatalogPicker,
      showClothBlock: showClothBlock ?? this.showClothBlock,
    );
  }
}

String _composerVisKey(String shopId, String suffix) =>
    'pride_composer_vis_${shopId.trim()}_$suffix';

ComposerVisibilitySettings readComposerVisibilitySettings(
  SharedPreferences prefs,
  String shopId,
) {
  final id = shopId.trim();
  if (id.isEmpty) return const ComposerVisibilitySettings();
  return ComposerVisibilitySettings(
    showStyleName: prefs.getBool(_composerVisKey(id, 'style_name')) ?? true,
    showCatalogPicker:
        prefs.getBool(_composerVisKey(id, 'catalog')) ?? true,
    showClothBlock: prefs.getBool(_composerVisKey(id, 'cloth')) ?? true,
  );
}

Future<void> persistComposerVisibilitySettings(
  SharedPreferences prefs,
  String shopId,
  ComposerVisibilitySettings settings,
) async {
  final id = shopId.trim();
  if (id.isEmpty) return;
  await prefs.setBool(
    _composerVisKey(id, 'style_name'),
    settings.showStyleName,
  );
  await prefs.setBool(
    _composerVisKey(id, 'catalog'),
    settings.showCatalogPicker,
  );
  await prefs.setBool(
    _composerVisKey(id, 'cloth'),
    settings.showClothBlock,
  );
}
