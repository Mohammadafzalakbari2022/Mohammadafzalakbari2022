import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import 'order_composer_draft.dart';

/// Localized garment summary for list/detail chips (maps [OrderSummary.garmentSummaryKey]).
String orderGarmentSummaryLabel(AppLocalizations l10n, OrderSummary order) {
  switch (order.garmentSummaryKey) {
    case kGarmentTypeWaistcoatApiKey:
      return l10n.garmentWaistcoat;
    case '$kGarmentTypePerahanTunbanApiKey+$kGarmentTypeWaistcoatApiKey':
      return l10n.ordersGarmentSummaryBoth;
    default:
      return l10n.garmentPerahanTunban;
  }
}

List<OrderPaymentBreakdownLine> paymentBreakdownFromOrder(OrderSummary order) {
  if (order.items.isEmpty) return const [];
  return [
    for (final item in order.sortedItems)
      OrderPaymentBreakdownLine(
        garmentType: item.garmentType,
        amountMinor: item.priceAmountMinor,
      ),
  ];
}

String orderItemFabricSummaryLine(AppLocalizations l10n, OrderItemSummary item) {
  final name = item.fabricNameSnapshot.trim();
  final color = item.fabricColorSnapshot.trim();
  final id = item.fabricIdSnapshot.trim();
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
