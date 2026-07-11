import 'package:shared_preferences/shared_preferences.dart';

/// Shop-scoped Orders composer field visibility (offline-first local prefs).
class ComposerVisibilitySettings {
  const ComposerVisibilitySettings({
    this.showMeasurementsBlock = true,
    this.showStyleName = true,
    this.showCatalogPicker = true,
    this.showStyleShapes = true,
    this.showClothBlock = false,
  });

  final bool showMeasurementsBlock;
  final bool showStyleName;
  final bool showCatalogPicker;
  final bool showStyleShapes;
  final bool showClothBlock;

  bool get showAnyStyleSection =>
      showStyleName || showCatalogPicker || showStyleShapes;

  ComposerVisibilitySettings copyWith({
    bool? showMeasurementsBlock,
    bool? showStyleName,
    bool? showCatalogPicker,
    bool? showStyleShapes,
    bool? showClothBlock,
  }) {
    return ComposerVisibilitySettings(
      showMeasurementsBlock:
          showMeasurementsBlock ?? this.showMeasurementsBlock,
      showStyleName: showStyleName ?? this.showStyleName,
      showCatalogPicker: showCatalogPicker ?? this.showCatalogPicker,
      showStyleShapes: showStyleShapes ?? this.showStyleShapes,
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
    showMeasurementsBlock:
        prefs.getBool(_composerVisKey(id, 'measurements')) ?? true,
    showStyleName: prefs.getBool(_composerVisKey(id, 'style_name')) ?? true,
    showCatalogPicker:
        prefs.getBool(_composerVisKey(id, 'catalog')) ?? true,
    showStyleShapes: prefs.getBool(_composerVisKey(id, 'style_shapes')) ?? true,
    showClothBlock: prefs.getBool(_composerVisKey(id, 'cloth')) ?? false,
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
    _composerVisKey(id, 'measurements'),
    settings.showMeasurementsBlock,
  );
  await prefs.setBool(
    _composerVisKey(id, 'style_name'),
    settings.showStyleName,
  );
  await prefs.setBool(
    _composerVisKey(id, 'catalog'),
    settings.showCatalogPicker,
  );
  await prefs.setBool(
    _composerVisKey(id, 'style_shapes'),
    settings.showStyleShapes,
  );
  await prefs.setBool(
    _composerVisKey(id, 'cloth'),
    settings.showClothBlock,
  );
}
