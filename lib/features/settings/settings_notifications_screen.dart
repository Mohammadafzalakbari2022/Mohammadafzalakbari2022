import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/dev_shop_constants.dart';
import '../../data/providers/local_data_providers.dart';
import 'settings_providers.dart';

/// Notifications inbox (plan-15). Local store; tap marks read.
class SettingsNotificationsScreen extends ConsumerWidget {
  const SettingsNotificationsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
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
                await repo.markAllRead(kDevShopId);
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
            onChanged: (v) =>
                ref.read(notificationsMutedProvider.notifier).state = v,
          ),
          const SizedBox(height: 16),
          Text(
            l10n.settingsNotificationsFiltersTitle,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              Chip(
                avatar: const Icon(Icons.filter_alt_outlined, size: 18),
                label: Text(l10n.settingsNotifFilterAll),
              ),
              Chip(label: Text(l10n.settingsNotifFilterOrders)),
              Chip(label: Text(l10n.settingsNotifFilterLicense)),
              Chip(label: Text(l10n.settingsNotifFilterBackup)),
            ],
          ),
          const SizedBox(height: 24),
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
              return Column(
                children: [
                  for (var i = 0; i < items.length; i++) ...[
                    if (i > 0) const Divider(height: 1),
                    ListTile(
                      title: Text(
                        items[i].title,
                        style: items[i].isRead
                            ? Theme.of(context).textTheme.bodyLarge
                            : Theme.of(context).textTheme.titleSmall,
                      ),
                      subtitle: Text(
                        '${AppCalendarFormat.dateTimeMedium(l10n, calendar, items[i].createdAt, locale)}\n${items[i].body}',
                      ),
                      isThreeLine: true,
                      trailing: items[i].isRead
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
                        await repo.markRead(items[i].internalId);
                        if (!context.mounted) return;
                        final oid = items[i].relatedOrderInternalId;
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
