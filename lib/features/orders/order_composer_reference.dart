import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/data/local/measurement_profile_formatting.dart';
import 'package:pride_v3/data/local/measurement_profile_line.dart';
import 'package:pride_v3/data/local/order_measurement_snapshot_item_input.dart';
import 'package:pride_v3/data/local/order_measurement_snapshot_view.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/data/local/catalog_item_summary.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/order_item_snapshot_key.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/data/local/style/order_shape_selection_formatter.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/data/providers/local_data_providers.dart';
import 'package:pride_v3/features/catalog/catalog_tile_image.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/features/orders/order_payment_rules.dart';
import 'package:pride_v3/features/orders/order_status_label.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../core/calendar/date_calendar_notifier.dart';

// --- Reference order selection (pure logic, testable) ---

/// Customer orders for reference UI, newest [createdAt] first.
/// [allOrders] is expected to exclude soft-deleted rows (repo filter).
List<OrderSummary> customerOrdersForReference(
  List<OrderSummary> allOrders,
  String customerId,
) {
  final id = customerId.trim();
  if (id.isEmpty) return const [];
  final list = allOrders.where((o) => o.customerInternalId == id).toList();
  list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return list;
}

/// Resolves the reference order: explicit [selectedReferenceOrderId] or latest.
OrderSummary? resolveReferenceOrder(
  List<OrderSummary> customerOrders,
  String? selectedReferenceOrderId,
) {
  if (customerOrders.isEmpty) return null;
  final pick = selectedReferenceOrderId?.trim();
  if (pick != null && pick.isNotEmpty) {
    for (final o in customerOrders) {
      if (o.internalId == pick) return o;
    }
  }
  return customerOrders.first;
}

bool composerReferenceValuesDiffer(String? current, String? previous) {
  final p = previous?.trim() ?? '';
  if (p.isEmpty) return false;
  return (current?.trim() ?? '') != p;
}

/// Diff icon only when [current] is a meaningful user-entered value, not a placeholder.
bool composerReferenceShouldShowDiff({
  required String? current,
  required String? previous,
  required bool currentIsMeaningful,
}) {
  if (!currentIsMeaningful) return false;
  return composerReferenceValuesDiffer(current, previous);
}

/// Ledger-aware paid/remaining for a reference [order] (read-only display).
ReferenceOrderPaymentTotals referenceOrderPaymentTotals({
  required OrderSummary order,
  required Map<String, int> paidByOrderId,
  required bool paymentsLedgerLoaded,
}) {
  final paid = OrderPaymentRules.paidMinorForOrder(
    orderSummaryPaidMinor: order.paidAmountMinor,
    paidByOrderId: paidByOrderId,
    orderInternalId: order.internalId,
    paymentsLedgerLoaded: paymentsLedgerLoaded,
  );
  return ReferenceOrderPaymentTotals(
    totalMinor: order.totalAmountMinor,
    paidMinor: paid,
    remainingMinor: OrderPaymentRules.remainingMinor(order.totalAmountMinor, paid),
  );
}

Map<String, int> referencePaidByOrderIdFromPayments(
  List<({String orderInternalId, int amountMinor})> payments,
) {
  return OrderPaymentRules.sumPaidMinorByOrderId(payments);
}

String formatReferenceOrderPaymentSummary(
  AppLocalizations l10n,
  OrderSummary order,
  Map<String, int> paidByOrderId,
  bool paymentsLedgerLoaded,
  String Function(AppLocalizations l10n, int minor) money,
) {
  final totals = referenceOrderPaymentTotals(
    order: order,
    paidByOrderId: paidByOrderId,
    paymentsLedgerLoaded: paymentsLedgerLoaded,
  );
  return l10n.ordersComposerPaymentSummary(
    money(l10n, totals.totalMinor),
    money(l10n, totals.paidMinor),
    money(l10n, totals.remainingMinor),
  );
}

class ReferenceOrderPaymentTotals {
  const ReferenceOrderPaymentTotals({
    required this.totalMinor,
    required this.paidMinor,
    required this.remainingMinor,
  });

  final int totalMinor;
  final int paidMinor;
  final int remainingMinor;
}

// --- Copy payloads (draft-only; never persist reference id) ---

class ReferenceMeasurementsCopy {
  const ReferenceMeasurementsCopy({
    required this.snapshotText,
    required this.items,
  });

  final String snapshotText;
  final List<OrderMeasurementSnapshotItemInput> items;
}

ReferenceMeasurementsCopy? buildMeasurementsCopy(
  OrderSummary order,
  OrderMeasurementSnapshotView? snap,
) {
  final items = (snap?.items ?? const [])
      .map(
        (it) => OrderMeasurementSnapshotItemInput(
          measurementTypeInternalId: it.measurementTypeInternalId,
          typeName: it.typeName,
          value: it.value,
          unitCode: it.unitCode,
          sortOrder: it.sortOrder,
        ),
      )
      .toList(growable: false);

  var text = order.measurementsSnapshot.trim();
  if (text.isEmpty && items.isNotEmpty) {
    text = MeasurementProfileFormatting.buildDisplayText(
      lines: items
          .map(
            (it) => MeasurementProfileLine(
              measurementTypeInternalId: it.measurementTypeInternalId,
              typeName: it.typeName,
              value: it.value,
              unitCode: it.unitCode,
            ),
          )
          .toList(),
      notes: '',
    );
  }
  if (text.isEmpty && items.isEmpty) return null;
  return ReferenceMeasurementsCopy(snapshotText: text, items: items);
}

String previousMeasurementsDisplayText(
  OrderSummary order,
  OrderMeasurementSnapshotView? snap,
) {
  return buildMeasurementsCopy(order, snap)?.snapshotText ??
      order.measurementsSnapshot.trim();
}

class ReferenceStyleCopy {
  const ReferenceStyleCopy({
    required this.styleName,
    this.styleNameInternalId,
    required this.selection,
    required this.styleSummary,
  });

  final String styleName;
  final String? styleNameInternalId;
  final StyleOrderSelection selection;
  final String styleSummary;
}

ReferenceStyleCopy? buildStyleCopy(OrderSummary order) {
  final name = order.styleName.trim();
  final summary = order.styleSummary.trim();
  final selection =
      StyleOrderSelection.fromJsonString(order.styleSelectionJson);
  if (name.isEmpty && summary.isEmpty && selection.isEmpty) return null;
  return ReferenceStyleCopy(
    styleName: order.styleName,
    styleNameInternalId: order.styleNameInternalId,
    selection: selection,
    styleSummary: order.styleSummary,
  );
}

String previousStyleDisplayText(OrderSummary order) {
  final copy = buildStyleCopy(order);
  if (copy == null) return '';
  if (copy.styleSummary.trim().isNotEmpty) return copy.styleSummary.trim();
  return copy.styleName.trim();
}

class ReferenceDesignCopy {
  const ReferenceDesignCopy({
    this.catalogItemInternalId,
    required this.catalogDesignName,
    required this.catalogDesignerShopName,
    this.catalogImagePath,
    this.catalogThumbnailPath,
  });

  final String? catalogItemInternalId;
  final String catalogDesignName;
  final String catalogDesignerShopName;
  final String? catalogImagePath;
  final String? catalogThumbnailPath;
}

bool catalogItemExistsInLists(
  String? catalogItemInternalId,
  List<CatalogItemSummary> myCatalog,
  List<CatalogItemSummary> sharedCatalog,
) {
  final id = catalogItemInternalId?.trim();
  if (id == null || id.isEmpty) return false;
  for (final item in myCatalog) {
    if (item.internalId == id) return true;
  }
  for (final item in sharedCatalog) {
    if (item.internalId == id) return true;
  }
  return false;
}

ReferenceDesignCopy? buildDesignCopy(
  OrderSummary order, {
  required bool catalogItemExists,
}) {
  final hasData = order.catalogDesignNameSnapshot.trim().isNotEmpty ||
      order.catalogItemInternalId != null ||
      (order.catalogImagePathSnapshot?.trim().isNotEmpty ?? false) ||
      (order.catalogThumbnailPathSnapshot?.trim().isNotEmpty ?? false);
  if (!hasData) return null;
  return ReferenceDesignCopy(
    catalogItemInternalId:
        catalogItemExists ? order.catalogItemInternalId : null,
    catalogDesignName: order.catalogDesignNameSnapshot,
    catalogDesignerShopName: order.catalogDesignerShopNameSnapshot,
    catalogImagePath: order.catalogImagePathSnapshot,
    catalogThumbnailPath: order.catalogThumbnailPathSnapshot,
  );
}

/// Snapshot-only design copy when live catalog item is missing or unresolved.
ReferenceDesignCopy? buildDesignCopySnapshotOnly(OrderSummary order) {
  return buildDesignCopy(order, catalogItemExists: false);
}

String previousDesignDisplayText(OrderSummary order) {
  final parts = <String>[];
  if (order.catalogDesignNameSnapshot.trim().isNotEmpty) {
    parts.add(order.catalogDesignNameSnapshot.trim());
  }
  if (order.catalogDesignerShopNameSnapshot.trim().isNotEmpty) {
    parts.add(order.catalogDesignerShopNameSnapshot.trim());
  }
  return parts.join(' · ');
}

class ReferenceFabricCopy {
  const ReferenceFabricCopy({
    required this.fabricName,
    required this.fabricColor,
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
    this.clothMeters = '',
    this.clothPriceAmountMinor = 0,
  });

  final String fabricName;
  final String fabricColor;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;
  final String clothMeters;
  final int clothPriceAmountMinor;
}

ReferenceFabricCopy? buildFabricCopy(OrderSummary order) {
  if (!order.hasCustomerFabric) return null;
  return ReferenceFabricCopy(
    fabricName: order.fabricNameSnapshot,
    fabricColor: order.fabricColorSnapshot,
    fabricNamePresetInternalId: order.fabricNamePresetInternalId,
    fabricColorPresetInternalId: order.fabricColorPresetInternalId,
  );
}
OrderItemSummary? referenceOrderItem(
  OrderSummary order,
  GarmentType garmentType,
) {
  final fromItems = order.itemOf(garmentType);
  if (fromItems != null) return fromItems;
  if (garmentType == GarmentType.perahanTunban) {
    return order.legacyPerahanTunbanItemView();
  }
  return null;
}

ReferenceMeasurementsCopy? buildItemMeasurementsCopy(
  OrderItemSummary item,
  OrderMeasurementSnapshotView? snap,
) {
  final items = (snap?.items ?? const [])
      .map(
        (it) => OrderMeasurementSnapshotItemInput(
          measurementTypeInternalId: it.measurementTypeInternalId,
          typeName: it.typeName,
          value: it.value,
          unitCode: it.unitCode,
          sortOrder: it.sortOrder,
        ),
      )
      .toList(growable: false);

  var text = item.measurementsSnapshot.trim();
  if (text.isEmpty && items.isNotEmpty) {
    text = MeasurementProfileFormatting.buildDisplayText(
      lines: items
          .map(
            (it) => MeasurementProfileLine(
              measurementTypeInternalId: it.measurementTypeInternalId,
              typeName: it.typeName,
              value: it.value,
              unitCode: it.unitCode,
            ),
          )
          .toList(),
      notes: '',
    );
  }
  if (text.isEmpty && items.isEmpty) return null;
  return ReferenceMeasurementsCopy(snapshotText: text, items: items);
}

ReferenceStyleCopy? buildItemStyleCopy(OrderItemSummary item) {
  final name = item.styleName.trim();
  final summary = item.styleSummary.trim();
  final selection =
      StyleOrderSelection.fromJsonString(item.styleSelectionJson);
  if (name.isEmpty && summary.isEmpty && selection.isEmpty) return null;
  return ReferenceStyleCopy(
    styleName: item.styleName,
    styleNameInternalId: item.styleNameInternalId,
    selection: selection,
    styleSummary: item.styleSummary,
  );
}

String previousItemStyleDisplayText(OrderItemSummary item) {
  final copy = buildItemStyleCopy(item);
  if (copy == null) return '';
  if (copy.styleSummary.trim().isNotEmpty) return copy.styleSummary.trim();
  return copy.styleName.trim();
}

ReferenceDesignCopy? buildItemDesignCopy(
  OrderItemSummary item, {
  required bool catalogItemExists,
}) {
  final hasData = item.catalogDesignNameSnapshot.trim().isNotEmpty ||
      item.catalogItemInternalId != null ||
      (item.catalogImagePathSnapshot?.trim().isNotEmpty ?? false) ||
      (item.catalogThumbnailPathSnapshot?.trim().isNotEmpty ?? false);
  if (!hasData) return null;
  return ReferenceDesignCopy(
    catalogItemInternalId:
        catalogItemExists ? item.catalogItemInternalId : null,
    catalogDesignName: item.catalogDesignNameSnapshot,
    catalogDesignerShopName: item.catalogDesignerShopNameSnapshot,
    catalogImagePath: item.catalogImagePathSnapshot,
    catalogThumbnailPath: item.catalogThumbnailPathSnapshot,
  );
}

ReferenceFabricCopy? buildItemFabricCopy(OrderItemSummary item) {
  if (!item.hasFabric) return null;
  return ReferenceFabricCopy(
    fabricName: item.fabricNameSnapshot,
    fabricColor: item.fabricColorSnapshot,
    fabricNamePresetInternalId: item.fabricNamePresetInternalId,
    fabricColorPresetInternalId: item.fabricColorPresetInternalId,
    clothMeters: item.clothMetersSnapshot,
    clothPriceAmountMinor: item.clothPriceAmountMinor,
  );
}

String previousItemFabricDisplayText(
  OrderItemSummary item,
  AppLocalizations l10n,
) {
  final name = item.fabricNameSnapshot.trim();
  final color = item.fabricColorSnapshot.trim();
  final id = item.fabricIdSnapshot.trim();
  if (name.isEmpty && color.isEmpty && id.isEmpty) return '';
  if (name.isNotEmpty && color.isNotEmpty && id.isNotEmpty) {
    return l10n.ordersComposerFabricSummary(name, color, id);
  }
  return l10n.ordersComposerFabricPartialSummary(
    name.isEmpty ? '—' : name,
    color.isEmpty ? '—' : color,
  );
}

String previousFabricDisplayText(OrderSummary order, AppLocalizations l10n) {
  final name = order.fabricNameSnapshot.trim();
  final color = order.fabricColorSnapshot.trim();
  final id = order.fabricIdSnapshot.trim();
  if (name.isEmpty && color.isEmpty && id.isEmpty) return '';
  if (name.isNotEmpty && color.isNotEmpty && id.isNotEmpty) {
    return l10n.ordersComposerFabricSummary(name, color, id);
  }
  return l10n.ordersComposerFabricPartialSummary(
    name.isEmpty ? '—' : name,
    color.isEmpty ? '—' : color,
  );
}

String previousShapeDisplayText(
  OrderSummary order, {
  OrderItemSummary? item,
}) {
  final json = item?.styleSelectionJson ?? order.styleSelectionJson;
  if (json.trim().isEmpty) return '';
  final display = formatOrderShapeSelectionDisplay(styleSelectionJson: json);
  if (display.compactPreview.trim().isNotEmpty) {
    return display.compactPreview.trim();
  }
  if (display.detailedText.trim().isNotEmpty) {
    return display.detailedText.trim();
  }
  return display.summaryFallbackText.trim();
}

String previousStyleSheetDisplayText(
  OrderSummary order, {
  OrderItemSummary? item,
}) {
  final styleText = item != null
      ? previousItemStyleDisplayText(item)
      : previousStyleDisplayText(order);
  final shapeText = previousShapeDisplayText(order, item: item);
  if (styleText.isEmpty && shapeText.isEmpty) return '';
  if (styleText.isEmpty) return shapeText;
  if (shapeText.isEmpty) return styleText;
  return '$styleText\n$shapeText';
}

String formatPreviousPaymentDetailText(
  AppLocalizations l10n,
  OrderSummary order,
  List<PaymentSummary> payments,
  Map<String, int> paidByOrderId,
  bool paymentsLedgerLoaded,
  String Function(AppLocalizations l10n, int minor) money,
) {
  final summary = formatReferenceOrderPaymentSummary(
    l10n,
    order,
    paidByOrderId,
    paymentsLedgerLoaded,
    money,
  );
  final rows = payments
      .where((p) => p.orderInternalId == order.internalId)
      .toList()
    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  if (rows.isEmpty) return summary;
  final recent = rows.take(3).map((p) => money(l10n, p.amountMinor)).join(', ');
  return '$summary\n$recent';
}

/// Which previous-order context to show at the top of a workflow sheet.
enum ComposerSheetPreviousKind {
  measurements,
  style,
  fabric,
  payment,
  delivery,
}

/// Previous-order block for workflow modal sheets (top section).
class ComposerSheetPreviousSection extends ConsumerWidget {
  const ComposerSheetPreviousSection({
    super.key,
    required this.referenceOrder,
    required this.kind,
    this.referenceItem,
    this.currentTextForDiff,
    this.currentIsMeaningfulForDiff = false,
    this.onUsePrevious,
    required this.money,
  });

  final OrderSummary referenceOrder;
  final ComposerSheetPreviousKind kind;
  final OrderItemSummary? referenceItem;
  final String? currentTextForDiff;
  final bool currentIsMeaningfulForDiff;
  final VoidCallback? onUsePrevious;
  final String Function(AppLocalizations l10n, int minor) money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final orderNo = formatDisplayOrderNo(referenceOrder.displayOrderNo);

    switch (kind) {
      case ComposerSheetPreviousKind.measurements:
        return ComposerMeasurementsPreviousReference(
          referenceOrder: referenceOrder,
          referenceItem: referenceItem,
          l10n: l10n,
          currentMeasurementsText: currentTextForDiff ?? '',
          currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
          onUsePrevious: onUsePrevious,
        );
      case ComposerSheetPreviousKind.style:
        final text = previousStyleSheetDisplayText(
          referenceOrder,
          item: referenceItem,
        );
        if (text.trim().isEmpty) return const SizedBox.shrink();
        return ComposerSectionPreviousReference(
          l10n: l10n,
          previousText: text,
          currentTextForDiff: currentTextForDiff,
          currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
          usePreviousLabel: onUsePrevious != null
              ? l10n.ordersComposerUsePreviousStyleCta
              : null,
          onUsePrevious: onUsePrevious,
        );
      case ComposerSheetPreviousKind.fabric:
        final text = referenceItem != null
            ? previousItemFabricDisplayText(referenceItem!, l10n)
            : previousFabricDisplayText(referenceOrder, l10n);
        if (text.trim().isEmpty) return const SizedBox.shrink();
        return ComposerSectionPreviousReference(
          l10n: l10n,
          previousText: text,
          currentTextForDiff: currentTextForDiff,
          currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
          usePreviousLabel: onUsePrevious != null
              ? l10n.ordersComposerUsePreviousFabricCta
              : null,
          onUsePrevious: onUsePrevious,
        );
      case ComposerSheetPreviousKind.payment:
        final shopId = ref.watch(effectiveShopIdProvider);
        final paymentsAsync = ref.watch(paymentsForShopProvider(shopId));
        return paymentsAsync.when(
          loading: () => const SizedBox.shrink(),
          error: (_, _) => const SizedBox.shrink(),
          data: (payments) {
            final paidByOrderId =
                referencePaidByOrderIdFromPayments(
              payments
                  .map(
                    (p) => (
                      orderInternalId: p.orderInternalId,
                      amountMinor: p.amountMinor,
                    ),
                  )
                  .toList(),
            );
            final text = formatPreviousPaymentDetailText(
              l10n,
              referenceOrder,
              payments,
              paidByOrderId,
              true,
              money,
            );
            if (text.trim().isEmpty) return const SizedBox.shrink();
            return ComposerSectionPreviousReference(
              l10n: l10n,
              previousText: text,
              currentTextForDiff: currentTextForDiff,
              currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
              collapsible: true,
            );
          },
        );
      case ComposerSheetPreviousKind.delivery:
        final deliveryText = AppCalendarFormat.mediumDate(
          l10n,
          calendar,
          referenceOrder.deliveryDate,
          locale,
        );
        return ComposerSectionPreviousReference(
          l10n: l10n,
          previousText:
              '${l10n.ordersNumberPrefix(orderNo)}\n${l10n.ordersComposerPreviousDeliveryLabel}: $deliveryText',
          currentTextForDiff: currentTextForDiff,
          currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
          collapsible: false,
        );
    }
  }
}

/// Sheet header: title + previous order section + divider.
class ComposerSheetPreviousHeader extends StatelessWidget {
  const ComposerSheetPreviousHeader({
    super.key,
    required this.title,
    required this.previousSection,
  });

  final String title;
  final Widget previousSection;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
          child: Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: previousSection,
        ),
        const Divider(height: 24, indent: 16, endIndent: 16),
      ],
    );
  }
}

// --- Widgets ---

/// Compact previous-order reference card shown after customer selection.
class ComposerPreviousOrderReferenceCard extends ConsumerWidget {
  const ComposerPreviousOrderReferenceCard({
    super.key,
    required this.customerId,
    required this.selectedReferenceOrderId,
    required this.onReferenceOrderSelected,
    required this.money,
  });

  final String customerId;
  final String? selectedReferenceOrderId;
  final ValueChanged<String> onReferenceOrderSelected;
  final String Function(AppLocalizations l10n, int minor) money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncShopPayments = ref.watch(paymentsForShopProvider(shopId));

    return ordersAsync.when(
      loading: () => const SizedBox.shrink(),
      error: (error, stackTrace) => const SizedBox.shrink(),
      data: (orders) {
        final customerOrders =
            customerOrdersForReference(orders, customerId);
        if (customerOrders.isEmpty) {
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: Card(
              color: prideListCardSurface(Theme.of(context).colorScheme),
              child: ListTile(
                leading: Icon(
                  Icons.history,
                  color: Theme.of(context).colorScheme.outline,
                ),
                title: Text(l10n.ordersComposerPreviousOrderTitle),
                subtitle: Text(l10n.ordersComposerNoPreviousOrders),
              ),
            ),
          );
        }

        final refOrder = resolveReferenceOrder(
          customerOrders,
          selectedReferenceOrderId,
        );
        if (refOrder == null) return const SizedBox.shrink();

        final paidByOrderId = asyncShopPayments.hasValue
            ? referencePaidByOrderIdFromPayments(
                (asyncShopPayments.value ?? const [])
                    .map(
                      (p) => (
                        orderInternalId: p.orderInternalId,
                        amountMinor: p.amountMinor,
                      ),
                    )
                    .toList(),
              )
            : const <String, int>{};
        final paymentsLedgerLoaded = asyncShopPayments.hasValue;
        final paymentSummaryText = formatReferenceOrderPaymentSummary(
          l10n,
          refOrder,
          paidByOrderId,
          paymentsLedgerLoaded,
          money,
        );

        final takenText = AppCalendarFormat.dateTimeMedium(
          l10n,
          calendar,
          refOrder.createdAt,
          locale,
        );
        final deliveryText = AppCalendarFormat.mediumDate(
          l10n,
          calendar,
          refOrder.deliveryDate,
          locale,
        );
        final statusText = orderStatusLabel(refOrder.status, l10n);
        final orderNo = formatDisplayOrderNo(refOrder.displayOrderNo);

        final summaryParts = <String>[
          if (refOrder.styleName.trim().isNotEmpty) refOrder.styleName.trim(),
          if (refOrder.catalogDesignNameSnapshot.trim().isNotEmpty)
            refOrder.catalogDesignNameSnapshot.trim(),
          if (refOrder.measurementsSnapshot.trim().isNotEmpty)
            l10n.ordersComposerMeasurementsSummary,
        ];

        return Padding(
          padding: const EdgeInsets.only(bottom: 14),
          child: Card(
            color: prideListCardSurface(Theme.of(context).colorScheme),
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: Icon(
                    Icons.history,
                    color: Theme.of(context).colorScheme.secondary,
                  ),
                  title: Text(l10n.ordersComposerPreviousOrderTitle),
                  subtitle: Text(l10n.ordersComposerPreviousOrderSubtitle),
                ),
                Padding(
                  padding: const EdgeInsetsDirectional.fromSTEB(16, 0, 16, 8),
                  child: DecoratedBox(
                    decoration: BoxDecoration(
                      border: Border.all(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withValues(alpha: 0.8),
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          Text(
                            l10n.ordersNumberPrefix(orderNo),
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          const SizedBox(height: 6),
                          Text(
                            l10n.ordersTakenOn(takenText),
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            statusText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          Text(
                            '${l10n.ordersComposerDeliveryDateTitle}: $deliveryText',
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (summaryParts.isNotEmpty) ...[
                            const SizedBox(height: 6),
                            Text(
                              summaryParts.join(' · '),
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                          ],
                          const SizedBox(height: 6),
                          Text(
                            l10n.ordersComposerPreviousPaymentLabel,
                            style: Theme.of(context).textTheme.labelMedium,
                          ),
                          Text(
                            paymentSummaryText,
                            style: Theme.of(context).textTheme.bodySmall,
                          ),
                          if (refOrder.internalNotes.trim().isNotEmpty) ...[
                            const SizedBox(height: 6),
                            _CollapsiblePreviousText(
                              l10n: l10n,
                              title: l10n.ordersDetailSectionInternalNotes,
                              body: refOrder.internalNotes.trim(),
                            ),
                          ],
                        ],
                      ),
                    ),
                  ),
                ),
                if (customerOrders.length > 1)
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: () => showComposerReferenceOrderPicker(
                        context,
                        l10n,
                        calendar,
                        locale,
                        customerOrders,
                        refOrder.internalId,
                        onReferenceOrderSelected,
                        money,
                        paidByOrderId,
                        paymentsLedgerLoaded,
                      ),
                      icon: const Icon(Icons.swap_horiz, size: 18),
                      label: Text(
                        l10n.ordersComposerChangeReferenceOrderCta,
                        maxLines: 2,
                        softWrap: true,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

Future<void> showComposerReferenceOrderPicker(
  BuildContext context,
  AppLocalizations l10n,
  DateCalendarSystem calendar,
  String locale,
  List<OrderSummary> customerOrders,
  String currentId,
  ValueChanged<String> onSelected,
  String Function(AppLocalizations l10n, int minor) money,
  Map<String, int> paidByOrderId,
  bool paymentsLedgerLoaded,
) async {
  final picked = await showPrideModalBottomSheet<String>(
    context: context,
    builder: (ctx) {
      return PrideDraggableSheetScaffold(
        initialChildSize: 0.65,
        minChildSize: 0.35,
        maxChildSize: 0.75,
        header: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            ListTile(
              title: Text(l10n.ordersComposerCompareWithPrevious),
              subtitle: Text(l10n.ordersComposerChangeReferenceOrderCta),
            ),
            const Divider(height: 1),
          ],
        ),
        body: (scrollController) {
          return ListView.builder(
            controller: scrollController,
            itemCount: customerOrders.length,
            itemBuilder: (context, index) {
              final o = customerOrders[index];
              final totals = referenceOrderPaymentTotals(
                order: o,
                paidByOrderId: paidByOrderId,
                paymentsLedgerLoaded: paymentsLedgerLoaded,
              );
              final deliveryText = AppCalendarFormat.mediumDate(
                l10n,
                calendar,
                o.deliveryDate,
                locale,
              );
              return ListTile(
                selected: o.internalId == currentId,
                onTap: () => Navigator.pop(ctx, o.internalId),
                title: Text(
                  l10n.ordersNumberPrefix(
                    formatDisplayOrderNo(o.displayOrderNo),
                  ),
                ),
                subtitle: Text(
                  l10n.ordersComposerRecentOrderRowSubtitle(
                    deliveryText,
                    money(l10n, totals.remainingMinor),
                  ),
                ),
                trailing: Text(orderStatusLabel(o.status, l10n)),
              );
            },
          );
        },
      );
    },
  );
  if (picked != null && picked.isNotEmpty) {
    onSelected(picked);
  }
}

/// Per-section compact previous reference block under composer hub cards.
class ComposerSectionPreviousReference extends StatelessWidget {
  const ComposerSectionPreviousReference({
    super.key,
    required this.l10n,
    required this.previousText,
    this.currentTextForDiff,
    this.currentIsMeaningfulForDiff = false,
    this.usePreviousLabel,
    this.onUsePrevious,
    this.trailing,
    this.collapsible = true,
  });

  final AppLocalizations l10n;
  final String previousText;
  final String? currentTextForDiff;
  final bool currentIsMeaningfulForDiff;
  final String? usePreviousLabel;
  final VoidCallback? onUsePrevious;
  final Widget? trailing;
  final bool collapsible;

  @override
  Widget build(BuildContext context) {
    final text = previousText.trim();
    if (text.isEmpty) return const SizedBox.shrink();

    final differs = composerReferenceShouldShowDiff(
      current: currentTextForDiff,
      previous: text,
      currentIsMeaningful: currentIsMeaningfulForDiff,
    );
    final scheme = Theme.of(context).colorScheme;

    final previousBody = collapsible && text.length > 120
        ? _CollapsiblePreviousTextBody(l10n: l10n, body: text)
        : Text(
            text,
            style: Theme.of(context).textTheme.bodySmall,
          );

    return Padding(
      padding: const EdgeInsetsDirectional.fromSTEB(12, 0, 12, 12),
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: prideFriendlyTileFill(scheme, variant: 1),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: differs
                ? scheme.tertiary.withValues(alpha: 0.45)
                : scheme.outlineVariant.withValues(alpha: 0.55),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Row(
                      children: [
                        Text(
                          l10n.ordersComposerPreviousValueLabel,
                          style: Theme.of(context)
                              .textTheme
                              .labelMedium
                              ?.copyWith(
                                color: scheme.secondary,
                                fontWeight: FontWeight.w600,
                              ),
                        ),
                        if (differs) ...[
                          const SizedBox(width: 6),
                          Icon(
                            Icons.compare_arrows,
                            size: 16,
                            color: scheme.tertiary,
                          ),
                        ],
                      ],
                    ),
                  ),
                  if (trailing != null) ...[
                    const SizedBox(width: 8),
                    trailing!,
                  ],
                ],
              ),
              const SizedBox(height: 4),
              previousBody,
              if (onUsePrevious != null && usePreviousLabel != null) ...[
                const SizedBox(height: 8),
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: FilledButton.tonal(
                    onPressed: onUsePrevious,
                    style: FilledButton.styleFrom(
                      visualDensity: VisualDensity.compact,
                      padding: const EdgeInsetsDirectional.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                    ),
                    child: Text(
                      usePreviousLabel!,
                      maxLines: 2,
                      softWrap: true,
                      overflow: TextOverflow.ellipsis,
                      textAlign: TextAlign.center,
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
}

class ComposerMeasurementsPreviousReference extends ConsumerWidget {
  const ComposerMeasurementsPreviousReference({
    super.key,
    required this.referenceOrder,
    required this.l10n,
    required this.currentMeasurementsText,
    required this.currentIsMeaningfulForDiff,
    this.referenceItem,
    this.onUsePrevious,
  });

  final OrderSummary referenceOrder;
  final OrderItemSummary? referenceItem;
  final AppLocalizations l10n;
  final String currentMeasurementsText;
  final bool currentIsMeaningfulForDiff;
  final VoidCallback? onUsePrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final item = referenceItem;
    final snapAsync = item != null
        ? ref.watch(
            orderItemMeasurementSnapshotProvider(
              OrderItemSnapshotKey(
                orderInternalId: referenceOrder.internalId,
                orderItemInternalId: item.internalId,
              ),
            ),
          )
        : ref.watch(
            orderMeasurementSnapshotProvider(referenceOrder.internalId),
          );
    final snap = snapAsync.valueOrNull;
    final text = item != null
        ? (buildItemMeasurementsCopy(item, snap)?.snapshotText ??
            item.measurementsSnapshot.trim())
        : previousMeasurementsDisplayText(referenceOrder, snap);
    if (text.trim().isEmpty) return const SizedBox.shrink();

    final copyReady = !snapAsync.isLoading &&
        (item != null
            ? buildItemMeasurementsCopy(item, snap) != null
            : buildMeasurementsCopy(referenceOrder, snap) != null);
    final canUsePrevious = copyReady && onUsePrevious != null;

    return ComposerSectionPreviousReference(
      l10n: l10n,
      previousText: text,
      currentTextForDiff: currentMeasurementsText,
      currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
      usePreviousLabel: onUsePrevious != null
          ? (snapAsync.isLoading
              ? l10n.loading
              : l10n.ordersComposerUsePreviousMeasurementsCta)
          : null,
      onUsePrevious: canUsePrevious ? onUsePrevious : null,
    );
  }
}

class ComposerDesignPreviousReference extends ConsumerWidget {
  const ComposerDesignPreviousReference({
    super.key,
    required this.referenceOrder,
    required this.l10n,
    required this.currentDesignSummary,
    required this.currentIsMeaningfulForDiff,
    this.onUsePrevious,
  });

  final OrderSummary referenceOrder;
  final AppLocalizations l10n;
  final String currentDesignSummary;
  final bool currentIsMeaningfulForDiff;
  final VoidCallback? onUsePrevious;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final text = previousDesignDisplayText(referenceOrder);
    if (text.trim().isEmpty &&
        referenceOrder.catalogDesignNameSnapshot.trim().isEmpty &&
        referenceOrder.catalogItemInternalId == null) {
      return const SizedBox.shrink();
    }
    if (text.trim().isEmpty) return const SizedBox.shrink();

    Widget? thumb;
    final thumbPath = referenceOrder.catalogThumbnailPathSnapshot ??
        referenceOrder.catalogImagePathSnapshot;
    if (thumbPath != null && thumbPath.trim().isNotEmpty) {
      thumb = CatalogTileImage(
        thumbnailPath: referenceOrder.catalogThumbnailPathSnapshot,
        imagePath: referenceOrder.catalogImagePathSnapshot,
        borderRadius: 6,
        dimension: 48,
      );
    }

    return ComposerSectionPreviousReference(
      l10n: l10n,
      previousText: text,
      currentTextForDiff: currentDesignSummary,
      currentIsMeaningfulForDiff: currentIsMeaningfulForDiff,
      trailing: thumb,
      usePreviousLabel:
          onUsePrevious != null ? l10n.ordersComposerUsePreviousDesignCta : null,
      onUsePrevious: onUsePrevious,
    );
  }
}

class _CollapsiblePreviousTextBody extends StatefulWidget {
  const _CollapsiblePreviousTextBody({
    required this.l10n,
    required this.body,
  });

  final AppLocalizations l10n;
  final String body;

  @override
  State<_CollapsiblePreviousTextBody> createState() =>
      _CollapsiblePreviousTextBodyState();
}

class _CollapsiblePreviousTextBodyState
    extends State<_CollapsiblePreviousTextBody> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final body = widget.body;
    final preview = body.length > 100 ? '${body.substring(0, 100)}…' : body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          _expanded ? body : preview,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (body.length > 100)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? widget.l10n.showLessCta : widget.l10n.showMoreCta,
              ),
            ),
          ),
      ],
    );
  }
}

class _CollapsiblePreviousText extends StatefulWidget {
  const _CollapsiblePreviousText({
    required this.l10n,
    required this.title,
    required this.body,
  });

  final AppLocalizations l10n;
  final String title;
  final String body;

  @override
  State<_CollapsiblePreviousText> createState() =>
      _CollapsiblePreviousTextState();
}

class _CollapsiblePreviousTextState extends State<_CollapsiblePreviousText> {
  var _expanded = false;

  @override
  Widget build(BuildContext context) {
    final body = widget.body;
    final preview = body.length > 100 ? '${body.substring(0, 100)}…' : body;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          widget.title,
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 4),
        Text(
          _expanded ? body : preview,
          style: Theme.of(context).textTheme.bodySmall,
        ),
        if (body.length > 100)
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: () => setState(() => _expanded = !_expanded),
              child: Text(
                _expanded ? widget.l10n.showLessCta : widget.l10n.showMoreCta,
              ),
            ),
          ),
      ],
    );
  }
}
