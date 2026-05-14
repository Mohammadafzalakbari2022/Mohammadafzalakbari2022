import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/admin_me_provider.dart';
import '../../auth/auth_providers.dart';
import '../../auth/auth_session_storage.dart';
import '../../core/persistence/shared_preferences_provider.dart';
import '../../core/persistence/sync_cursor_storage.dart';
import '../../core/persistence/sync_diagnostics_storage.dart';
import '../../shell/shell_sync_providers.dart';
import '../../licensing/license_notifier.dart';
import '../../licensing/license_providers.dart';
import 'settings_providers.dart';
import 'shop_profile_provider.dart';

Future<void> _showSignOutDialog(BuildContext context, WidgetRef ref) async {
  final l10n = AppLocalizations.of(context)!;
  final confirmed = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.settingsSignOutDialogTitle),
      content: Text(l10n.settingsSignOutDialogBody),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(ctx, false),
          child: Text(l10n.settingsSignOutCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.pop(ctx, true),
          child: Text(l10n.settingsSignOutConfirm),
        ),
      ],
    ),
  );
  if (confirmed == true && context.mounted) {
    final prefs = ref.read(sharedPreferencesProvider);
    final sid = ref.read(authSessionProvider).shopId?.trim();
    await AuthSessionStorage.clear(prefs);
    if (sid != null && sid.isNotEmpty) {
      await SyncCursorStorage.clearForShop(prefs, sid);
    }
    await SyncDiagnosticsStorage.clear(prefs);
    ref.read(lastSuccessfulSyncAtProvider.notifier).state = null;
    ref.read(authSessionProvider).signOut();
  }
}

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall,
          ),
        ),
        const SizedBox(height: 8),
        Card(
          clipBehavior: Clip.antiAlias,
          child: Column(children: children),
        ),
      ],
    );
  }
}

class _LockedTile extends StatelessWidget {
  const _LockedTile({
    required this.leading,
    required this.title,
    required this.subtitle,
    required this.enabled,
    this.onTap,
  });

  final IconData leading;
  final String title;
  final String subtitle;
  final bool enabled;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Icon(leading),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: enabled ? const Icon(Icons.chevron_right) : const Icon(Icons.lock),
      enabled: enabled,
      onTap: enabled ? onTap : null,
    );
  }
}

/// Settings tab root: navigation + dev-only license simulator (plan-06 / plan-19).
class SettingsTabScreen extends ConsumerWidget {
  const SettingsTabScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final license = ref.watch(licenseNotifierProvider);
    final isOwnerDev = ref.watch(isOwnerProvider);
    final devSimulated = ref.watch(isDeveloperProvider);
    final serverDeveloper =
        ref.watch(adminMeProvider).valueOrNull?.isDeveloper == true;
    final showDeveloperPortalEntry = devSimulated || serverDeveloper;

    final auth = ref.watch(authSessionProvider);
    final effectiveOwner =
        auth.hasApiSession ? auth.isShopOwner : isOwnerDev;
    final apiOn = PrideApiConfig.isConfigured;
    final roleLabel =
        effectiveOwner ? l10n.settingsRoleOwner : l10n.settingsRoleUser;
    final shopAsync = ref.watch(shopProfileProvider);
    final shopSubtitle = shopAsync.maybeWhen(
      data: (s) {
        final n = s.name.trim();
        return n.isNotEmpty ? n : l10n.settingsShopTileSubtitle;
      },
      orElse: () => l10n.settingsShopTileSubtitle,
    );

    final userSubtitle = () {
      final u = auth.username?.trim();
      if (u == null || u.isEmpty) {
        return '${l10n.settingsCurrentUserGuest} · $roleLabel';
      }
      final sid = auth.shopId;
      if (sid != null && sid.isNotEmpty) {
        return '$u · $roleLabel · ${l10n.settingsShopIdChip(sid)}';
      }
      return '$u · $roleLabel';
    }();

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        _SettingsSection(
          title: l10n.settingsSectionAccountAndShop,
          children: [
            _LockedTile(
              leading: Icons.store_outlined,
              title: l10n.settingsShopTileTitle,
              subtitle: shopSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/shop'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.straighten_outlined,
              title: l10n.settingsMeasurementTypesTitle,
              subtitle: l10n.settingsMeasurementTypesSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/measurement-types'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.checklist_outlined,
              title: l10n.tasksTitle,
              subtitle: l10n.tasksSettingsSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/tasks'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.person_outline,
              title: l10n.settingsCurrentUserTitle,
              subtitle: userSubtitle,
              enabled: false,
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.card_membership_outlined,
              title: l10n.subscriptionTitle,
              subtitle: l10n.subscriptionListTileSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/subscription'),
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout),
              title: Text(l10n.settingsSignOutTitle),
              subtitle: Text(l10n.settingsSignOutSubtitle),
              onTap: () => _showSignOutDialog(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionUsers,
          children: [
            _LockedTile(
              leading: Icons.group_outlined,
              title: l10n.settingsUsersTitle,
              subtitle: apiOn
                  ? (effectiveOwner
                      ? l10n.settingsUsersSubtitleOwner
                      : l10n.settingsUsersSubtitleTeam)
                  : (isOwnerDev
                      ? l10n.settingsUsersSubtitleOwner
                      : l10n.settingsOwnerOnly),
              enabled: apiOn ? auth.authenticated : isOwnerDev,
              onTap: () => context.push('/app/settings/users'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionBackupRestore,
          children: [
            _LockedTile(
              leading: Icons.backup_outlined,
              title: l10n.settingsBackupRestoreTitle,
              subtitle: effectiveOwner
                  ? l10n.settingsBackupRestoreSubtitleOwner
                  : l10n.settingsOwnerOnly,
              enabled: effectiveOwner,
              onTap: () => context.push('/app/settings/backup-restore'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionNotifications,
          children: [
            SwitchListTile(
              secondary: const Icon(Icons.notifications_off_outlined),
              title: Text(l10n.settingsMuteNotificationsTitle),
              subtitle: Text(l10n.settingsMuteNotificationsSubtitle),
              value: ref.watch(notificationsMutedProvider),
              onChanged: (v) =>
                  ref.read(notificationsMutedProvider.notifier).state = v,
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.inbox_outlined,
              title: l10n.settingsNotificationsInboxTitle,
              subtitle: l10n.settingsNotificationsInboxSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/notifications'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionSyncDiagnostics,
          children: [
            _LockedTile(
              leading: Icons.sync_outlined,
              title: l10n.settingsSyncDiagnosticsTitle,
              subtitle: l10n.settingsSyncDiagnosticsSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/sync-diagnostics'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionAppearanceLanguage,
          children: [
            _LockedTile(
              leading: Icons.palette_outlined,
              title: l10n.settingsAppearanceLanguageTitle,
              subtitle: l10n.settingsAppearanceLanguageSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/appearance-language'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionAbout,
          children: [
            _LockedTile(
              leading: Icons.info_outline,
              title: l10n.settingsAboutTitle,
              subtitle: l10n.settingsAboutSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/about'),
            ),
          ],
        ),
        if (showDeveloperPortalEntry) ...[
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.settingsSectionDeveloper,
            children: [
              _LockedTile(
                leading: Icons.developer_mode_outlined,
                title: l10n.settingsDeveloperPortalTitle,
                subtitle: l10n.settingsDeveloperPortalSubtitle,
                enabled: true,
                onTap: () => context.push('/app/settings/developer-portal'),
              ),
            ],
          ),
        ],
        if (kDebugMode) ...[
          const Divider(height: 32),
          Text(
            l10n.licenseDevControlsTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SegmentedButton<LicenseStatus>(
            segments: [
              ButtonSegment(
                value: LicenseStatus.trialActive,
                label: Text(l10n.licenseStatusTrial),
              ),
              ButtonSegment(
                value: LicenseStatus.active,
                label: Text(l10n.licenseStatusPaid),
              ),
              ButtonSegment(
                value: LicenseStatus.expired,
                label: Text(l10n.licenseStatusExpired),
              ),
            ],
            selected: {license.status},
            onSelectionChanged: (s) {
              ref.read(licenseNotifierProvider).setStatus(s.first);
            },
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsDevRolesTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          SwitchListTile(
            title: Text(l10n.settingsDevRoleOwnerTitle),
            subtitle: Text(l10n.settingsDevRoleOwnerSubtitle),
            value: isOwnerDev,
            onChanged: (v) => ref.read(isOwnerProvider.notifier).state = v,
          ),
          SwitchListTile(
            title: Text(l10n.settingsDevRoleDeveloperTitle),
            subtitle: Text(l10n.settingsDevRoleDeveloperSubtitle),
            value: devSimulated,
            onChanged: (v) =>
                ref.read(isDeveloperProvider.notifier).state = v,
          ),
        ],
      ],
    );
  }
}
