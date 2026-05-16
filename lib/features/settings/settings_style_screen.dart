import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

class SettingsStyleScreen extends StatelessWidget {
  const SettingsStyleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
