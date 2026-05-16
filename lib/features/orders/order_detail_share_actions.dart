import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/printing/thermal_print_order.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/features/orders/order_invoice_share.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Prominent share PDF + print actions on order detail (in addition to app bar).
class OrderDetailShareActions extends ConsumerWidget {
  const OrderDetailShareActions({
    super.key,
    required this.order,
    required this.payments,
    required this.l10n,
    required this.locale,
    required this.calendar,
    required this.statusText,
  });

  final OrderSummary order;
  final List<PaymentSummary> payments;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final String statusText;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final deliveryDateText = AppCalendarFormat.mediumDate(
      l10n,
      calendar,
      order.deliveryDate,
      locale,
    );

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Row(
        children: [
          Expanded(
            child: FilledButton.tonalIcon(
              onPressed: () => shareOrderInvoice(
                context: context,
                ref: ref,
                l10n: l10n,
                order: order,
                payments: payments,
                deliveryDateText: deliveryDateText,
                statusText: statusText,
              ),
              icon: const Icon(Icons.picture_as_pdf_outlined),
              label: Text(l10n.orderShareInvoicePdfCta),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: OutlinedButton.icon(
              onPressed: () => printThermalOrderReceipt(
                context: context,
                ref: ref,
                l10n: l10n,
                order: order,
                payments: payments,
                deliveryDateText: deliveryDateText,
                statusText: statusText,
              ),
              icon: const Icon(Icons.print_outlined),
              label: Text(l10n.orderPrintReceiptTooltip),
            ),
          ),
        ],
      ),
    );
  }
}
