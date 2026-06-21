import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'composer_visibility_provider.dart';

class SettingsComposerFieldsScreen extends ConsumerWidget {
  const SettingsComposerFieldsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final visibility = ref.watch(composerVisibilitySettingsProvider);
    final notifier = ref.read(composerVisibilitySettingsProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsComposerFieldsTitle),
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              l10n.settingsComposerFieldsIntro,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
          ),
          SwitchListTile(
            secondary: PrideColoredLeading(
              icon: Icons.style_outlined,
              color: prideSettingsIconColor(2),
            ),
            title: Text(l10n.settingsComposerShowStyleNameTitle),
            subtitle: Text(l10n.settingsComposerShowStyleNameSubtitle),
            value: visibility.showStyleName,
            onChanged: notifier.setStyleNameVisible,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: PrideColoredLeading(
              icon: Icons.image_outlined,
              color: prideSettingsIconColor(3),
            ),
            title: Text(l10n.settingsComposerShowCatalogTitle),
            subtitle: Text(l10n.settingsComposerShowCatalogSubtitle),
            value: visibility.showCatalogPicker,
            onChanged: notifier.setCatalogPickerVisible,
          ),
          const Divider(height: 1),
          SwitchListTile(
            secondary: PrideColoredLeading(
              icon: Icons.texture_outlined,
              color: prideSettingsIconColor(4),
            ),
            title: Text(l10n.settingsComposerShowClothBlockTitle),
            subtitle: Text(l10n.settingsComposerShowClothBlockSubtitle),
            value: visibility.showClothBlock,
            onChanged: notifier.setClothBlockVisible,
          ),
        ],
      ),
    );
  }
}
