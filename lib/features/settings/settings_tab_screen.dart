import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/feedback/notification_sound_bridge.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/admin_me_provider.dart';
import '../../auth/auth_providers.dart';
import '../../auth/developer_portal_gate.dart';
import '../../auth/sign_out.dart';
import '../../licensing/license_notifier.dart';
import '../../licensing/license_providers.dart';
import '../catalog/catalog_sharing_provider.dart';
import 'settings_owner_access.dart';
import 'settings_providers.dart';
import 'shop_profile_provider.dart';

class _SettingsSection extends StatelessWidget {
  const _SettingsSection({required this.title, required this.children});

  final String title;
  final List<Widget> children;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleSmall?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: scheme.onSurface,
                ),
          ),
        ),
        const SizedBox(height: 8),
        DecoratedBox(
          decoration: BoxDecoration(
            color: scheme.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: scheme.primary.withValues(alpha: 0.38),
              width: 1.5,
            ),
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: Column(children: children),
          ),
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
    required this.iconColor,
    this.onTap,
  });

  final IconData leading;
  final String title;
  final String subtitle;
  final bool enabled;
  final Color iconColor;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: PrideColoredLeading(icon: leading, color: iconColor),
      title: Text(title),
      subtitle: Text(subtitle),
      trailing: enabled
          ? Icon(Icons.chevron_right, color: iconColor.withValues(alpha: 0.7))
          : Icon(Icons.lock, color: Theme.of(context).colorScheme.outline),
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
    final auth = ref.watch(authSessionProvider);
    final apiOn = PrideApiConfig.isConfigured;
    final adminAsync = ref.watch(adminMeProvider);
    final adminCheck = adminAsync.valueOrNull;
    final persistedDev = ref.watch(persistedDeveloperPortalProvider);
    final showDeveloperPortalEntry = showDeveloperPortalInSettings(
      auth: auth,
      adminCheck: adminCheck,
      devSimulated: devSimulated,
      persistedDeveloperFlag: persistedDev,
    );
    final showAdminCheckFailed = apiOn &&
        auth.hasApiSession &&
        !devSimulated &&
        adminAsync.hasValue &&
        adminCheck != null &&
        adminCheck.checkFailed;

    final effectiveOwner = settingsEffectiveShopOwner(
      auth: auth,
      devOwnerSimulated: isOwnerDev,
      devDeveloperSimulated: devSimulated,
      adminCheck: adminCheck,
      clientDeveloperLoginMatch: PrideApiConfig.isDeveloperLogin(
        shopId: auth.shopId,
        username: auth.username,
      ),
    );
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
              iconColor: prideSettingsIconColor(0),
              title: l10n.settingsShopTileTitle,
              subtitle: shopSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/shop'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.card_membership_outlined,
              iconColor: prideSettingsIconColor(6),
              title: l10n.subscriptionTitle,
              subtitle: l10n.subscriptionListTileSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/subscription'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.person_outline,
              iconColor: prideSettingsIconColor(5),
              title: l10n.settingsCurrentUserTitle,
              subtitle: userSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/account'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.straighten_outlined,
              iconColor: prideSettingsIconColor(1),
              title: l10n.settingsMeasurementTypesTitle,
              subtitle: l10n.settingsMeasurementTypesSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/measurement-types'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.style_outlined,
              iconColor: prideSettingsIconColor(2),
              title: l10n.settingsStyleTileTitle,
              subtitle: l10n.settingsStyleTileSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/style'),
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.texture_outlined,
              iconColor: prideSettingsIconColor(2),
              title: l10n.settingsFabricHubTitle,
              subtitle: l10n.settingsFabricHubSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/fabric'),
            ),
            const Divider(height: 1),
            SwitchListTile(
              secondary: PrideColoredLeading(
                icon: Icons.share_outlined,
                color: prideSettingsIconColor(3),
              ),
              title: Text(l10n.catalogSharingToggleTitle),
              subtitle: Text(l10n.catalogSharingToggleSubtitle),
              value: ref.watch(catalogSharingEnabledProvider),
              onChanged: (v) =>
                  ref.read(catalogSharingEnabledProvider.notifier).set(v),
            ),
            const Divider(height: 1),
            ListTile(
              leading: PrideColoredLeading(
                icon: Icons.logout,
                color: Theme.of(context).extension<PrideActionColors>()!.delete,
              ),
              title: Text(l10n.settingsSignOutTitle),
              subtitle: Text(l10n.settingsSignOutSubtitle),
              onTap: () => showSignOutConfirmation(context, ref),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionUsers,
          children: [
            _LockedTile(
              leading: Icons.group_outlined,
              iconColor: prideSettingsIconColor(7),
              title: l10n.settingsUsersTitle,
              subtitle: apiOn && auth.hasApiSession
                  ? (auth.isShopOwner
                      ? l10n.settingsUsersSubtitleOwner
                      : l10n.settingsUsersSubtitleTeam)
                  : (apiOn
                      ? l10n.settingsUsersTileNeedApiSession
                      : (isOwnerDev
                          ? l10n.settingsUsersSubtitleOwner
                          : l10n.settingsOwnerOnly)),
              enabled: apiOn && auth.hasApiSession,
              onTap: () => context.push('/app/settings/users'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionNotifications,
          children: [
            SwitchListTile(
              secondary: PrideColoredLeading(
                icon: Icons.notifications_off_outlined,
                color: prideSettingsIconColor(9),
              ),
              title: Text(l10n.settingsMuteNotificationsTitle),
              subtitle: Text(l10n.settingsMuteNotificationsSubtitle),
              value: ref.watch(notificationsMutedProvider),
              onChanged: (v) async {
                ref.read(notificationsMutedProvider.notifier).state = v;
                await persistNotificationsMuted(
                  ref.read(sharedPreferencesProvider),
                  v,
                );
                NotificationSoundBridge.configure(
                  soundsEnabled: ref.read(uiSoundsEnabledProvider),
                  muted: v,
                );
              },
            ),
            const Divider(height: 1),
            _LockedTile(
              leading: Icons.inbox_outlined,
              iconColor: prideSettingsIconColor(0),
              title: l10n.settingsNotificationsInboxTitle,
              subtitle: l10n.settingsNotificationsInboxSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/notifications'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionPrinter,
          children: [
            _LockedTile(
              leading: Icons.print_outlined,
              iconColor: prideSettingsIconColor(1),
              title: l10n.settingsPrinterTileTitle,
              subtitle: l10n.settingsPrinterTileSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/printer'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionBackupRestore,
          children: [
            _LockedTile(
              leading: Icons.backup_outlined,
              iconColor: prideSettingsIconColor(8),
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
          title: l10n.settingsSectionAppearanceLanguage,
          children: [
            _LockedTile(
              leading: Icons.palette_outlined,
              iconColor: prideSettingsIconColor(3),
              title: l10n.settingsAppearanceLanguageTitle,
              subtitle: l10n.settingsAppearanceLanguageSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/appearance-language'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionSyncDiagnostics,
          children: [
            _LockedTile(
              leading: Icons.sync_outlined,
              iconColor: prideSettingsIconColor(2),
              title: l10n.settingsSyncDiagnosticsTitle,
              subtitle: l10n.settingsSyncDiagnosticsSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/sync-diagnostics'),
            ),
            _LockedTile(
              leading: Icons.compare_arrows_outlined,
              iconColor: prideSettingsIconColor(2),
              title: l10n.settingsSyncConflictsTile,
              subtitle: l10n.settingsSyncConflictsTileSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/sync-conflicts'),
            ),
          ],
        ),
        const SizedBox(height: 16),
        _SettingsSection(
          title: l10n.settingsSectionAbout,
          children: [
            _LockedTile(
              leading: Icons.info_outline,
              iconColor: prideSettingsIconColor(4),
              title: l10n.settingsAboutTitle,
              subtitle: l10n.settingsAboutSubtitle,
              enabled: true,
              onTap: () => context.push('/app/settings/about'),
            ),
          ],
        ),
        if (showDeveloperPortalEntry || showAdminCheckFailed) ...[
          const SizedBox(height: 16),
          _SettingsSection(
            title: l10n.settingsSectionDeveloper,
            children: [
              if (showAdminCheckFailed)
                ListTile(
                  leading: PrideColoredLeading(
                    icon: Icons.cloud_off_outlined,
                    color: prideSettingsIconColor(5),
                  ),
                  title: Text(l10n.settingsDeveloperPortalCheckFailed),
                  trailing: TextButton(
                    onPressed: () => ref.invalidate(adminMeProvider),
                    child: Text(l10n.settingsDeveloperPortalRetry),
                  ),
                ),
              if (showDeveloperPortalEntry)
                _LockedTile(
                  leading: Icons.developer_mode_outlined,
                  iconColor: prideSettingsIconColor(5),
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
