import 'package:flutter/material.dart';

import 'package:pride_v3/app/app_theme.dart';

import 'package:pride_v3/core/calendar/app_calendar_format.dart';

import 'package:pride_v3/core/calendar/date_calendar_system.dart';

import 'package:pride_v3/core/formatting/display_order_no_format.dart';

import 'package:pride_v3/l10n/app_localizations.dart';



import '../../data/local/entities/order_status.dart';

import '../../data/local/order_summary.dart';

import 'order_detail_field_tile.dart';

import 'order_status_label.dart';



/// Visual summary at the top of order detail: customer, status pipeline, payment bar.

class OrderDetailHeroCard extends StatelessWidget {

  const OrderDetailHeroCard({

    super.key,

    required this.order,

    required this.paidAmountMinor,

    required this.remainingAmountMinor,

    required this.l10n,

    required this.locale,

    required this.calendar,

    required this.formatMoney,

    this.onNewOrder,

  });



  final OrderSummary order;

  final int paidAmountMinor;

  final int remainingAmountMinor;

  final AppLocalizations l10n;

  final String locale;

  final DateCalendarSystem calendar;

  final String Function(int minor) formatMoney;

  final VoidCallback? onNewOrder;



  @override

  Widget build(BuildContext context) {

    final theme = Theme.of(context);

    final scheme = theme.colorScheme;

    final actions = theme.extension<PrideActionColors>()!;

    final statusColor = _statusColor(order.status, scheme, actions);

    final isUnpaid = remainingAmountMinor > 0;

    final paidRatio = order.totalAmountMinor <= 0

        ? 0.0

        : (paidAmountMinor / order.totalAmountMinor).clamp(0.0, 1.0);



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



    return Padding(

      padding: const EdgeInsets.fromLTRB(16, 4, 16, 12),

      child: DecoratedBox(

        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          color: prideListCardSurface(scheme),
          border: Border.all(
            color: statusColor.withValues(alpha: 0.35),
            width: 1.25,
          ),
        ),

        child: Padding(

          padding: const EdgeInsets.all(16),

          child: Column(

            crossAxisAlignment: CrossAxisAlignment.stretch,

            children: [

              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: prideFriendlyTileFill(scheme, variant: 0),
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.55),
                      ),
                    ),
                    child: Icon(
                      Icons.receipt_long_outlined,
                      color: scheme.primary,
                      size: 26,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        DecoratedBox(
                          decoration: BoxDecoration(
                            color: scheme.primary,
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: Padding(
                            padding: const EdgeInsetsDirectional.fromSTEB(
                              8,
                              4,
                              8,
                              4,
                            ),
                            child: Text(
                              displayOrderNumberLabel(
                                l10n,
                                order.displayOrderNo,
                              ),
                              style: theme.textTheme.labelLarge?.copyWith(
                                color: scheme.onPrimary,
                                fontWeight: FontWeight.w800,
                              ),
                              maxLines: 2,
                              softWrap: true,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          order.customerName,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                          maxLines: 3,
                          softWrap: true,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Align(
                alignment: AlignmentDirectional.centerStart,
                child: Chip(
                  label: Text(
                    orderStatusLabel(order.status, l10n),
                    maxLines: 2,
                    softWrap: true,
                  ),
                  backgroundColor: statusColor.withValues(alpha: 0.18),
                  side: BorderSide(color: statusColor.withValues(alpha: 0.5)),
                  labelStyle: theme.textTheme.labelMedium?.copyWith(
                    color: statusColor,
                    fontWeight: FontWeight.w700,
                  ),
                  visualDensity: VisualDensity.compact,
                  materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                ),
              ),

              const SizedBox(height: 12),

              Wrap(

                spacing: 6,

                runSpacing: 6,

                children: [

                  OrderDetailMetaChip(

                    icon: Icons.schedule_outlined,

                    label: l10n.ordersTakenOn(takenFmt),

                  ),

                  OrderDetailMetaChip(

                    icon: Icons.local_shipping_outlined,

                    label: l10n.ordersDeliveryOn(deliveryFmt),

                  ),

                ],

              ),

              const SizedBox(height: 14),

              _StatusPipeline(

                current: order.status,

                l10n: l10n,

                activeColor: statusColor,

              ),

              const SizedBox(height: 14),

              Text(

                l10n.ordersDetailPaymentProgress,

                style: theme.textTheme.labelLarge?.copyWith(

                  color: scheme.onSurfaceVariant,

                ),

              ),

              const SizedBox(height: 6),

              ClipRRect(

                borderRadius: BorderRadius.circular(8),

                child: LinearProgressIndicator(

                  value: paidRatio,

                  minHeight: 8,

                  backgroundColor:
                      scheme.outlineVariant.withValues(alpha: 0.35),

                  color: isUnpaid ? actions.warning : actions.payment,

                ),

              ),

              const SizedBox(height: 8),

              Row(

                mainAxisAlignment: MainAxisAlignment.spaceBetween,

                children: [

                  Text(

                    '${l10n.paymentPaid}: ${formatMoney(paidAmountMinor)}',

                    style: theme.textTheme.bodySmall,

                  ),

                  Text(

                    '${l10n.paymentRemaining}: ${formatMoney(remainingAmountMinor)}',

                    style: theme.textTheme.bodySmall?.copyWith(

                      fontWeight: FontWeight.w700,

                      color: isUnpaid ? actions.warning : scheme.onSurface,

                    ),

                  ),

                ],

              ),

              if (onNewOrder != null) ...[

                const SizedBox(height: 12),

                Align(

                  alignment: AlignmentDirectional.centerStart,

                  child: Tooltip(

                    message: l10n.ordersNewOrderFromThisOrderTooltip,

                    child: FilledButton.tonalIcon(

                      onPressed: onNewOrder,

                      icon: const Icon(Icons.note_add_outlined),

                      label: Text(l10n.customersNewOrderCta),

                    ),

                  ),

                ),

              ],

            ],

          ),

        ),

      ),

    );

  }



  Color _statusColor(

    OrderLocalStatus status,

    ColorScheme scheme,

    PrideActionColors actions,

  ) {

    return switch (status) {

      OrderLocalStatus.newOrder => scheme.primary,

      OrderLocalStatus.inProgress => actions.edit,

      OrderLocalStatus.ready => actions.warning,

      OrderLocalStatus.delivered => actions.add,

      OrderLocalStatus.cancelled => actions.delete,

    };

  }

}



class _StatusPipeline extends StatelessWidget {

  const _StatusPipeline({

    required this.current,

    required this.l10n,

    required this.activeColor,

  });



  final OrderLocalStatus current;

  final AppLocalizations l10n;

  final Color activeColor;



  static const _pipeline = [

    OrderLocalStatus.newOrder,

    OrderLocalStatus.inProgress,

    OrderLocalStatus.ready,

    OrderLocalStatus.delivered,

  ];



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    if (current == OrderLocalStatus.cancelled) {

      return Row(

        children: [

          Icon(Icons.cancel_outlined, size: 18, color: activeColor),

          const SizedBox(width: 8),

          Expanded(

            child: Text(

              orderStatusLabel(current, l10n),

              style: Theme.of(context).textTheme.bodyMedium?.copyWith(

                    fontWeight: FontWeight.w600,

                    color: activeColor,

                  ),

            ),

          ),

        ],

      );

    }



    final currentIndex = _pipeline.indexOf(current).clamp(0, _pipeline.length - 1);



    return Row(

      children: [

        for (var i = 0; i < _pipeline.length; i++) ...[

          if (i > 0)

            Expanded(

              child: Container(

                height: 3,

                margin: const EdgeInsets.only(bottom: 14),

                color: i <= currentIndex

                    ? activeColor.withValues(alpha: 0.65)

                    : scheme.outlineVariant.withValues(alpha: 0.55),

              ),

            ),

          _StepDot(

            label: _shortLabel(_pipeline[i], l10n),

            active: i <= currentIndex,

            current: i == currentIndex,

            color: activeColor,

          ),

        ],

      ],

    );

  }



  String _shortLabel(OrderLocalStatus status, AppLocalizations l10n) {

    return switch (status) {

      OrderLocalStatus.newOrder => l10n.orderStatusNew,

      OrderLocalStatus.inProgress => l10n.orderStatusInProgress,

      OrderLocalStatus.ready => l10n.orderStatusReady,

      OrderLocalStatus.delivered => l10n.orderStatusDelivered,

      OrderLocalStatus.cancelled => l10n.orderStatusCancelled,

    };

  }

}



class _StepDot extends StatelessWidget {

  const _StepDot({

    required this.label,

    required this.active,

    required this.current,

    required this.color,

  });



  final String label;

  final bool active;

  final bool current;

  final Color color;



  @override

  Widget build(BuildContext context) {

    final scheme = Theme.of(context).colorScheme;

    final dotColor = active ? color : scheme.outlineVariant;



    return SizedBox(
      width: 68,
      child: Column(
        children: [
          AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            width: current ? 14 : 10,
            height: current ? 14 : 10,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: dotColor,
              border: current
                  ? Border.all(color: scheme.surfaceContainerLowest, width: 2)
                  : null,
              boxShadow: current
                  ? [
                      BoxShadow(
                        color: color.withValues(alpha: 0.45),
                        blurRadius: 8,
                      ),
                    ]
                  : null,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            label,
            maxLines: 3,
            textAlign: TextAlign.center,
            softWrap: true,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: current ? FontWeight.w700 : FontWeight.w500,
                  color: active ? scheme.onSurface : scheme.onSurfaceVariant,
                  height: 1.1,
                ),
          ),
        ],
      ),
    );

  }

}