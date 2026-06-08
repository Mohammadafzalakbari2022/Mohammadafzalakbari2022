import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/order_item_summary.dart';

/// Order detail fabric section for one garment line.
class OrderItemFabricPanel extends StatelessWidget {
  const OrderItemFabricPanel({super.key, required this.item});

  final OrderItemSummary item;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final name = item.fabricNameSnapshot.trim();
    final color = item.fabricColorSnapshot.trim();
    final id = item.fabricIdSnapshot.trim();

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
        if (id.isNotEmpty)
          ListTile(
            contentPadding: EdgeInsets.zero,
            leading: const Icon(Icons.tag_outlined),
            title: Text(l10n.receiptFabricIdLabel),
            subtitle: Text(
              id,
              style: theme.textTheme.bodyMedium?.copyWith(
                fontFeatures: const [FontFeature.tabularFigures()],
              ),
            ),
          ),
      ],
    );
  }
}
