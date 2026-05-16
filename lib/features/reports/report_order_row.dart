import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_summary.dart';
import 'report_money_format.dart';

/// Order row for report detail screens (tap opens order detail).
class ReportOrderRow extends StatelessWidget {
  const ReportOrderRow({
    super.key,
    required this.order,
    required this.l10n,
    required this.locale,
    required this.calendar,
    this.trailingMoneyMinor,
  });

  final OrderSummary order;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final int? trailingMoneyMinor;

  @override
  Widget build(BuildContext context) {
    final amount = trailingMoneyMinor ?? order.remainingAmountMinor;
    return Card(
      child: ListTile(
        title: Text(
          '${l10n.ordersNumberPrefix(order.displayOrderNo)} · ${order.customerName}',
        ),
        subtitle: Text(
          l10n.ordersDeliveryOn(
            AppCalendarFormat.mediumDate(
              l10n,
              calendar,
              order.deliveryDate,
              locale,
            ),
          ),
        ),
        trailing: Chip(
          label: Text(reportFormatMoney(l10n, amount)),
        ),
        onTap: () => context.push('/app/orders/${order.internalId}'),
      ),
    );
  }
}
