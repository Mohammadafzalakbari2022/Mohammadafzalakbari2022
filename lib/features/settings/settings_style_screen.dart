import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import 'style/settings_style_garment_provider.dart';
import 'style/settings_style_garment_selector.dart';

class SettingsStyleScreen extends ConsumerWidget {
  const SettingsStyleScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final garment = ref.watch(settingsStyleGarmentProvider);
    final libraryTitle = garment == GarmentType.waistcoat
        ? l10n.settingsStyleWaistcoatLibraryTitle
        : l10n.settingsStylePerahanLibraryTitle;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsStyleHubTitle),
      ),
      body: ListView(
        children: [
          const SettingsStyleGarmentSelector(),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
            child: Text(
              libraryTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
          ),
          ListTile(
            leading: const Icon(Icons.style_outlined),
            title: Text(l10n.settingsStyleNamesTitle),
            subtitle: Text(l10n.settingsStyleNamesSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/style/names'),
          ),
          const Divider(height: 1),
          ListTile(
            leading: const Icon(Icons.image_outlined),
            title: Text(l10n.settingsStyleFiguresTitle),
            subtitle: Text(l10n.settingsStyleFiguresSubtitle),
            trailing: const Icon(Icons.chevron_right),
            onTap: () => context.push('/app/settings/style/figures'),
          ),
        ],
      ),
    );
  }
}
