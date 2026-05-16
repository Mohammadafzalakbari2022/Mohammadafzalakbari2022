import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../auth/auth_providers.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/local/sync_outbox_repository.dart';
import '../../data/providers/local_data_providers.dart';
import '../../features/reports/report_money_format.dart';
import '../../l10n/app_localizations.dart';
import '../calendar/app_calendar_format.dart';
import '../calendar/date_calendar_notifier.dart';

const _rentNotifPrefix = 'rent-due-';
const _kRentAlertDays = 3;

/// Inserts in-app rent-due notifications when due within [_kRentAlertDays] days.
Future<void> checkRentDueNotifications(WidgetRef ref, AppLocalizations l10n) async {
  final shopId = ref.read(effectiveShopIdProvider);
  final rents = await ref.read(shopRentsStreamProvider(shopId).future);
  final payments =
      await ref.read(shopRentPaymentsStreamProvider(shopId).future);
  final finance = await ref.read(shopFinanceRepositoryProvider.future);
  final notifRepo = await ref.read(appNotificationRepositoryProvider.future);
  final outbox = await ref.read(syncOutboxRepositoryProvider.future);
  final calendar = ref.read(dateCalendarSystemProvider);
  final locale = l10n.localeName;

  final today = DateTime.now();
  final todayDate = DateTime(today.year, today.month, today.day);

  for (final rent in rents) {
    final due = DateTime(rent.dueDate.year, rent.dueDate.month, rent.dueDate.day);
    final daysUntil = due.difference(todayDate).inDays;
    if (daysUntil > _kRentAlertDays) continue;

    final paid = finance.totalPaidForRent(rent.internalId, payments);
    if (paid >= rent.amountMinor) continue;

    final notifId = '$_rentNotifPrefix${rent.internalId}';
    final amount = reportFormatMoney(l10n, rent.amountMinor);
    final dateLabel =
        AppCalendarFormat.mediumDate(l10n, calendar, due, locale);
    final title = l10n.shopFinanceRentDueNotificationTitle;
    final body = l10n.shopFinanceRentDueNotificationBody(amount, dateLabel);

    await notifRepo.append(
      shopId: shopId,
      internalId: notifId,
      title: title,
      body: body,
    );
    await _enqueueNotificationOutbox(outbox, shopId, notifId, title, body);
  }
}

Future<void> _enqueueNotificationOutbox(
  SyncOutboxRepository outbox,
  String shopId,
  String internalId,
  String title,
  String body,
) async {
  await outbox.enqueue(
    shopId: shopId,
    kind: SyncOutboxKinds.notificationAppend,
    entityRef: internalId,
    payloadJson: jsonEncode({
      'title': title,
      'body': body,
      'created_at': DateTime.now().toUtc().toIso8601String(),
    }),
  );
}
