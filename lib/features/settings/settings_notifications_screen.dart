import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/feedback/notification_sound_bridge.dart';
import 'package:pride_v3/core/persistence/shared_preferences_provider.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';
import 'app_notification_inbox_filter.dart';
import 'settings_providers.dart';

/// Notifications inbox (plan-15). Local store; tap marks read.
class SettingsNotificationsScreen extends ConsumerStatefulWidget {
  const SettingsNotificationsScreen({super.key});

  @override
  ConsumerState<SettingsNotificationsScreen> createState() =>
      _SettingsNotificationsScreenState();
}

class _SettingsNotificationsScreenState
    extends ConsumerState<SettingsNotificationsScreen> {
  AppNotificationInboxFilter _filter = AppNotificationInboxFilter.all;

  void _openInboxFilterSheet(AppLocalizations l10n) {
    var draft = _filter;
    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return SafeArea(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.settingsNotificationsFiltersTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 12),
                    RadioGroup<AppNotificationInboxFilter>(
                      groupValue: draft,
                      onChanged: (v) => setModal(() => draft = v!),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          for (final f in AppNotificationInboxFilter.values)
                            RadioListTile<AppNotificationInboxFilter>(
                              title: Text(_inboxFilterLabel(l10n, f)),
                              value: f,
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    FilledButton(
                      onPressed: () {
                        setState(() => _filter = draft);
                        Navigator.of(sheetContext).pop();
                      },
                      child: Text(l10n.ordersFilterApply),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  String _inboxFilterLabel(
    AppLocalizations l10n,
    AppNotificationInboxFilter f,
  ) {
    switch (f) {
      case AppNotificationInboxFilter.all:
        return l10n.settingsNotifFilterAll;
      case AppNotificationInboxFilter.orders:
        return l10n.settingsNotifFilterOrders;
      case AppNotificationInboxFilter.license:
        return l10n.settingsNotifFilterLicense;
      case AppNotificationInboxFilter.backup:
        return l10n.settingsNotifFilterBackup;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final muted = ref.watch(notificationsMutedProvider);
    final async = ref.watch(appNotificationsStreamProvider);

    final unread = async.maybeWhen(
      data: (list) => list.where((n) => !n.isRead).length,
      orElse: () => 0,
    );

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.settingsNotificationsInboxTitle),
        actions: [
          if (unread > 0)
            TextButton(
              onPressed: () async {
                final repo =
                    await ref.read(appNotificationRepositoryProvider.future);
                await repo.markAllRead(ref.read(effectiveShopIdProvider));
              },
              child: Text(l10n.settingsNotifMarkAllRead),
            ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          SwitchListTile.adaptive(
            secondary: const Icon(Icons.notifications_off_outlined),
            title: Text(l10n.settingsMuteNotificationsTitle),
            subtitle: Text(l10n.settingsMuteNotificationsSubtitle),
            value: muted,
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
          Align(
            alignment: Alignment.centerRight,
            child: IconButton(
              tooltip: l10n.listToolbarFilterTooltip,
              icon: Badge(
                isLabelVisible: _filter != AppNotificationInboxFilter.all,
                smallSize: 8,
                child: Icon(
                  _filter != AppNotificationInboxFilter.all
                      ? Icons.filter_list
                      : Icons.filter_list_outlined,
                ),
              ),
              onPressed: () => _openInboxFilterSheet(l10n),
            ),
          ),
          const SizedBox(height: 8),
          async.when(
            loading: () => const Center(
              child: Padding(
                padding: EdgeInsets.all(24),
                child: CircularProgressIndicator(),
              ),
            ),
            error: (e, _) => Center(child: Text('$e')),
            data: (items) {
              if (items.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Icon(
                          Icons.inbox_outlined,
                          size: 48,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.settingsNotificationsInboxEmpty,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodyLarge,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          l10n.settingsNotificationsInboxEmptyHint,
                          textAlign: TextAlign.center,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                );
              }
              final filtered = items
                  .where((n) => n.matchesInboxFilter(_filter))
                  .toList();
              if (filtered.isEmpty) {
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      l10n.settingsNotificationsInboxFilterEmpty,
                      textAlign: TextAlign.center,
                      style: Theme.of(context).textTheme.bodyLarge,
                    ),
                  ),
                );
              }
              return Column(
                children: [
                  for (var i = 0; i < filtered.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      title: Text(
                        filtered[i].title,
                        style: filtered[i].isRead
                            ? Theme.of(context).textTheme.bodyLarge
                            : Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Text(
                        '${AppCalendarFormat.dateTimeMedium(l10n, calendar, filtered[i].createdAt, locale)}\n${filtered[i].body}',
                      ),
                      isThreeLine: true,
                      trailing: filtered[i].isRead
                          ? null
                          : Icon(
                              Icons.circle,
                              size: 10,
                              color: Theme.of(context).colorScheme.primary,
                            ),
                      onTap: () async {
                        final repo = await ref.read(
                          appNotificationRepositoryProvider.future,
                        );
                        await repo.markRead(filtered[i].internalId);
                        if (!context.mounted) return;
                        final oid = filtered[i].relatedOrderInternalId;
                        if (oid != null && oid.isNotEmpty) {
                          context.push('/app/orders/$oid');
                        }
                      },
                    ),
                  ],
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}
