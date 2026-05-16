import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';

class ThisMonthIncomeReportScreen extends ConsumerWidget {
  const ThisMonthIncomeReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncPayments = ref.watch(paymentsForShopProvider(shopId));

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsThisMonthIncomeTitle),
      ),
      body: asyncPayments.when(
        data: (payments) {
          final now = DateTime.now();
          final start = startOfMonthContaining(now, calendar);
          final end = endExclusiveForMonthStart(start, calendar);
          final monthPayments = payments
              .where(
                (p) =>
                    !p.createdAt.isBefore(start) && p.createdAt.isBefore(end),
              )
              .toList()
            ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
          final total =
              monthPayments.fold<int>(0, (s, p) => s + p.amountMinor);

          if (monthPayments.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.reportsThisMonthIncomeEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(l10n.reportsMonthlyIncomeCardLabel),
                      ),
                      Text(
                        reportFormatMoney(l10n, total),
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 16),
              ...monthPayments.map(
                (p) => Card(
                  child: ListTile(
                    title: Text(
                      reportFormatMoneyDelta(l10n, p.amountMinor),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    subtitle: Text(
                      [
                        AppCalendarFormat.dateTimeMedium(
                          l10n,
                          calendar,
                          p.createdAt,
                          locale,
                        ),
                        if (p.method.isNotEmpty) p.method,
                        if (p.isAdjustment)
                          l10n.reportsPaymentsAdjustmentChip,
                      ].join(' · '),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text('$e', textAlign: TextAlign.center),
          ),
        ),
      ),
    );
  }
}
