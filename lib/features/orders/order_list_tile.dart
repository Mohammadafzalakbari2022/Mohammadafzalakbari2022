import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_summary.dart';
import 'order_garment_summary.dart';
import 'order_payment_rules.dart';
import 'order_status_label.dart';

/// Single order row for [OrdersFilteredListBody]: order badge, customer, meta chips.
class OrderListTile extends StatelessWidget {
  const OrderListTile({
    super.key,
    required this.order,
    required this.l10n,
    required this.locale,
    required this.calendar,
    required this.detailed,
    required this.onTap,
    required this.formatMoney,
    this.paidAmountMinor,
    this.remainingAmountMinor,
    this.stylePreviewLine,
  });

  final OrderSummary order;
  final int? paidAmountMinor;
  final int? remainingAmountMinor;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final bool detailed;
  final VoidCallback onTap;
  final String Function(int minor) formatMoney;
  final String? stylePreviewLine;

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
    final orderNoLabel =
        displayOrderNumberLabel(l10n, order.displayOrderNo);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      child: Material(
        color: prideListCardSurface(scheme),
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: scheme.outlineVariant),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(12, 10, 12, 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: _OrderNumberBadge(label: orderNoLabel),
                ),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 4,
                  children: [
                    _OrderListChip(
                      label: orderStatusLabel(order.status, l10n),
                      background: scheme.primaryContainer,
                      foreground: scheme.onPrimaryContainer,
                    ),
                    if (order.items.length > 1 ||
                        order.garmentSummaryKey.contains('+'))
                      _OrderListChip(
                        label: orderGarmentSummaryLabel(l10n, order),
                        background: scheme.secondaryContainer,
                        foreground: scheme.onSecondaryContainer,
                      ),
                    if (isUnpaid)
                      _OrderListChip(
                        label: l10n.ordersRemainingChip(
                          AppNumberFormat.formatInt(remainingMinor),
                        ),
                        background: scheme.errorContainer,
                        foreground: scheme.onErrorContainer,
                      ),
                  ],
                ),
                const SizedBox(height: 8),
                _CustomerNameBadge(name: order.customerName),
                if (order.customerPhone != null &&
                    order.customerPhone!.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
                  Text(
                    order.customerPhone!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                const SizedBox(height: 8),
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  children: [
                    _OrderMetaChip(
                      icon: Icons.schedule_outlined,
                      text: l10n.ordersTakenOn(takenFmt),
                    ),
                    _OrderMetaChip(
                      icon: Icons.local_shipping_outlined,
                      text: l10n.ordersDeliveryOn(deliveryFmt),
                    ),
                  ],
                ),
                if (order.catalogDesignNameSnapshot.trim().isNotEmpty) ...[
                  const SizedBox(height: 6),
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
                if (detailed &&
                    stylePreviewLine != null &&
                    stylePreviewLine!.trim().isNotEmpty) ...[
                  const SizedBox(height: 4),
                  Text(
                    stylePreviewLine!.trim(),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: scheme.onSurfaceVariant,
                    ),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
                if (detailed) ...[
                  const SizedBox(height: 8),
                  DecoratedBox(
                    decoration: BoxDecoration(
                      color: prideFriendlyTileFill(scheme, variant: 1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsetsDirectional.fromSTEB(
                        10,
                        6,
                        10,
                        6,
                      ),
                      child: Text(
                        [
                          '${l10n.paymentTotal}: ${formatMoney(order.totalAmountMinor)}',
                          '${l10n.paymentPaid}: ${formatMoney(paidMinor)}',
                        ].join(' · '),
                        style: theme.textTheme.bodySmall,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderNumberBadge extends StatelessWidget {
  const _OrderNumberBadge({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: scheme.primary,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.primary.withValues(alpha: 0.85),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(10, 5, 10, 5),
        child: Text(
          label,
          style: theme.textTheme.labelLarge?.copyWith(
            color: scheme.onPrimary,
            fontWeight: FontWeight.w800,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}

class _OrderListChip extends StatelessWidget {
  const _OrderListChip({
    required this.label,
    required this.background,
    required this.foreground,
  });

  final String label;
  final Color background;
  final Color foreground;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DecoratedBox(
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: foreground.withValues(alpha: 0.25)),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 4, 8, 4),
        child: Text(
          label,
          style: theme.textTheme.labelMedium?.copyWith(
            color: foreground,
            fontWeight: FontWeight.w700,
          ),
          maxLines: 2,
          softWrap: true,
        ),
      ),
    );
  }
}

class _OrderMetaChip extends StatelessWidget {
  const _OrderMetaChip({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return DecoratedBox(
      decoration: BoxDecoration(
        color: prideFriendlyTileFill(scheme, variant: 0),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(8, 5, 10, 5),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, size: 14, color: scheme.onSurfaceVariant),
            const SizedBox(width: 5),
            Flexible(
              child: Text(
                text,
                style: theme.textTheme.labelMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: scheme.onSurface,
                ),
                maxLines: 3,
                softWrap: true,
              ),
            ),
          ],
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
        color: prideFriendlyTileFill(scheme, variant: 2),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
        ),
      ),
      child: Padding(
        padding: const EdgeInsetsDirectional.fromSTEB(12, 7, 12, 7),
        child: Text(
          name,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w700,
            color: scheme.onSurface,
            height: 1.15,
          ),
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }
}
