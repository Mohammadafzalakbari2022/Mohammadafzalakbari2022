import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_summary.dart';
import 'order_payment_rules.dart';
import 'order_status_label.dart';

/// Single order row for [OrdersFilteredListBody]: styled customer name, optional
/// order number when selected, taken/delivery metadata, status chips.
class OrderListTile extends StatelessWidget {
  const OrderListTile({
    super.key,
    required this.order,
    required this.l10n,
    required this.locale,
    required this.calendar,
    required this.isSelected,
    required this.detailed,
    required this.onTap,
    required this.formatMoney,
    this.paidAmountMinor,
    this.remainingAmountMinor,
  });

  final OrderSummary order;
  final int? paidAmountMinor;
  final int? remainingAmountMinor;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final bool isSelected;
  final bool detailed;
  final VoidCallback onTap;
  final String Function(int minor) formatMoney;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final takenFmt = AppCalendarFormat.dateTimeMedium(
      l10n,
      calendar,
      order.createdAt,
      locale,
    );
    final deliveryFmt = AppCalendarFormat.mediumDate(
      l10n,
      calendar,
      order.deliveryDate,
      locale,
    );
    final paidMinor = paidAmountMinor ?? order.paidAmountMinor;
    final remainingMinor = remainingAmountMinor ??
        OrderPaymentRules.remainingMinor(order.totalAmountMinor, paidMinor);
    final isUnpaid = remainingMinor > 0;

    final borderRadius = BorderRadius.circular(14);
    final selectedFill = scheme.primaryContainer.withValues(alpha: 0.42);
    final selectedBorder = scheme.primary.withValues(alpha: 0.55);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        decoration: BoxDecoration(
          borderRadius: borderRadius,
          color: isSelected ? selectedFill : scheme.surfaceContainerLow,
          border: Border.all(
            color: isSelected ? selectedBorder : scheme.outlineVariant,
            width: isSelected ? 1.75 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: scheme.primary.withValues(alpha: 0.18),
                    blurRadius: 10,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Material(
          color: Colors.transparent,
          borderRadius: borderRadius,
          child: InkWell(
            borderRadius: borderRadius,
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(14, 12, 12, 12),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSelected) ...[
                          Text(
                            l10n.ordersNumberPrefix(order.displayOrderNo),
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        _CustomerNameBadge(name: order.customerName),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.schedule_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.ordersTakenOn(takenFmt),
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (order.catalogDesignNameSnapshot.trim().isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Text(
                            order.catalogDesignNameSnapshot.trim(),
                            style: theme.textTheme.bodySmall?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.local_shipping_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.ordersDeliveryOn(deliveryFmt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        if (detailed) ...[
                          const SizedBox(height: 8),
                          Text(
                            [
                              '${l10n.customerPhoneLabel}: ${order.customerPhone ?? l10n.customersPhoneMissing}',
                              '${l10n.paymentTotal}: ${formatMoney(order.totalAmountMinor)}',
                              '${l10n.paymentPaid}: ${formatMoney(paidMinor)}',
                              '${l10n.paymentRemaining}: ${formatMoney(remainingMinor)}',
                            ].join(' · '),
                            style: theme.textTheme.bodySmall,
                          ),
                        ],
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      if (isSelected)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 6),
                          child: Icon(
                            Icons.check_circle_rounded,
                            size: 20,
                            color: scheme.primary,
                          ),
                        ),
                      Chip(
                        label: Text(
                          isUnpaid && !detailed
                              ? '${orderStatusLabel(order.status, l10n)} · ${l10n.ordersRemainingChip(NumberFormat.decimalPattern().format(remainingMinor))}'
                              : orderStatusLabel(order.status, l10n),
                        ),
                        visualDensity: VisualDensity.compact,
                        materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class _CustomerNameBadge extends StatelessWidget {
  const _CustomerNameBadge({required this.name});

  final String name;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerHigh,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        child: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            height: 1.15,
          ),
        ),
      ),
    );
  }
}
