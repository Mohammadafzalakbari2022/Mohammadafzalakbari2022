import 'package:flutter/material.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/widgets/customer_id_badge.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';
import '../catalog/catalog_tile_image.dart';

/// Visual summary at the top of customer profile (matches [OrderDetailHeroCard]).
class CustomerProfileHeroCard extends StatelessWidget {
  const CustomerProfileHeroCard({
    super.key,
    required this.customer,
    required this.l10n,
    required this.locale,
    required this.calendar,
    required this.orderCount,
    required this.unpaidMinor,
    required this.formatMoney,
  });

  final CustomerSummary customer;
  final AppLocalizations l10n;
  final String locale;
  final DateCalendarSystem calendar;
  final int orderCount;
  final int unpaidMinor;
  final String Function(int minor) formatMoney;

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
    final phone = customer.phone?.trim();
    final address = customer.address?.trim();
    final showCustomerId =
        parseStoredDisplayCustomerNo(customer.displayCustomerNo) > 0;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 8),
      child: DecoratedBox(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(20),
          gradient: LinearGradient(
            begin: AlignmentDirectional.topStart,
            end: AlignmentDirectional.bottomEnd,
            colors: [
              scheme.secondary.withValues(alpha: 0.12),
              scheme.primaryContainer.withValues(alpha: 0.35),
            ],
          ),
          border: Border.all(
            color: scheme.primary.withValues(alpha: 0.35),
            width: 1.25,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (showCustomerId) ...[
                CustomerIdBadge(storedCustomerNo: customer.displayCustomerNo),
                const SizedBox(height: 12),
              ],
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: scheme.surfaceContainerLowest,
                      borderRadius: BorderRadius.circular(14),
                      border: Border.all(
                        color: scheme.outlineVariant.withValues(alpha: 0.7),
                      ),
                    ),
                    child: Icon(
                      Icons.person_outline,
                      color: scheme.primary,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          customer.name,
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontWeight: FontWeight.w800,
                            height: 1.15,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          phone != null && phone.isNotEmpty
                              ? phone
                              : l10n.customersPhoneMissing,
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: scheme.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (address != null && address.isNotEmpty) ...[
                const SizedBox(height: 10),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Icon(
                      Icons.home_outlined,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        address,
                        style: theme.textTheme.bodyMedium,
                      ),
                    ),
                  ],
                ),
              ],
              if (customer.hasLastCatalogDesign) ...[
                const SizedBox(height: 12),
                Text(
                  l10n.customerLastCatalogDesignLabel,
                  style: theme.textTheme.labelLarge?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: scheme.onSurfaceVariant,
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CatalogTileImage(
                      thumbnailPath: customer.lastCatalogThumbnailPath,
                      imagePath: customer.lastCatalogThumbnailPath,
                      dimension: 56,
                      borderRadius: 10,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            customer.lastCatalogDesignName,
                            style: theme.textTheme.titleSmall?.copyWith(
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          if (customer.lastCatalogDesignerShopName
                              .trim()
                              .isNotEmpty)
                            Text(
                              customer.lastCatalogDesignerShopName,
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: scheme.onSurfaceVariant,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  Chip(
                    avatar: Icon(
                      Icons.receipt_long_outlined,
                      size: 18,
                      color: scheme.primary,
                    ),
                    label: Text(
                      orderCount == 0
                          ? l10n.customersRowNoOrdersYet
                          : l10n.customersRowMeta(
                              orderCount,
                              unpaidMinor > 0
                                  ? l10n.ordersRemainingChip(
                                      formatMoney(unpaidMinor),
                                    )
                                  : formatMoney(0),
                            ),
                    ),
                    visualDensity: VisualDensity.compact,
                  ),
                  Chip(
                    avatar: Icon(
                      Icons.calendar_today_outlined,
                      size: 18,
                      color: scheme.onSurfaceVariant,
                    ),
                    label: Text(l10n.customersRowSince(sinceFmt)),
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
