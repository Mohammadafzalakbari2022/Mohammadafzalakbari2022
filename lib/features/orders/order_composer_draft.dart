import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_input.dart';
import '../../data/local/style/style_order_selection.dart';
import 'order_composer_measurements_result.dart';

/// Item-aware new-order composer state (pure logic; testable).
class OrderComposerDraft {
  const OrderComposerDraft({required this.items});

  factory OrderComposerDraft.initial() {
    return OrderComposerDraft(
      items: {
        for (final type in GarmentType.values) type: OrderItemDraft.empty(type),
      },
    );
  }

  final Map<GarmentType, OrderItemDraft> items;

  List<GarmentType> get selectedGarmentTypes => GarmentType.values
      .where((t) => items[t]?.included == true)
      .toList(growable: false);

  bool get hasAtLeastOneItem => selectedGarmentTypes.isNotEmpty;

  /// Cloth price counts toward total only when the cloth block is enabled and priced.
  static bool clothCountsInPayment(
    OrderItemDraft item, {
    required bool clothBlockEnabled,
  }) =>
      clothBlockEnabled && item.clothPriceAmountMinor > 0;

  static int clothPriceMinorForItem(
    OrderItemDraft item, {
    required bool clothBlockEnabled,
  }) =>
      clothCountsInPayment(item, clothBlockEnabled: clothBlockEnabled)
          ? item.clothPriceAmountMinor
          : 0;

  int garmentPriceTotalMinor() {
    var sum = 0;
    for (final type in selectedGarmentTypes) {
      sum += items[type]!.priceAmountMinor;
    }
    return sum;
  }

  int clothPriceTotalMinor({required bool clothBlockEnabled}) {
    if (!clothBlockEnabled) return 0;
    var sum = 0;
    for (final type in selectedGarmentTypes) {
      sum += clothPriceMinorForItem(
        items[type]!,
        clothBlockEnabled: clothBlockEnabled,
      );
    }
    return sum;
  }

  int totalMinor({required bool clothBlockEnabled}) {
    return garmentPriceTotalMinor() +
        clothPriceTotalMinor(clothBlockEnabled: clothBlockEnabled);
  }

  List<({GarmentType type, int amountMinor})> clothPaymentLines({
    required bool clothBlockEnabled,
  }) {
    if (!clothBlockEnabled) return const [];
    return [
      for (final type in selectedGarmentTypes)
        if (clothCountsInPayment(
          items[type]!,
          clothBlockEnabled: clothBlockEnabled,
        ))
          (type: type, amountMinor: items[type]!.clothPriceAmountMinor),
    ];
  }

  bool measurementsDoneForAllIncluded() {
    for (final type in selectedGarmentTypes) {
      if (!items[type]!.hasMeasurements) return false;
    }
    return hasAtLeastOneItem;
  }

  bool styleDoneForAllIncluded() {
    for (final type in selectedGarmentTypes) {
      if (!items[type]!.hasStyle) return false;
    }
    return hasAtLeastOneItem;
  }

  bool fabricDoneForAnyIncluded() {
    for (final type in selectedGarmentTypes) {
      if (items[type]!.hasFabric) return true;
    }
    return false;
  }

  /// Receipt composer save readiness: customer, garment prices, and initial payment.
  bool canSave({
    required bool customerSelected,
    required int paidMinor,
    required bool clothBlockEnabled,
    bool requireInitialPayment = true,
  }) {
    return firstOrderComposerSaveValidationIssue(
          draft: this,
          customerSelected: customerSelected,
          paidMinor: paidMinor,
          clothBlockEnabled: clothBlockEnabled,
          requireInitialPayment: requireInitialPayment,
        ) ==
        null;
  }

  OrderComposerDraft toggleGarment(GarmentType type, bool included) {
    final current = items[type]!;
    if (current.included == included) return this;
    final next = Map<GarmentType, OrderItemDraft>.from(items);
    next[type] = current.copyWith(included: included);
    if (!next.values.any((d) => d.included)) {
      return this;
    }
    return OrderComposerDraft(items: next);
  }

  OrderComposerDraft updateItem(
    GarmentType type,
    OrderItemDraft draft,
  ) {
    final next = Map<GarmentType, OrderItemDraft>.from(items);
    next[type] = draft;
    return OrderComposerDraft(items: next);
  }

  OrderComposerDraft updateItemPrice(GarmentType type, int priceMinor) {
    return updateItem(type, items[type]!.copyWith(priceAmountMinor: priceMinor));
  }

  List<OrderItemCreateInput> toCreateInputs({
    required Map<GarmentType, StyleOrderSelection> styleSelections,
    bool includeClothFields = true,
  }) {
    final inputs = <OrderItemCreateInput>[];
    for (final type in selectedGarmentTypes) {
      final draft = items[type]!;
      final selection = styleSelections[type] ?? const StyleOrderSelection.empty();
      inputs.add(
        OrderItemCreateInput(
          garmentType: type,
          priceAmountMinor: draft.priceAmountMinor,
          sortOrder: type.defaultSortOrder,
          itemNotes: draft.itemNotes,
          measurementsSnapshot: draft.measurementsSnapshot,
          sourceMeasurementProfileId: draft.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: draft.sourceMeasurementProfileLabel,
          measurementSnapshotItems:
              normalizedMeasurementSnapshotItems(draft.measurementSnapshotItems),
          styleName: draft.styleName,
          styleNameInternalId: draft.styleNameInternalId,
          styleSelectionJson: selection.toJsonString(),
          styleSummary: draft.styleSummary,
          catalogItemInternalId: draft.catalogItemInternalId,
          catalogDesignNameSnapshot: draft.catalogDesignName,
          catalogDesignerShopNameSnapshot: draft.catalogDesignerShopName,
          catalogSourceImagePath: draft.catalogImagePath,
          catalogSourceThumbnailPath: draft.catalogThumbnailPath,
          fabricNameSnapshot:
              includeClothFields ? draft.fabricName : '',
          fabricColorSnapshot:
              includeClothFields ? draft.fabricColor : '',
          fabricIdSnapshot: includeClothFields ? draft.fabricId : '',
          fabricNamePresetInternalId:
              includeClothFields ? draft.fabricNamePresetInternalId : null,
          fabricColorPresetInternalId:
              includeClothFields ? draft.fabricColorPresetInternalId : null,
          clothMetersSnapshot: includeClothFields ? draft.clothMeters : '',
          clothPriceAmountMinor:
              includeClothFields ? draft.clothPriceAmountMinor : 0,
          clothSourceIndex: includeClothFields ? draft.clothSourceIndex : 0,
          clothStockSkuInternalId:
              includeClothFields ? draft.clothStockSkuInternalId : null,
          clothSaleCostAmountMinor:
              includeClothFields ? draft.clothSaleCostAmountMinor : 0,
        ),
      );
    }
    return inputs;
  }

  /// Primary item for customer last-catalog update (Perahan/Tunban when present).
  OrderItemDraft? primaryCatalogItem() {
    final perahan = items[GarmentType.perahanTunban];
    if (perahan?.included == true && perahan!.catalogDesignName.trim().isNotEmpty) {
      return perahan;
    }
    for (final type in selectedGarmentTypes) {
      final d = items[type]!;
      if (d.catalogDesignName.trim().isNotEmpty) return d;
    }
    return null;
  }

  bool get showPerahanPreviousReference =>
      items[GarmentType.perahanTunban]?.included == true;

  bool showPreviousReferenceForGarment(GarmentType type) =>
      items[type]?.included == true;
}

/// First blocking validation issue when saving from the order composer.
enum OrderComposerSaveValidationIssue {
  customerRequired,
  noItems,
  garmentPriceRequired,
  totalRequired,
  initialPaymentRequired,
  paymentExceedsTotal,
}

OrderComposerSaveValidationIssue? firstOrderComposerSaveValidationIssue({
  required OrderComposerDraft draft,
  required bool customerSelected,
  required int paidMinor,
  required bool clothBlockEnabled,
  bool requireInitialPayment = true,
}) {
  if (!customerSelected) {
    return OrderComposerSaveValidationIssue.customerRequired;
  }
  if (!draft.hasAtLeastOneItem) {
    return OrderComposerSaveValidationIssue.noItems;
  }
  for (final type in draft.selectedGarmentTypes) {
    if (!draft.items[type]!.hasRequiredPrice) {
      return OrderComposerSaveValidationIssue.garmentPriceRequired;
    }
  }
  final total = draft.totalMinor(clothBlockEnabled: clothBlockEnabled);
  if (total <= 0) {
    return OrderComposerSaveValidationIssue.totalRequired;
  }
  if (requireInitialPayment && paidMinor <= 0) {
    return OrderComposerSaveValidationIssue.initialPaymentRequired;
  }
  if (paidMinor > total) {
    return OrderComposerSaveValidationIssue.paymentExceedsTotal;
  }
  return null;
}

/// One line in the payment breakdown sheet.
class OrderPaymentBreakdownLine {
  const OrderPaymentBreakdownLine({
    required this.garmentType,
    required this.amountMinor,
  });

  final GarmentType garmentType;
  final int amountMinor;
}

List<OrderPaymentBreakdownLine> paymentBreakdownFromDraft(
  OrderComposerDraft draft,
) {
  return [
    for (final type in draft.selectedGarmentTypes)
      OrderPaymentBreakdownLine(
        garmentType: type,
        amountMinor: draft.items[type]!.priceAmountMinor,
      ),
  ];
}
