import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_input.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/style/style_order_selection.dart';

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

  int totalMinor() {
    var sum = 0;
    for (final type in selectedGarmentTypes) {
      sum += items[type]!.priceAmountMinor;
    }
    return sum;
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

  bool canSave({
    required bool customerSelected,
    required bool deliveryDateSet,
    required int paidMinor,
  }) {
    if (!customerSelected) return false;
    if (!deliveryDateSet) return false;
    if (!hasAtLeastOneItem) return false;
    for (final type in selectedGarmentTypes) {
      if (!items[type]!.canSaveIncluded) return false;
    }
    final total = totalMinor();
    if (total <= 0) return false;
    if (paidMinor < 0) return false;
    if (paidMinor > total) return false;
    return true;
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
          measurementSnapshotItems: draft.measurementSnapshotItems.isEmpty
              ? null
              : List<OrderMeasurementSnapshotItemInput>.of(
                  draft.measurementSnapshotItems,
                ),
          styleName: draft.styleName,
          styleNameInternalId: draft.styleNameInternalId,
          styleSelectionJson: selection.toJsonString(),
          styleSummary: draft.styleSummary,
          catalogItemInternalId: draft.catalogItemInternalId,
          catalogDesignNameSnapshot: draft.catalogDesignName,
          catalogDesignerShopNameSnapshot: draft.catalogDesignerShopName,
          catalogSourceImagePath: draft.catalogImagePath,
          catalogSourceThumbnailPath: draft.catalogThumbnailPath,
          fabricNameSnapshot: draft.fabricName,
          fabricColorSnapshot: draft.fabricColor,
          fabricIdSnapshot: draft.fabricId,
          fabricNamePresetInternalId: draft.fabricNamePresetInternalId,
          fabricColorPresetInternalId: draft.fabricColorPresetInternalId,
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
