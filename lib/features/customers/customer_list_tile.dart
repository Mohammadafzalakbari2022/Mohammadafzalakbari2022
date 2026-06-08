import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';

/// Single customer row for [CustomersListBody], styled like [OrderListTile].
class CustomerListTile extends StatelessWidget {
  const CustomerListTile({
    super.key,
    required this.customer,
    required this.l10n,
    required this.locale,
    required this.calendar,
    required this.isSelected,
    required this.orderCount,
    required this.unpaidMinor,
    required this.onTap,
    required this.formatMoney,
    this.onNewOrder,
  });

  final CustomerSummary customer;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final bool isSelected;
  final int orderCount;
  final int unpaidMinor;
  final VoidCallback onTap;
  final String Function(int minor) formatMoney;
  final VoidCallback? onNewOrder;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final sinceFmt = AppCalendarFormat.mediumDate(
      l10n,
      calendar,
      customer.createdAt,
      locale,
    );
    final phone = customer.phone ?? l10n.customersPhoneMissing;
    final customerIdLabel = parseStoredDisplayCustomerNo(customer.displayCustomerNo) >
            0
        ? displayCustomerNumberLabel(l10n, customer.displayCustomerNo)
        : null;
    final meta = orderCount == 0
        ? l10n.customersRowNoOrdersYet
        : l10n.customersRowMeta(
            orderCount,
            unpaidMinor > 0
                ? l10n.ordersRemainingChip(formatMoney(unpaidMinor))
                : formatMoney(0),
          );

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
          color: isSelected ? selectedFill : prideListCardSurface(scheme),
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
          child: Padding(
            padding: const EdgeInsetsDirectional.fromSTEB(14, 12, 4, 12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: InkWell(
                    borderRadius: borderRadius,
                    onTap: onTap,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (isSelected) ...[
                          Text(
                            phone,
                            style: theme.textTheme.labelLarge?.copyWith(
                              color: scheme.primary,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.4,
                            ),
                          ),
                          const SizedBox(height: 8),
                        ],
                        _CustomerNameBadge(name: customer.name),
                        if (customerIdLabel != null) ...[
                          const SizedBox(height: 6),
                          Text(
                            customerIdLabel,
                            style: theme.textTheme.labelMedium?.copyWith(
                              color: scheme.onSurfaceVariant,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            Icon(
                              Icons.phone_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                phone,
                                style: theme.textTheme.bodyMedium?.copyWith(
                                  fontWeight: FontWeight.w600,
                                  color: scheme.onSurface,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.receipt_long_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                meta,
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            Icon(
                              Icons.calendar_today_outlined,
                              size: 16,
                              color: scheme.onSurfaceVariant,
                            ),
                            const SizedBox(width: 6),
                            Expanded(
                              child: Text(
                                l10n.customersRowSince(sinceFmt),
                                style: theme.textTheme.bodySmall?.copyWith(
                                  color: scheme.onSurfaceVariant,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                if (isSelected)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(top: 2, end: 4),
                    child: Icon(
                      Icons.check_circle_rounded,
                      size: 20,
                      color: scheme.primary,
                    ),
                  ),
                if (onNewOrder != null)
                  Padding(
                    padding: const EdgeInsetsDirectional.only(
                      top: 2,
                      end: 4,
                      start: 4,
                    ),
                    child: Tooltip(
                      message: l10n.customersNewOrderForCustomerTooltip,
                      child: FilledButton.tonalIcon(
                        onPressed: onNewOrder,
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          padding: const EdgeInsetsDirectional.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        icon: const Icon(Icons.note_add_outlined, size: 18),
                        label: Text(
                          l10n.customersNewOrderCta,
                          maxLines: 2,
                          softWrap: true,
                          overflow: TextOverflow.ellipsis,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  ),
              ],
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
        color: prideFriendlyTileFill(scheme, variant: 0),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.55),
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
          maxLines: 3,
          softWrap: true,
        ),
      ),
    );
  }
}
