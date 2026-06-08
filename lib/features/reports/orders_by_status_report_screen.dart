import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/order_status.dart';
import '../../data/providers/local_data_providers.dart';
import '../orders/order_status_label.dart';
import 'report_order_row.dart';

class OrdersByStatusReportScreen extends ConsumerWidget {
  const OrdersByStatusReportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);
    final customerDisplayNoById = ref
            .watch(customersListStreamProvider)
            .maybeWhen(
              data: (customers) => <String, String>{
                for (final c in customers) c.internalId: c.displayCustomerNo,
              },
              orElse: () => const <String, String>{},
            );

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.reportsOrdersSummaryTitle),
      ),
      body: asyncOrders.when(
        data: (orders) {
          if (orders.isEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.reportsOrdersSummaryEmpty,
                  textAlign: TextAlign.center,
                ),
              ),
            );
          }

          final sections = <Widget>[];
          for (final status in OrderLocalStatus.values) {
            final group =
                orders.where((o) => o.status == status).toList()
                  ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
            if (group.isEmpty) continue;
            sections.add(
              Card(
                clipBehavior: Clip.antiAlias,
                margin: const EdgeInsets.only(bottom: 12),
                child: ExpansionTile(
                  initiallyExpanded: group.length <= 8,
                  title: Text(orderStatusLabel(status, l10n)),
                  subtitle: Text(l10n.reportsOrdersByStatusCount(group.length)),
                  children: group
                      .map(
                        (o) => ReportOrderRow(
                          order: o,
                          l10n: l10n,
                          locale: locale,
                          calendar: calendar,
                          trailingMoneyMinor: o.totalAmountMinor,
                          customerDisplayNo:
                              customerDisplayNoById[o.customerInternalId] ?? '',
                        ),
                      )
                      .toList(),
                ),
              ),
            );
          }

          return ListView(
            padding: const EdgeInsets.all(16),
            children: sections,
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
