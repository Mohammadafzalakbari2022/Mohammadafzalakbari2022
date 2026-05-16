import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/providers/local_data_providers.dart';
import 'report_money_format.dart';
import 'report_order_row.dart';
import 'reports_open_orders.dart';

class OpenUnpaidReportScreen extends ConsumerWidget {
  const OpenUnpaidReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsThisMonthOpenUnpaidTitle),
      ),
      body: asyncOrders.when(
        data: (orders) {
          final openUnpaid = openUnpaidOrders(orders);
          final total = openUnpaidOrdersTotal(orders);

          if (openUnpaid.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.reportsOpenUnpaidEmpty,
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
                        child: Text(l10n.reportsUnpaidTotalLabel),
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
              ...openUnpaid.map(
                (o) => ReportOrderRow(
                  order: o,
                  l10n: l10n,
                  locale: locale,
                  calendar: calendar,
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
