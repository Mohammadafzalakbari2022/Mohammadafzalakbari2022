import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_summary.dart';

/// One-line summary for collapsed order-detail fabric section.
String orderCustomerFabricSummaryLine(AppLocalizations l10n, OrderSummary order) {
  final name = order.fabricNameSnapshot.trim();
  final color = order.fabricColorSnapshot.trim();
  final id = order.fabricIdSnapshot.trim();
  if (name.isNotEmpty && color.isNotEmpty && id.isNotEmpty) {
    return l10n.ordersComposerFabricSummary(name, color, id);
  }
  if (name.isNotEmpty && color.isNotEmpty) {
    return l10n.ordersComposerFabricPartialSummary(name, color);
  }
  final parts = <String>[
    if (name.isNotEmpty) name,
    if (color.isNotEmpty) color,
    if (id.isNotEmpty) id,
  ];
  return parts.join(' • ');
}

/// Order detail fabric section — matches customer / audit ListTile layout.
class OrderCustomerFabricPanel extends StatelessWidget {
  const OrderCustomerFabricPanel({super.key, required this.order});

  final OrderSummary order;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final name = order.fabricNameSnapshot.trim();
    final color = order.fabricColorSnapshot.trim();
    final id = order.fabricIdSnapshot.trim();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        if (name.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.texture_outlined),
            title: Text(l10n.receiptFabricNameLabel),
            subtitle: Text(name),
          ),
        if (color.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.palette_outlined),
            title: Text(l10n.receiptFabricColorLabel),
            subtitle: Text(color),
          ),
        if (id.isNotEmpty) ...[
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.tag_outlined),
            title: Text(l10n.receiptFabricIdLabel),
            subtitle: Text(
              id,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                letterSpacing: 2,
              ),
            ),
          ),
        ],
      ],
    );
  }
}
