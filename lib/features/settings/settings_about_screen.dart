import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

class SettingsAboutScreen extends StatefulWidget {
  const SettingsAboutScreen({super.key});

  @override
  State<SettingsAboutScreen> createState() => _SettingsAboutScreenState();
}

class _SettingsAboutScreenState extends State<SettingsAboutScreen> {
  PackageInfo? _info;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final info = await PackageInfo.fromPlatform();
    if (!mounted) return;
    setState(() => _info = info);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final info = _info;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsAboutTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.apps_outlined),
                  title: Text(l10n.appTitle),
                  subtitle: Text(l10n.settingsAboutSubtitle),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.tag_outlined),
                  title: Text(l10n.settingsVersionTitle),
                  subtitle: Text(
                    info == null
                        ? l10n.loading
                        : '${info.version}+${info.buildNumber}',
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(l10n.settingsBuildTitle),
                  subtitle: Text(info?.packageName ?? l10n.loading),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

