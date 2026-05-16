import 'dart:convert';

import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:pride_v3/core/api/pride_api_config.dart';
import 'package:pride_v3/core/api/pride_api_devices.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/diagnostics/diagnostics_export_payload.dart';
import 'package:pride_v3/core/diagnostics/diagnostics_share.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/core/persistence/sync_diagnostics_storage.dart';
import 'package:pride_v3/core/sync/manual_sync_runner.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:pride_v3/licensing/license_notifier.dart';
import 'package:pride_v3/licensing/license_providers.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';
import '../../shell/shell_sync_providers.dart';
import 'settings_api_connection_card.dart';

String _asyncListLen<T>(AsyncValue<List<T>> v, String loading) {
  return v.maybeWhen(data: (l) => '${l.length}', orElse: () => loading);
}

/// Sync & diagnostics shell (plan-15).
class SettingsSyncDiagnosticsScreen extends ConsumerStatefulWidget {
  const SettingsSyncDiagnosticsScreen({super.key});

  @override
  ConsumerState<SettingsSyncDiagnosticsScreen> createState() =>
      _SettingsSyncDiagnosticsScreenState();
}

class _SettingsSyncDiagnosticsScreenState
    extends ConsumerState<SettingsSyncDiagnosticsScreen> {
  bool _syncBusy = false;
  bool _exportBusy = false;
  final _pushTokenCtrl = TextEditingController();
  String _pushPlatform = 'android';
  bool _pushBusy = false;

  @override
  void dispose() {
    _pushTokenCtrl.dispose();
    super.dispose();
  }

  String _licenseStatusExport() {
    final s = ref.read(licenseNotifierProvider).status;
    return switch (s) {
      LicenseStatus.trialActive => 'trial_active',
      LicenseStatus.active => 'active',
      LicenseStatus.expired => 'expired',
    };
  }

  int _listCount<T>(AsyncValue<List<T>> v) =>
      v.maybeWhen(data: (list) => list.length, orElse: () => 0);

  Future<void> _exportDiagnostics() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final locale = Localizations.localeOf(context).toString();
    setState(() => _exportBusy = true);
    try {
      final info = await PackageInfo.fromPlatform();
      if (!mounted) return;
      final auth = ref.read(authSessionProvider);
      final online = ref.read(connectivityOnlineProvider);
      final base = PrideApiConfig.normalizedBase;
      String? apiHost;
      if (base != null) {
        try {
          apiHost = Uri.parse(base).host;
        } catch (_) {
          apiHost = null;
        }
      }
      final authMode = auth.hasApiSession
          ? 'api'
          : auth.authenticated
              ? 'local'
              : 'none';

      final lastSync = ref.read(lastSuccessfulSyncAtProvider);
      final shopId = ref.read(effectiveShopIdProvider);
      final snapshot = DiagnosticsExportSnapshot(
        appName: info.appName,
        appVersion: info.version,
        buildNumber: info.buildNumber,
        isWeb: kIsWeb,
        defaultTargetPlatformName: defaultTargetPlatform.name,
        locale: locale,
        connectivityOnline: online,
        apiBaseConfigured: PrideApiConfig.isConfigured,
        apiBaseHost: apiHost,
        authMode: authMode,
        authHasSession: auth.authenticated,
        shopId: auth.shopId,
        isShopOwner: auth.isShopOwner,
        licenseStatus: _licenseStatusExport(),
        lastSuccessfulSyncUtcIso: lastSync?.toUtc().toIso8601String(),
        outboxPendingCount: ref
            .read(syncPendingOutboxCountProvider)
            .maybeWhen(data: (n) => n, orElse: () => 0),
        countOrders: _listCount(ref.read(ordersListStreamProvider)),
        countCustomers: _listCount(ref.read(customersListStreamProvider)),
        countPayments: _listCount(ref.read(paymentsForShopProvider(shopId))),
        countTasks: _listCount(ref.read(tasksForShopProvider(shopId))),
        countNotifications:
            _listCount(ref.read(appNotificationsStreamProvider)),
        countUnreadNotifications: ref.read(unreadAppNotificationCountProvider),
      );

      final json = const JsonEncoder.withIndent('  ')
          .convert(buildDiagnosticsExportMap(snapshot));
      final stamp = DateTime.now()
          .toUtc()
          .toIso8601String()
          .replaceAll(':', '-')
          .split('.')
          .first;
      final filename = 'pride-diagnostics-$stamp.json';
      await shareDiagnosticsBundle(json, filename);
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsDiagnosticsExportSuccess)),
      );
    } catch (e) {
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsDiagnosticsExportError('$e'))),
      );
    } finally {
      if (mounted) setState(() => _exportBusy = false);
    }
  }

  Future<void> _onRetrySync() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    if (!ref.read(connectivityOnlineProvider)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsSyncRetryOffline)),
      );
      return;
    }
    if (!PrideApiConfig.isConfigured) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsSyncRetryConfigureApi)),
      );
      return;
    }
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (!auth.hasApiSession || token == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsSyncRetrySignIn)),
      );
      return;
    }
    if (ref.read(licenseEditingBlockedProvider)) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsSyncRetryEditingBlocked)),
      );
      return;
    }
    setState(() => _syncBusy = true);
    try {
      final repo = await ref.read(syncOutboxRepositoryProvider.future);
      final notifRepo = await ref.read(appNotificationRepositoryProvider.future);
      final customersRepo = await ref.read(customerListRepositoryProvider.future);
      final tasksRepo = await ref.read(taskRepositoryProvider.future);
      final paymentsRepo = await ref.read(paymentRepositoryProvider.future);
      final ordersRepo = await ref.read(orderListRepositoryProvider.future);
      final measurementRepo =
          await ref.read(measurementProfileRepositoryProvider.future);
      final catalogRepo = await ref.read(catalogRepositoryProvider.future);
      final styleCatalogRepo =
          await ref.read(styleCatalogRepositoryProvider.future);
      final prefs = ref.read(sharedPreferencesProvider);
      final syncShopId = ref.read(effectiveShopIdProvider);
      final outcome = await runManualSyncWithOutbox(
        outboxRepo: repo,
        accessToken: token,
        prefs: prefs,
        syncShopId: syncShopId,
        notifications: notifRepo,
        customers: customersRepo,
        tasks: tasksRepo,
        payments: paymentsRepo,
        orders: ordersRepo,
        measurementProfiles: measurementRepo,
        catalog: catalogRepo,
        styleCatalog: styleCatalogRepo,
      );
      if (!mounted) return;
      switch (outcome) {
        case ManualSyncSuccess(
            :final pushedMutationCount,
            :final remoteChangeCount,
          ):
          final at = DateTime.now();
          ref.read(lastSuccessfulSyncAtProvider.notifier).state = at;
          await SyncDiagnosticsStorage.recordSuccessfulSync(
            ref.read(sharedPreferencesProvider),
            at,
          );
          messenger.showSnackBar(
            SnackBar(
              content: Text(
                l10n.settingsSyncRetrySuccess(
                  pushedMutationCount,
                  remoteChangeCount,
                ),
              ),
            ),
          );
        case ManualSyncFailure(:final message):
          if (message == 'license_expired') {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.settingsSyncRetryLicenseExpired)),
            );
          } else {
            messenger.showSnackBar(
              SnackBar(content: Text(l10n.settingsSyncRetryFailed(message))),
            );
          }
      }
    } finally {
      if (mounted) setState(() => _syncBusy = false);
    }
  }

  Future<void> _registerPushToken() async {
    final l10n = AppLocalizations.of(context)!;
    final messenger = ScaffoldMessenger.of(context);
    final auth = ref.read(authSessionProvider);
    final token = auth.accessToken;
    if (!auth.hasApiSession || token == null) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.settingsSyncRetrySignIn)),
      );
      return;
    }
    final raw = _pushTokenCtrl.text.trim();
    if (raw.isEmpty) {
      messenger.showSnackBar(
        SnackBar(content: Text(l10n.loginFieldRequired)),
      );
      return;
    }
    setState(() => _pushBusy = true);
    try {
      final ok = await postPrideApiPushToken(
        accessToken: token,
        token: raw,
        platform: _pushPlatform,
      );
      if (!mounted) return;
      messenger.showSnackBar(
        SnackBar(
          content: Text(
            ok ? l10n.settingsPushRegisterOk : l10n.settingsPushRegisterFail,
          ),
        ),
      );
    } finally {
      if (mounted) setState(() => _pushBusy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final lastSync = ref.watch(lastSuccessfulSyncAtProvider);
    final queuedAsync = ref.watch(syncPendingOutboxCountProvider);
    final queued =
        queuedAsync.maybeWhen(data: (n) => n, orElse: () => 0);
    final entriesAsync = ref.watch(syncPendingOutboxEntriesProvider);
    final online = ref.watch(connectivityOnlineProvider);

    final lastSyncSubtitle = lastSync == null
        ? l10n.settingsSyncLastSyncNever
        : AppCalendarFormat.dateTimeMedium(l10n, calendar, lastSync, locale);

    final queueSubtitle = queued == 0
        ? l10n.settingsSyncQueuedZero
        : l10n.settingsSyncQueuedCount(queued);

    final shopId = ref.watch(effectiveShopIdProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final customersAsync = ref.watch(customersListStreamProvider);
    final paymentsAsync = ref.watch(paymentsForShopProvider(shopId));
    final tasksAsync = ref.watch(tasksForShopProvider(shopId));
    final notificationsAsync = ref.watch(appNotificationsStreamProvider);
    final unread = ref.watch(unreadAppNotificationCountProvider);
    final loading = l10n.devPortalDiagCountLoading;

    return Scaffold(
      appBar: AppBar(title: Text(l10n.settingsSyncDiagnosticsTitle)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!online) ...[
            Card(
              color: Theme.of(context).colorScheme.errorContainer,
              child: ListTile(
                leading: Icon(
                  Icons.wifi_off_outlined,
                  color: Theme.of(context).colorScheme.onErrorContainer,
                ),
                title: Text(l10n.shellSyncTooltipOffline),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Card(
            child: Column(
              children: [
                ListTile(
                  leading: Icon(
                    online ? Icons.wifi_outlined : Icons.wifi_off_outlined,
                  ),
                  title: Text(l10n.settingsNetworkStatusTitle),
                  subtitle: Text(
                    online
                        ? l10n.settingsNetworkStatusOnline
                        : l10n.settingsNetworkStatusOffline,
                  ),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.sync_outlined),
                  title: Text(l10n.settingsSyncLastSyncTitle),
                  subtitle: Text(lastSyncSubtitle),
                ),
                const Divider(height: 1),
                ListTile(
                  leading: const Icon(Icons.queue_outlined),
                  title: Text(l10n.settingsSyncQueuedTitle),
                  subtitle: Text(queueSubtitle),
                ),
              ],
            ),
          ),
          const SizedBox(height: 12),
          const SettingsApiConnectionCard(),
          const SizedBox(height: 12),
          Card(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Text(
                    l10n.settingsPushTokenTitle,
                    style: Theme.of(context).textTheme.titleSmall,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    l10n.settingsPushTokenHint,
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                  const SizedBox(height: 12),
                  TextField(
                    controller: _pushTokenCtrl,
                    decoration: InputDecoration(
                      labelText: l10n.settingsPushTokenFieldLabel,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    l10n.settingsPushPlatformLabel,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  const SizedBox(height: 8),
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final p in const [
                        'android',
                        'ios',
                        'web',
                        'unknown',
                      ])
                        ChoiceChip(
                          label: Text(p),
                          selected: _pushPlatform == p,
                          onSelected: _pushBusy
                              ? null
                              : (_) => setState(() => _pushPlatform = p),
                        ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: _pushBusy ? null : _registerPushToken,
                    child: _pushBusy
                        ? const SizedBox(
                            height: 22,
                            width: 22,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : Text(l10n.settingsPushRegisterCta),
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsSyncLocalSnapshotTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: Column(
              children: [
                ListTile(
                  title: Text(l10n.settingsSyncLocalOrders),
                  trailing: Text(_asyncListLen(ordersAsync, loading)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.settingsSyncLocalCustomers),
                  trailing: Text(_asyncListLen(customersAsync, loading)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.settingsSyncLocalPayments),
                  trailing: Text(_asyncListLen(paymentsAsync, loading)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.settingsSyncLocalTasks),
                  trailing: Text(_asyncListLen(tasksAsync, loading)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.settingsSyncLocalNotifications),
                  trailing: Text(_asyncListLen(notificationsAsync, loading)),
                ),
                const Divider(height: 1),
                ListTile(
                  title: Text(l10n.settingsSyncLocalUnread),
                  trailing: Text('$unread'),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsSyncOutboxPendingListTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          entriesAsync.when(
            data: (entries) {
              if (entries.isEmpty) {
                return Text(
                  l10n.settingsSyncOutboxPendingEmpty,
                  style: Theme.of(context).textTheme.bodySmall,
                );
              }
              return Card(
                child: Column(
                  children: [
                    for (var i = 0; i < entries.length; i++) ...[
                      if (i > 0) const Divider(height: 1),
                      ListTile(
                        dense: true,
                        leading: const Icon(Icons.pending_outlined, size: 20),
                        title: Text(
                          entries[i].kind,
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                        subtitle: Text(
                          entries[i].entityRef.isEmpty
                              ? AppCalendarFormat.dateTimeMedium(
                                  l10n,
                                  calendar,
                                  entries[i].queuedAt,
                                  locale,
                                )
                              : '${entries[i].entityRef} · ${AppCalendarFormat.dateTimeMedium(
                                  l10n,
                                  calendar,
                                  entries[i].queuedAt,
                                  locale,
                                )}',
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ),
                    ],
                  ],
                ),
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsSyncOutboxTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.cloud_upload_outlined),
              title: Text(l10n.settingsSyncRetryTitle),
              subtitle: Text(l10n.settingsSyncRetrySubtitle),
              trailing: _syncBusy
                  ? const SizedBox(
                      width: 28,
                      height: 28,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.chevron_right),
              onTap: _syncBusy ? null : _onRetrySync,
            ),
          ),
          const SizedBox(height: 8),
          Card(
            child: ListTile(
              leading: const Icon(Icons.outbox_outlined),
              title: Text(l10n.settingsSyncOutboxPlaceholderTitle),
              subtitle: Text(l10n.settingsSyncOutboxPlaceholderSubtitle),
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _exportBusy ? null : _exportDiagnostics,
            icon: _exportBusy
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                : const Icon(Icons.ios_share_outlined),
            label: Text(
              _exportBusy
                  ? l10n.settingsDiagnosticsExportBusy
                  : l10n.settingsDiagnosticsExportCta,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            l10n.settingsSyncDiagnosticsFooter,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
