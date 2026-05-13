import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Users management shell (plan-15). Full CRUD when API exists.
class SettingsUsersScreen extends StatelessWidget {
  const SettingsUsersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsUsersTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    l10n.settingsUsersLimitsTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 8),
                  Text(l10n.settingsUsersLimitsBody),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: null,
            icon: const Icon(Icons.person_add_alt_1),
            label: Text(l10n.settingsUsersAddCta),
          ),
          Text(
            l10n.settingsUsersAddDisabledHint,
            style: Theme.of(context).textTheme.bodySmall,
          ),
          const SizedBox(height: 24),
          Text(
            l10n.settingsUsersListTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.shield_outlined),
                  title: Text(l10n.settingsUsersOwnerRowTitle),
                  subtitle: Text(l10n.settingsUsersOwnerRowSubtitle),
                  trailing: Chip(
                    label: Text(l10n.settingsRoleOwner),
                    visualDensity: VisualDensity.compact,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.people_outline),
                  title: Text(l10n.settingsUsersEmptyRowTitle),
                  subtitle: Text(l10n.settingsUsersEmptyRowSubtitle),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
