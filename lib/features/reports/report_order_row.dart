import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/core/widgets/customer_id_badge.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_display_no.dart';
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
    this.customerDisplayNo = '',
  });

  final OrderSummary order;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final int? trailingMoneyMinor;
  final String customerDisplayNo;

  @override
  Widget build(BuildContext context) {
    final amount = trailingMoneyMinor ?? order.remainingAmountMinor;
    final showCustomerId = parseStoredDisplayCustomerNo(customerDisplayNo) > 0;

    return Card(
      child: ListTile(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (showCustomerId) ...[
              CustomerIdBadge(
                storedCustomerNo: customerDisplayNo,
                compact: true,
              ),
              const SizedBox(height: 6),
            ],
            Text(
              order.customerName,
              style: Theme.of(context).textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w700,
                  ),
            ),
          ],
        ),
        subtitle: Text(
          [
            displayOrderNumberLabel(l10n, order.displayOrderNo),
            l10n.ordersDeliveryOn(
              AppCalendarFormat.mediumDate(
                l10n,
                calendar,
                order.deliveryDate,
                locale,
              ),
            ),
          ].join(' · '),
        ),
        trailing: Chip(
          label: Text(reportFormatMoney(l10n, amount)),
        ),
        onTap: () => context.push('/app/orders/${order.internalId}'),
      ),
    );
  }
}
