import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/providers/local_data_providers.dart';
import '../../shell/shell_sync_providers.dart';

/// Sync & diagnostics shell (plan-15).
class SettingsSyncDiagnosticsScreen extends ConsumerWidget {
  const SettingsSyncDiagnosticsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
              leading: const Icon(Icons.outbox_outlined),
              title: Text(l10n.settingsSyncOutboxPlaceholderTitle),
              subtitle: Text(l10n.settingsSyncOutboxPlaceholderSubtitle),
              trailing: const Icon(Icons.chevron_right),
              onTap: null,
            ),
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text(l10n.settingsDiagnosticsExportSoon)),
              );
            },
            icon: const Icon(Icons.ios_share_outlined),
            label: Text(l10n.settingsDiagnosticsExportCta),
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
