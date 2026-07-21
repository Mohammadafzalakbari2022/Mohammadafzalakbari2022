import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/app/responsive_breakpoints.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_close_button.dart';
import 'package:pride_v3/core/widgets/pride_form_bottom_bar.dart';
import 'package:pride_v3/core/widgets/pride_optional_field.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/core/printing/thermal_print_order.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_name_rules.dart';
import '../../data/local/customer_summary.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/entities/garment_type.dart';
import '../../data/local/entities/order_status.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_input.dart';
import '../../data/local/order_item_snapshot_key.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_sync_payload.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import '../../data/local/style/style_order_selection.dart';
import '../customers/new_customer_screen.dart';
import 'order_composer_customer_picker.dart';
import '../settings/composer_visibility_provider.dart';
import '../settings/cloth/cloth_sync_helpers.dart';
import 'order_composer_draft.dart';
import 'order_composer_receipt_garment_block.dart';
import 'order_composer_item_card.dart';
import 'order_composer_reference.dart';
import 'order_composer_measurements_panel.dart';
import 'order_composer_measurements_result.dart';
import 'order_invoice_share.dart';
import 'order_invoice_view.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';

import 'order_payment_mutations.dart';
import 'order_payment_rules.dart';
import 'order_status_label.dart';

/// Route to the order composer, optionally with a preselected customer and
/// in-memory reference order override.
String orderComposerRoute({
  String? customerId,
  String? referenceOrderId,
  String? orderId,
}) {
  final id = customerId?.trim();
  final refId = referenceOrderId?.trim();
  final editId = orderId?.trim();
  final params = <String, String>{};
  if (editId != null && editId.isNotEmpty) {
    params['orderId'] = editId;
  }
  if (id != null && id.isNotEmpty) {
    params['customerId'] = id;
  }
  if (refId != null && refId.isNotEmpty) {
    params['referenceOrderId'] = refId;
  }
  if (params.isEmpty) return '/app/orders';
  final query = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
  return '/app/orders?$query';
}

/// Validates [referenceOrderId] belongs to [customerId]; otherwise returns null.
String? resolveInitialReferenceOrderId({
  required List<OrderSummary> allOrders,
  required String customerId,
  String? referenceOrderId,
}) {
  final pick = referenceOrderId?.trim();
  if (pick == null || pick.isEmpty) return null;
  final customerOrders = customerOrdersForReference(allOrders, customerId);
  for (final o in customerOrders) {
    if (o.internalId == pick) return o.internalId;
  }
  return null;
}

/// Resolves [customerId] against [customers] for composer prefill.
CustomerSummary? resolveComposerPrefillCustomer(
  List<CustomerSummary> customers,
  String? customerId,
) {
  final id = customerId?.trim();
  if (id == null || id.isEmpty) return null;
  for (final c in customers) {
    if (c.internalId == id) return c;
  }
  return null;
}

List<OrderItemSummary> orderItemsForComposerEdit(OrderSummary order) {
  final items = order.sortedItems;
  if (items.isNotEmpty) return items;
  final legacy = order.legacyPerahanTunbanItemView();
  return legacy == null ? const <OrderItemSummary>[] : [legacy];
}

OrderItemCreateInput mergeComposerEditInput(
  OrderItemCreateInput draft,
  OrderItemSummary? existing,
) {
  if (existing != null) {
    return orderItemCreateInputFromSummary(
      existing,
      priceAmountMinor: draft.priceAmountMinor,
      measurementsSnapshot: draft.measurementsSnapshot,
      sourceMeasurementProfileId: draft.sourceMeasurementProfileId,
      sourceMeasurementProfileLabel: draft.sourceMeasurementProfileLabel,
      styleName: draft.styleName,
      styleNameInternalId: draft.styleNameInternalId,
      styleSelectionJson: draft.styleSelectionJson,
      styleSummary: draft.styleSummary,
      catalogItemInternalId: draft.catalogItemInternalId,
      catalogDesignNameSnapshot: draft.catalogDesignNameSnapshot,
      catalogDesignerShopNameSnapshot: draft.catalogDesignerShopNameSnapshot,
      fabricNameSnapshot: draft.fabricNameSnapshot,
      fabricColorSnapshot: draft.fabricColorSnapshot,
      fabricIdSnapshot: draft.fabricIdSnapshot,
      fabricNamePresetInternalId: draft.fabricNamePresetInternalId,
      fabricColorPresetInternalId: draft.fabricColorPresetInternalId,
      clothMetersSnapshot: draft.clothMetersSnapshot,
      clothPriceAmountMinor: draft.clothPriceAmountMinor,
      clothSourceIndex: draft.clothSourceIndex,
      clothStockSkuInternalId: draft.clothStockSkuInternalId,
      clothSaleCostAmountMinor: draft.clothSaleCostAmountMinor,
      measurementSnapshotItems: normalizedMeasurementSnapshotItems(
        draft.measurementSnapshotItems,
      ),
    );
  }
  return OrderItemCreateInput(
    garmentType: draft.garmentType,
    priceAmountMinor: draft.priceAmountMinor,
    sortOrder: draft.sortOrder,
    itemNotes: draft.itemNotes,
    measurementsSnapshot: draft.measurementsSnapshot,
    sourceMeasurementProfileId: draft.sourceMeasurementProfileId,
    sourceMeasurementProfileLabel: draft.sourceMeasurementProfileLabel,
    styleName: draft.styleName,
    styleNameInternalId: draft.styleNameInternalId,
    styleSelectionJson: draft.styleSelectionJson,
    styleSummary: draft.styleSummary,
    catalogItemInternalId: draft.catalogItemInternalId,
    catalogDesignNameSnapshot: draft.catalogDesignNameSnapshot,
    catalogDesignerShopNameSnapshot: draft.catalogDesignerShopNameSnapshot,
    catalogSourceImagePath: draft.catalogSourceImagePath,
    catalogSourceThumbnailPath: draft.catalogSourceThumbnailPath,
    fabricNameSnapshot: draft.fabricNameSnapshot,
    fabricColorSnapshot: draft.fabricColorSnapshot,
    fabricIdSnapshot: draft.fabricIdSnapshot,
    fabricNamePresetInternalId: draft.fabricNamePresetInternalId,
    fabricColorPresetInternalId: draft.fabricColorPresetInternalId,
    clothMetersSnapshot: draft.clothMetersSnapshot,
    clothPriceAmountMinor: draft.clothPriceAmountMinor,
    clothSourceIndex: draft.clothSourceIndex,
    clothStockSkuInternalId: draft.clothStockSkuInternalId,
    clothSaleCostAmountMinor: draft.clothSaleCostAmountMinor,
    measurementSnapshotItems: normalizedMeasurementSnapshotItems(
      draft.measurementSnapshotItems,
    ),
  );
}

Future<void> reconcileComposerClothStock({
  required WidgetRef ref,
  required String shopId,
  required String orderInternalId,
  required List<OrderItemCreateInput> inputs,
  required List<OrderItemSummary> previousItems,
}) async {
  final stockService = await ref.read(clothStockServiceProvider.future);
  final ordersRepo = await ref.read(orderListRepositoryProvider.future);
  final savedItems = await ordersRepo.watchOrderItems(orderInternalId).first;
  final previousByType = {for (final i in previousItems) i.garmentType: i};
  for (final input in inputs) {
    OrderItemSummary? saved;
    for (final item in savedItems) {
      if (item.garmentType == input.garmentType) {
        saved = item;
        break;
      }
    }
    if (saved == null) continue;
    final movements = await stockService.reconcileOrderItemStock(
      shopId: shopId,
      savedItem: saved,
      previousItem: previousByType[input.garmentType],
    );
    for (final m in movements) {
      enqueueClothMovementAppend(
        ref,
        internalId: m.internalId,
        skuInternalId: m.skuInternalId,
        movementTypeIndex: m.movementType.code,
        qtyMilliDelta: m.qtyMilliDelta,
        orderItemInternalId: m.orderItemInternalId,
        purchaseLineInternalId: m.purchaseLineInternalId,
        note: m.note,
      );
    }
  }
}

class OrderComposerScreen extends ConsumerStatefulWidget {
  const OrderComposerScreen({
    super.key,
    this.isTabRoot = false,
    this.initialCustomerId,
    this.initialReferenceOrderId,
    this.initialOrderId,
  });

  /// When true, composer is the Orders tab home (no back; reset after save).
  final bool isTabRoot;

  final String? initialCustomerId;

  /// In-memory reference override only; never persisted on the new order.
  final String? initialReferenceOrderId;

  /// Edit mode: load an existing order into the receipt form.
  final String? initialOrderId;

  @override
  ConsumerState<OrderComposerScreen> createState() => _OrderComposerScreenState();
}

const _kComposerSectionGap = 10.0;

class _OrderComposerScreenState extends ConsumerState<OrderComposerScreen> {
  var _customerPrefillApplied = false;
  var _orderEditPrefillApplied = false;

  /// Avoids re-applying the same reference order payload.
  String? _lastPrefilledReferenceId;

  /// When set, save updates this order instead of creating a new one.
  String? _editingOrderId;
  OrderLocalStatus? _editingStatus;

  /// In-memory only; not saved on the new order.
  String? _referenceOrderOverrideId;

  String? _selectedCustomerId;
  String? _selectedCustomerLabel;
  String? _selectedCustomerName;
  String? _selectedCustomerPhone;

  OrderComposerDraft _draft = OrderComposerDraft.initial();

  final Map<GarmentType, StyleOrderSelection> _styleSelections = {
    GarmentType.perahanTunban: const StyleOrderSelection.empty(),
    GarmentType.waistcoat: const StyleOrderSelection.empty(),
  };

  final Map<GarmentType, TextEditingController> _itemPriceControllers = {
    GarmentType.perahanTunban: TextEditingController(),
    GarmentType.waistcoat: TextEditingController(),
  };

  final Map<GarmentType, bool> _itemCardExpanded = {
    GarmentType.perahanTunban: true,
    GarmentType.waistcoat: false,
  };

  final Map<GarmentType, GlobalKey<OrderComposerMeasurementsPanelState>>
      _measurementPanelKeys = {
    GarmentType.perahanTunban: GlobalKey<OrderComposerMeasurementsPanelState>(),
    GarmentType.waistcoat: GlobalKey<OrderComposerMeasurementsPanelState>(),
  };

  final _paidController = TextEditingController();

  final _scrollController = ScrollController();
  final _customerSectionKey = GlobalKey();
  final _paymentSectionKey = GlobalKey();
  var _highlightCustomerError = false;
  var _highlightPaymentError = false;

  DateTime? _deliveryDate;

  final _formRevision = ValueNotifier<int>(0);

  Listenable get _paymentFieldsListenable => Listenable.merge([
        _paidController,
        ..._itemPriceControllers.values,
      ]);

  /// Rebuilds save affordances without rebuilding the full composer body.
  Listenable get _composerFormListenable => Listenable.merge([
        _paymentFieldsListenable,
        _formRevision,
      ]);

  void _notifyFormRevision() {
    _formRevision.value++;
  }

  @override
  void initState() {
    super.initState();
    _paidController.addListener(_onPaidFieldChanged);
    if (widget.initialCustomerId != null &&
        widget.initialCustomerId!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attemptCustomerPrefill();
      });
    }
    if (widget.initialOrderId != null &&
        widget.initialOrderId!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attemptOrderEditPrefill();
      });
    }
  }

  Future<void> _populateFromOrder(OrderSummary order) async {
    _editingOrderId = order.internalId;
    _editingStatus = order.status;
    _deliveryDate = order.deliveryDate;
    final customers =
        ref.read(customersListStreamProvider).valueOrNull ?? const [];
    CustomerSummary? customer;
    for (final c in customers) {
      if (c.internalId == order.customerInternalId) {
        customer = c;
        break;
      }
    }
    if (customer != null) {
      _selectedCustomerId = customer.internalId;
      _selectedCustomerName = customer.name;
      _selectedCustomerPhone = customer.phone;
      _selectedCustomerLabel = _customerSummaryLabel(customer);
    } else {
      _selectedCustomerId = order.customerInternalId;
      _selectedCustomerName = order.customerName;
      _selectedCustomerPhone = order.customerPhone;
      _selectedCustomerLabel = order.customerName;
    }
    _clearItemDrafts();
    final items = orderItemsForComposerEdit(order);
    final measurementItemsByGarment = <GarmentType, List<OrderMeasurementSnapshotItemInput>>{};
    for (final item in items) {
      final copy = await _loadMeasurementCopyForItem(order, item);
      if (copy != null && copy.items.isNotEmpty) {
        measurementItemsByGarment[item.garmentType] = copy.items;
      }
    }
    if (!mounted) return;
    for (final item in items) {
      final type = item.garmentType;
      _draft = _draft.toggleGarment(type, true);
      _styleSelections[type] =
          StyleOrderSelection.fromJsonString(item.styleSelectionJson);
      _itemPriceControllers[type]!.text =
          item.priceAmountMinor > 0 ? item.priceAmountMinor.toString() : '';
      _draft = _draft.updateItem(
        type,
        OrderItemDraft(
          garmentType: type,
          included: true,
          priceAmountMinor: item.priceAmountMinor,
          itemNotes: item.itemNotes,
          measurementsSnapshot: item.measurementsSnapshot,
          sourceMeasurementProfileId: item.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: item.sourceMeasurementProfileLabel,
          measurementSnapshotItems:
              measurementItemsByGarment[type] ?? const [],
          styleName: item.styleName,
          styleNameInternalId: item.styleNameInternalId,
          styleSelectionJson: item.styleSelectionJson,
          styleSummary: item.styleSummary,
          catalogItemInternalId: item.catalogItemInternalId,
          catalogDesignName: item.catalogDesignNameSnapshot,
          catalogDesignerShopName: item.catalogDesignerShopNameSnapshot,
          catalogImagePath: item.catalogImagePathSnapshot,
          catalogThumbnailPath: item.catalogThumbnailPathSnapshot,
          fabricName: item.fabricNameSnapshot,
          fabricColor: item.fabricColorSnapshot,
          fabricId: item.fabricIdSnapshot,
          fabricNamePresetInternalId: item.fabricNamePresetInternalId,
          fabricColorPresetInternalId: item.fabricColorPresetInternalId,
          clothMeters: item.clothMetersSnapshot,
          clothPriceAmountMinor: item.clothPriceAmountMinor,
          clothSourceIndex: item.clothSourceIndex,
          clothStockSkuInternalId: item.clothStockSkuInternalId,
          clothSaleCostAmountMinor: item.clothSaleCostAmountMinor,
        ),
      );
      _itemCardExpanded[type] = true;
    }
    final paid = order.paidAmountMinor;
    if (paid > 0) {
      _paidController.text = paid.toString();
    } else {
      _paidController.clear();
    }
  }

  Future<ReferenceMeasurementsCopy?> _loadMeasurementCopyForItem(
    OrderSummary order,
    OrderItemSummary item,
  ) async {
    if (item.internalId.trim().isNotEmpty) {
      final key = OrderItemSnapshotKey(
        orderInternalId: order.internalId,
        orderItemInternalId: item.internalId,
      );
      var snap = ref.read(orderItemMeasurementSnapshotProvider(key)).valueOrNull;
      snap ??= await ref.read(orderItemMeasurementSnapshotProvider(key).future);
      return buildItemMeasurementsCopy(item, snap);
    }
    if (item.garmentType == GarmentType.perahanTunban) {
      var snap = ref
          .read(orderMeasurementSnapshotProvider(order.internalId))
          .valueOrNull;
      snap ??= await ref.read(
        orderMeasurementSnapshotProvider(order.internalId).future,
      );
      return buildMeasurementsCopy(order, snap);
    }
    return null;
  }

  void _attemptOrderEditPrefill() {
    if (_orderEditPrefillApplied || !mounted) return;
    final orderId = widget.initialOrderId?.trim();
    if (orderId == null || orderId.isEmpty) {
      _orderEditPrefillApplied = true;
      return;
    }
    final asyncOrders = ref.read(ordersListStreamProvider);
    if (asyncOrders.isLoading) return;
    final order = _orderFromStream(orderId);
    _orderEditPrefillApplied = true;
    if (order != null) {
      unawaited(_populateFromOrder(order).then((_) {
        if (mounted) setState(() {});
      }));
    }
  }

  @override
  void didUpdateWidget(covariant OrderComposerScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final oldEditId = oldWidget.initialOrderId?.trim();
    final newEditId = widget.initialOrderId?.trim();
    if (oldEditId == newEditId) return;
    _orderEditPrefillApplied = false;
    if (newEditId == null || newEditId.isEmpty) {
      setState(_resetForm);
      return;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _attemptOrderEditPrefill();
    });
  }

  @override
  void dispose() {
    _paidController.removeListener(_onPaidFieldChanged);
    _scrollController.dispose();
    _paidController.dispose();
    _formRevision.dispose();
    for (final c in _itemPriceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _onPaidFieldChanged() {
    if (_highlightPaymentError && mounted) {
      setState(() => _highlightPaymentError = false);
    }
  }

  void _clearCustomerValidationHighlight() {
    if (_highlightCustomerError && mounted) {
      setState(() => _highlightCustomerError = false);
    }
  }

  String _saveValidationMessage(
    AppLocalizations l10n,
    OrderComposerSaveValidationIssue issue,
  ) {
    return switch (issue) {
      OrderComposerSaveValidationIssue.customerRequired =>
        l10n.ordersComposerSelectCustomerFirstBody,
      OrderComposerSaveValidationIssue.noItems => l10n.ordersComposerNoItemsError,
      OrderComposerSaveValidationIssue.garmentPriceRequired =>
        l10n.ordersComposerGarmentPriceRequired,
      OrderComposerSaveValidationIssue.totalRequired =>
        l10n.ordersComposerGarmentPriceRequired,
      OrderComposerSaveValidationIssue.initialPaymentRequired =>
        l10n.ordersComposerInitialPaymentRequired,
      OrderComposerSaveValidationIssue.paymentExceedsTotal =>
        l10n.ordersPaymentInitialExceedsTotal,
    };
  }

  void _scrollToValidationIssue(OrderComposerSaveValidationIssue issue) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final GlobalKey? sectionKey = switch (issue) {
        OrderComposerSaveValidationIssue.customerRequired => _customerSectionKey,
        OrderComposerSaveValidationIssue.initialPaymentRequired =>
          _paymentSectionKey,
        OrderComposerSaveValidationIssue.paymentExceedsTotal =>
          _paymentSectionKey,
        _ => null,
      };
      final target = sectionKey?.currentContext;
      if (target == null) return;
      Scrollable.ensureVisible(
        target,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        alignment: 0.08,
      );
    });
  }

  void _syncItemPricesFromControllers() {
    var draft = _draft;
    for (final type in GarmentType.values) {
      final minor = tryParseMoneyAmount(_itemPriceControllers[type]!.text) ?? 0;
      draft = draft.updateItemPrice(type, minor);
    }
    _draft = draft;
  }

  void _flushMeasurementsBeforeSave() {
    if (!ref.read(composerVisibilitySettingsProvider).showMeasurementsBlock) {
      return;
    }
    for (final type in _draft.selectedGarmentTypes) {
      final result = _measurementPanelKeys[type]?.currentState?.readCurrentResult();
      if (result == null) continue;
      _draft = _draft.updateItem(
        type,
        _itemDraft(type).copyWith(
          measurementsSnapshot: result.measurementsSnapshot,
          measurementSnapshotItems: result.measurementSnapshotItems,
          sourceMeasurementProfileId: result.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: result.sourceMeasurementProfileLabel,
        ),
      );
    }
  }

  int _composerTotalMinor(bool clothBlockEnabled) {
    _syncItemPricesFromControllers();
    return _draft.totalMinor(clothBlockEnabled: clothBlockEnabled);
  }

  int get _composerPaidMinor =>
      tryParseMoneyAmount(_paidController.text) ?? 0;

  /// Customer must be explicitly selected before save.
  bool get _hasCustomerForSave =>
      _selectedCustomerId != null && isValidCustomerName(_selectedCustomerName);

  OrderItemDraft _itemDraft(GarmentType type) => _draft.items[type]!;

  void _onGarmentChipSelected(GarmentType type, bool selected) {
    if (!selected &&
        _draft.selectedGarmentTypes.where((t) => t != type).isEmpty) {
      return;
    }
    setState(() {
      _draft = _draft.toggleGarment(type, selected);
      if (selected) {
        _itemCardExpanded[type] = true;
      }
    });
  }

  void _clearItemDrafts() {
    _draft = OrderComposerDraft.initial();
    _styleSelections[GarmentType.perahanTunban] =
        const StyleOrderSelection.empty();
    _styleSelections[GarmentType.waistcoat] = const StyleOrderSelection.empty();
    for (final type in GarmentType.values) {
      _itemPriceControllers[type]!.clear();
      _itemCardExpanded[type] = type == GarmentType.perahanTunban;
    }
  }

  String _customerSummaryLabel(CustomerSummary c) {
    final parts = <String>[c.name];
    if (parseStoredDisplayCustomerNo(c.displayCustomerNo) > 0) {
      parts.add(formatDisplayCustomerNo(c.displayCustomerNo));
    }
    final phone = c.phone?.trim();
    if (phone != null && phone.isNotEmpty) {
      parts.add(phone);
    }
    return parts.join(' • ');
  }

  void _applyCustomer(CustomerSummary c) {
    _clearCustomerValidationHighlight();
    setState(() {
      _referenceOrderOverrideId = null;
      _lastPrefilledReferenceId = null;
      _selectedCustomerId = c.internalId;
      _selectedCustomerName = c.name;
      _selectedCustomerPhone = c.phone;
      _selectedCustomerLabel = _customerSummaryLabel(c);
      _clearItemDrafts();
    });
    _notifyFormRevision();
    _scheduleReferencePrefill();
  }

  String _newCustomerResultLabel(NewCustomerForOrderResult c) {
    final parts = <String>[c.name];
    if (parseStoredDisplayCustomerNo(c.displayCustomerNo) > 0) {
      parts.add(formatDisplayCustomerNo(c.displayCustomerNo));
    }
    final phone = c.phone?.trim();
    if (phone != null && phone.isNotEmpty) {
      parts.add(phone);
    }
    return parts.join(' • ');
  }

  Future<void> _pickCustomerFromList(
    List<CustomerSummary> customers,
    AppLocalizations l10n,
  ) async {
    final picked = await showOrderComposerCustomerPicker(
      context: context,
      customers: customers,
      l10n: l10n,
      selectedId: _selectedCustomerId,
    );
    if (picked != null) _applyCustomer(picked);
  }

  Future<void> _openNewCustomerForOrder({String? name}) async {
    final trimmed = name?.trim();
    if (trimmed != null &&
        trimmed.isNotEmpty &&
        !isValidCustomerName(trimmed)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: AppLocalizations.of(context)!.customerNameTooShort,
      );
      return;
    }
    final result = await context.push<NewCustomerForOrderResult>(
      newCustomerRoute(
        returnTo: 'orderComposer',
        name: trimmed != null && trimmed.isNotEmpty ? trimmed : null,
      ),
    );
    if (!mounted || result == null) return;
    _clearCustomerValidationHighlight();
    setState(() {
      _referenceOrderOverrideId = null;
      _lastPrefilledReferenceId = null;
      _selectedCustomerId = result.internalId;
      _selectedCustomerName = result.name;
      _selectedCustomerPhone = result.phone;
      _selectedCustomerLabel = _newCustomerResultLabel(result);
      _clearItemDrafts();
    });
    _notifyFormRevision();
    _scheduleReferencePrefill();
  }

  Future<void> _scheduleReferencePrefill() async {
    if (_editingOrderId != null || _selectedCustomerId == null || !mounted) {
      return;
    }
    final editId = widget.initialOrderId?.trim();
    if (editId != null && editId.isNotEmpty && !_orderEditPrefillApplied) {
      return;
    }
    final asyncOrders = ref.read(ordersListStreamProvider);
    if (asyncOrders.isLoading) return;

    final customerId = _selectedCustomerId!;
    final allOrders = asyncOrders.valueOrNull ?? const [];
    final customerOrders = customerOrdersForReference(allOrders, customerId);
    if (customerOrders.isEmpty) return;

    String? refId = _referenceOrderOverrideId?.trim();
    if (refId == null || refId.isEmpty) {
      final navCustomer = widget.initialCustomerId?.trim();
      final navRef = widget.initialReferenceOrderId?.trim();
      if (navRef != null &&
          navRef.isNotEmpty &&
          navCustomer != null &&
          navCustomer == customerId) {
        refId = resolveInitialReferenceOrderId(
          allOrders: allOrders,
          customerId: customerId,
          referenceOrderId: navRef,
        );
      }
      refId ??= customerOrders.first.internalId;
    }

    final refOrder = resolveReferenceOrder(customerOrders, refId);
    if (refOrder == null) return;
    if (_lastPrefilledReferenceId == refOrder.internalId) return;

    await _prefillFromReferenceOrder(refOrder);
  }

  Future<void> _prefillFromReferenceOrder(OrderSummary refOrder) async {
    if (_editingOrderId != null || !mounted) return;
    if (_lastPrefilledReferenceId == refOrder.internalId) return;

    var myCatalog = ref.read(myCatalogStreamProvider).valueOrNull;
    if (myCatalog == null) {
      await ref.read(myCatalogStreamProvider.future);
      myCatalog = ref.read(myCatalogStreamProvider).valueOrNull ?? const [];
    }
    var sharedCatalog = ref.read(sharedCatalogStreamProvider).valueOrNull;
    if (sharedCatalog == null) {
      await ref.read(sharedCatalogStreamProvider.future);
      sharedCatalog =
          ref.read(sharedCatalogStreamProvider).valueOrNull ?? const [];
    }
    if (!mounted) return;

    bool catalogExists(String? id) =>
        catalogItemExistsInLists(id, myCatalog!, sharedCatalog!);

    final prefillData = buildReferencePrefillGarmentData(
      refOrder,
      catalogItemExists: catalogExists,
    );

    final enrichedDrafts = <GarmentType, OrderItemDraft>{};
    for (final type in GarmentType.values) {
      final data = prefillData[type]!;
      if (!data.included) continue;
      var draft = data.draft;
      final refItem = referenceOrderItem(refOrder, type);
      if (refItem != null && refItem.internalId.trim().isNotEmpty) {
        final key = OrderItemSnapshotKey(
          orderInternalId: refOrder.internalId,
          orderItemInternalId: refItem.internalId,
        );
        var snap =
            ref.read(orderItemMeasurementSnapshotProvider(key)).valueOrNull;
        snap ??=
            await ref.read(orderItemMeasurementSnapshotProvider(key).future);
        if (!mounted) return;
        final copy = buildItemMeasurementsCopy(refItem, snap);
        if (copy != null) {
          draft = applyMeasurementsCopyToDraft(draft, copy);
        }
      } else if (type == GarmentType.perahanTunban) {
        var snap = ref
            .read(orderMeasurementSnapshotProvider(refOrder.internalId))
            .valueOrNull;
        snap ??= await ref.read(
          orderMeasurementSnapshotProvider(refOrder.internalId).future,
        );
        if (!mounted) return;
        final copy = buildMeasurementsCopy(refOrder, snap);
        if (copy != null) {
          draft = applyMeasurementsCopyToDraft(draft, copy);
        }
      }
      enrichedDrafts[type] = draft;
    }

    if (!mounted) return;
    setState(() {
      _clearItemDrafts();
      for (final type in GarmentType.values) {
        if (!prefillData[type]!.included && _draft.items[type]!.included) {
          _draft = _draft.toggleGarment(type, false);
        }
      }
      for (final type in GarmentType.values) {
        if (prefillData[type]!.included && !_draft.items[type]!.included) {
          _draft = _draft.toggleGarment(type, true);
        }
      }
      for (final type in GarmentType.values) {
        final data = prefillData[type]!;
        if (!data.included) continue;
        _styleSelections[type] = data.styleSelection;
        final draft = enrichedDrafts[type] ?? data.draft;
        _itemPriceControllers[type]!.text =
            draft.priceAmountMinor > 0 ? draft.priceAmountMinor.toString() : '';
        _draft = _draft.updateItem(type, draft);
        _itemCardExpanded[type] = true;
      }
      _referenceOrderOverrideId = refOrder.internalId;
      _lastPrefilledReferenceId = refOrder.internalId;
    });
    _notifyFormRevision();
  }

  void _onReferenceOrderSelected(String id) {
    setState(() => _referenceOrderOverrideId = id);
    _lastPrefilledReferenceId = null;
    final refOrder = _orderFromStream(id);
    if (refOrder != null) {
      _prefillFromReferenceOrder(refOrder);
    }
  }

  void _attemptCustomerPrefill() {
    if (_customerPrefillApplied || !mounted) return;

    final asyncCustomers = ref.read(customersListStreamProvider);
    if (asyncCustomers.isLoading) return;

    final match = resolveComposerPrefillCustomer(
      asyncCustomers.valueOrNull ?? const [],
      widget.initialCustomerId,
    );

    if (match != null) {
      _customerPrefillApplied = true;
      _applyCustomer(match);
      return;
    }

    if (asyncCustomers.hasValue) {
      _customerPrefillApplied = true;
      final l10n = AppLocalizations.of(context)!;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.info,
        message: l10n.customerNotFound,
      );
    }
  }

  void _clearSelectedCustomer() {
    setState(() {
      _referenceOrderOverrideId = null;
      _lastPrefilledReferenceId = null;
      _selectedCustomerId = null;
      _selectedCustomerLabel = null;
      _selectedCustomerName = null;
      _selectedCustomerPhone = null;
      _clearItemDrafts();
    });
    _notifyFormRevision();
  }

  void _copyFabricFromPerahanToWaistcoat() {
    final perahan = _itemDraft(GarmentType.perahanTunban);
    final waistcoat = _itemDraft(GarmentType.waistcoat);
    setState(() {
      _draft = _draft.updateItem(
        GarmentType.waistcoat,
        waistcoat.copyWith(
          fabricName: perahan.fabricName,
          fabricColor: perahan.fabricColor,
          fabricId: perahan.fabricId,
          fabricNamePresetInternalId: perahan.fabricNamePresetInternalId,
          fabricColorPresetInternalId: perahan.fabricColorPresetInternalId,
          clothMeters: perahan.clothMeters,
          clothPriceAmountMinor: perahan.clothPriceAmountMinor,
        ),
      );
    });
  }

  Future<void> _applyPreviousMeasurements(
    OrderSummary refOrder,
    GarmentType type,
  ) async {
    if (!_draft.showPreviousReferenceForGarment(type)) return;
    final refItem = referenceOrderItem(refOrder, type);
    OrderMeasurementSnapshotView? snap;
    if (refItem != null && refItem.internalId.trim().isNotEmpty) {
      final key = OrderItemSnapshotKey(
        orderInternalId: refOrder.internalId,
        orderItemInternalId: refItem.internalId,
      );
      snap = ref.read(orderItemMeasurementSnapshotProvider(key)).valueOrNull;
      snap ??= await ref.read(orderItemMeasurementSnapshotProvider(key).future);
    } else {
      snap = ref
          .read(orderMeasurementSnapshotProvider(refOrder.internalId))
          .valueOrNull;
      snap ??= await ref.read(
        orderMeasurementSnapshotProvider(refOrder.internalId).future,
      );
    }
    if (!mounted) return;
    final copy = refItem != null
        ? buildItemMeasurementsCopy(refItem, snap)
        : buildMeasurementsCopy(refOrder, snap);
    if (copy == null || copy.snapshotText.trim().isEmpty) {
      final l10n = AppLocalizations.of(context)!;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.info,
        message: l10n.ordersComposerPreviousMeasurementsUnavailable,
      );
      return;
    }
    final draft = _itemDraft(type);
    setState(() {
      _draft = _draft.updateItem(
        type,
        draft.copyWith(
          measurementsSnapshot: copy.snapshotText,
          measurementSnapshotItems:
              List<OrderMeasurementSnapshotItemInput>.of(copy.items),
          sourceMeasurementProfileId: null,
          sourceMeasurementProfileLabel: '',
        ),
      );
    });
  }

  void _applyPreviousStyle(OrderSummary refOrder, GarmentType type) {
    if (!_draft.showPreviousReferenceForGarment(type)) return;
    final refItem = referenceOrderItem(refOrder, type);
    final copy = refItem != null
        ? buildItemStyleCopy(refItem)
        : buildStyleCopy(refOrder);
    if (copy == null) return;
    final draft = _itemDraft(type);
    setState(() {
      _styleSelections[type] = copy.selection;
      _draft = _draft.updateItem(
        type,
        draft.copyWith(
          styleName: copy.styleName,
          styleNameInternalId: copy.styleNameInternalId,
          styleSummary: copy.styleSummary,
        ),
      );
    });
  }

  Future<void> _applyPreviousDesign(OrderSummary refOrder) async {
    const type = GarmentType.perahanTunban;
    if (!_draft.showPreviousReferenceForGarment(type)) return;
    final refItem = referenceOrderItem(refOrder, type);
    var myCatalog = ref.read(myCatalogStreamProvider).valueOrNull;
    if (myCatalog == null) {
      await ref.read(myCatalogStreamProvider.future);
      myCatalog = ref.read(myCatalogStreamProvider).valueOrNull ?? const [];
    }
    var sharedCatalog = ref.read(sharedCatalogStreamProvider).valueOrNull;
    if (sharedCatalog == null) {
      await ref.read(sharedCatalogStreamProvider.future);
      sharedCatalog =
          ref.read(sharedCatalogStreamProvider).valueOrNull ?? const [];
    }
    if (!mounted) return;
    final exists = catalogItemExistsInLists(
      refOrder.catalogItemInternalId,
      myCatalog,
      sharedCatalog,
    );
    final copy = refItem != null
        ? (buildItemDesignCopy(refItem, catalogItemExists: exists) ??
            buildItemDesignCopy(refItem, catalogItemExists: false))
        : (buildDesignCopy(refOrder, catalogItemExists: exists) ??
            buildDesignCopySnapshotOnly(refOrder));
    if (copy == null) return;
    final draft = _itemDraft(type);
    setState(() {
      _draft = _draft.updateItem(
        type,
        draft.copyWith(
          catalogItemInternalId: copy.catalogItemInternalId,
          catalogDesignName: copy.catalogDesignName,
          catalogDesignerShopName: copy.catalogDesignerShopName,
          catalogImagePath: copy.catalogImagePath,
          catalogThumbnailPath: copy.catalogThumbnailPath,
        ),
      );
    });
  }

  void _applyPreviousFabric(OrderSummary refOrder, GarmentType type) {
    if (!_draft.showPreviousReferenceForGarment(type)) return;
    final refItem = referenceOrderItem(refOrder, type);
    final copy = refItem != null
        ? buildItemFabricCopy(refItem)
        : buildFabricCopy(refOrder);
    if (copy == null) return;
    final draft = _itemDraft(type);
    setState(() {
      _draft = _draft.updateItem(
        type,
        draft.copyWith(
          fabricName: copy.fabricName,
          fabricColor: copy.fabricColor,
          fabricId: '',
          fabricNamePresetInternalId: copy.fabricNamePresetInternalId,
          fabricColorPresetInternalId: copy.fabricColorPresetInternalId,
          clothMeters: copy.clothMeters,
          clothPriceAmountMinor: copy.clothPriceAmountMinor,
        ),
      );
    });
  }

  OrderSummary? _orderFromStream(String orderId) {
    final orders = ref.read(ordersListStreamProvider).valueOrNull;
    if (orders == null) return null;
    for (final o in orders) {
      if (o.internalId == orderId) return o;
    }
    return null;
  }

  Future<OrderSummary?> _waitOrderSummary(String orderId) async {
    for (var i = 0; i < 20; i++) {
      final o = _orderFromStream(orderId);
      if (o != null) return o;
      await Future<void>.delayed(const Duration(milliseconds: 24));
    }
    return _orderFromStream(orderId);
  }

  Future<void> _showPostSaveSheet(
    BuildContext context,
    AppLocalizations l10n,
    String orderId,
  ) async {
    final calendar = ref.read(dateCalendarSystemProvider);
    final locale = Localizations.localeOf(context).toString();

    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(l10n.ordersComposerSaved),
                subtitle: Text(l10n.ordersComposerPostSaveSubtitle),
              ),
              const Divider(height: 1),
              ListTile(
                leading: const Icon(Icons.print_outlined),
                title: Text(l10n.orderPrintReceiptTooltip),
                onTap: () async {
                  final o = await _waitOrderSummary(orderId);
                  if (!ctx.mounted || o == null) return;
                  final payments =
                      ref.read(paymentsForOrderProvider(o.internalId)).valueOrNull ??
                          const <PaymentSummary>[];
                  await printThermalOrderReceipt(
                    context: ctx,
                    ref: ref,
                    l10n: l10n,
                    order: o,
                    payments: payments,
                    deliveryDateText: AppCalendarFormat.mediumDate(
                      l10n,
                      calendar,
                      o.deliveryDate,
                      locale,
                    ),
                    statusText: orderStatusLabel(o.status, l10n),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.visibility_outlined),
                title: Text(l10n.orderViewInvoicePdfCta),
                subtitle: Text(l10n.orderViewInvoicePdfTooltip),
                onTap: () async {
                  Navigator.pop(ctx);
                  final o = await _waitOrderSummary(orderId);
                  if (!context.mounted || o == null) return;
                  final payments =
                      ref.read(paymentsForOrderProvider(o.internalId)).valueOrNull ??
                          const <PaymentSummary>[];
                  await viewOrderInvoicePdf(
                    context: context,
                    ref: ref,
                    l10n: l10n,
                    order: o,
                    payments: payments,
                    deliveryDateText: AppCalendarFormat.mediumDate(
                      l10n,
                      calendar,
                      o.deliveryDate,
                      locale,
                    ),
                    statusText: orderStatusLabel(o.status, l10n),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.picture_as_pdf_outlined),
                title: Text(l10n.orderShareInvoicePdfCta),
                subtitle: Text(l10n.orderShareInvoiceTooltip),
                onTap: () async {
                  Navigator.pop(ctx);
                  final o = await _waitOrderSummary(orderId);
                  if (!context.mounted || o == null) return;
                  final payments =
                      ref.read(paymentsForOrderProvider(o.internalId)).valueOrNull ??
                          const <PaymentSummary>[];
                  await shareOrderInvoice(
                    context: context,
                    ref: ref,
                    l10n: l10n,
                    order: o,
                    payments: payments,
                    deliveryDateText: AppCalendarFormat.mediumDate(
                      l10n,
                      calendar,
                      o.deliveryDate,
                      locale,
                    ),
                    statusText: orderStatusLabel(o.status, l10n),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.open_in_new),
                title: Text(l10n.ordersDetailTitle),
                onTap: () {
                  Navigator.pop(ctx);
                  if (context.mounted) {
                    context.go('/app/orders/$orderId');
                  }
                },
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                child: SizedBox(
                  width: double.infinity,
                  child: FilledButton(
                    onPressed: () => Navigator.pop(ctx),
                    child: Text(MaterialLocalizations.of(ctx).okButtonLabel),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<String?> _resolveCustomerForSave(AppLocalizations l10n) async {
    if (_selectedCustomerId == null ||
        !isValidCustomerName(_selectedCustomerName)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersComposerSelectCustomerFirstBody,
      );
      return null;
    }
    return _selectedCustomerId;
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
    final license = ref.read(licenseNotifierProvider);
    if (ref.read(licenseEditingBlockedProvider)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: licenseWriteBlockedMessage(license, l10n),
      );
      return;
    }

    final customerId = await _resolveCustomerForSave(l10n);
    if (customerId == null || !context.mounted) return;

    if (!_draft.hasAtLeastOneItem) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersComposerNoItemsError,
      );
      return;
    }

    _syncItemPricesFromControllers();
    _flushMeasurementsBeforeSave();
    final clothBlockEnabled =
        ref.read(composerVisibilitySettingsProvider).showClothBlock;
    final totalMinor = _draft.totalMinor(clothBlockEnabled: clothBlockEnabled);
    var paidMinor = _composerPaidMinor;
    if (paidMinor < 0) paidMinor = 0;
    if (totalMinor <= 0) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersComposerItemPriceRequired,
      );
      return;
    }
    if (paidMinor > totalMinor) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersPaymentInitialExceedsTotal,
      );
      return;
    }
    final now = DateTime.now();
    final deliveryDate = _deliveryDate ??
        DateTime(now.year, now.month, now.day);
    final createInputs = _draft.toCreateInputs(
      styleSelections: _styleSelections,
      includeClothFields: clothBlockEnabled,
    );

    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);

    final ordersRepo = await ref.read(orderListRepositoryProvider.future);
    final paymentsRepo = await ref.read(paymentRepositoryProvider.future);

    if (_editingOrderId != null) {
      final orderId = _editingOrderId!;
      try {
        final currentOrder = _orderFromStream(orderId);
        final existingItems = currentOrder == null
            ? const <OrderItemSummary>[]
            : orderItemsForComposerEdit(currentOrder);
        final existingByType = {
          for (final item in existingItems) item.garmentType: item,
        };
        for (final input in createInputs) {
          final existing = existingByType[input.garmentType];
          final merged = mergeComposerEditInput(input, existing);
          await ordersRepo.upsertOrderItem(
            orderInternalId: orderId,
            input: merged,
          );
        }
        final selectedTypes =
            createInputs.map((input) => input.garmentType).toSet();
        for (final item in existingItems) {
          if (!selectedTypes.contains(item.garmentType)) {
            await ordersRepo.removeOrderItem(
              orderInternalId: orderId,
              garmentType: item.garmentType,
            );
          }
        }
        await ordersRepo.updateOrderDetails(
          orderInternalId: orderId,
          customerInternalId: customerId,
          customerSnapshotName: _selectedCustomerName,
          customerSnapshotPhone: _selectedCustomerPhone,
          deliveryDate: deliveryDate,
          totalAmountMinor: totalMinor > 0 ? totalMinor : null,
        );
        if (_editingStatus != null) {
          await ordersRepo.updateOrderStatus(
            orderInternalId: orderId,
            newStatus: _editingStatus!,
          );
        }
        await reconcileComposerClothStock(
          ref: ref,
          shopId: shopId,
          orderInternalId: orderId,
          inputs: createInputs,
          previousItems: existingItems,
        );
      } on OrderItemRepositoryException catch (e) {
        if (!context.mounted) return;
        showAppFeedback(
          context,
          ref,
          kind: AppFeedbackKind.error,
          message: _orderItemRepositoryErrorMessage(l10n, e),
        );
        return;
      }
      if (!context.mounted) return;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.success,
        message: l10n.ordersComposerSaved,
      );
      if (widget.isTabRoot) {
        await _showPostSaveSheet(context, l10n, orderId);
        if (!context.mounted) return;
        setState(_resetForm);
      } else {
        context.go('/app/orders/$orderId');
      }
      return;
    }

    final orderId = await ordersRepo.createOrderWithItems(
      shopId: shopId,
      customerInternalId: customerId,
      deliveryDate: deliveryDate,
      items: createInputs,
      customerSnapshotName: _selectedCustomerName,
      customerSnapshotPhone: _selectedCustomerPhone,
    );

    await reconcileComposerClothStock(
      ref: ref,
      shopId: shopId,
      orderInternalId: orderId,
      inputs: createInputs,
      previousItems: const [],
    );

    final catalogItem = _draft.primaryCatalogItem();
    if (catalogItem != null && catalogItem.catalogDesignName.trim().isNotEmpty) {
      final customersRepo =
          await ref.read(customerListRepositoryProvider.future);
      await customersRepo.updateCustomerLastCatalogDesign(
        internalId: customerId,
        designName: catalogItem.catalogDesignName.trim(),
        designerShopName: catalogItem.catalogDesignerShopName.trim(),
        catalogItemInternalId: catalogItem.catalogItemInternalId,
        thumbnailPath: catalogItem.catalogThumbnailPath,
      );
      final customers =
          ref.read(customersListStreamProvider).valueOrNull ?? [];
      CustomerSummary? customerRow;
      for (final c in customers) {
        if (c.internalId == customerId) {
          customerRow = c;
          break;
        }
      }
      if (customerRow != null) {
        recordSyncOutboxMutation(
          ref,
          kind: SyncOutboxKinds.customerUpsert,
          entityRef: customerId,
          shopId: shopId,
          payloadJson: jsonEncode({
            'name': customerRow.name,
            ...customerUpsertPayloadExtras(
              displayCustomerNo: customerRow.displayCustomerNo,
            ),
            if (customerRow.phone != null && customerRow.phone!.trim().isNotEmpty)
              'phone': customerRow.phone!.trim(),
            if (customerRow.address != null &&
                customerRow.address!.trim().isNotEmpty)
              'address': customerRow.address!.trim(),
            if (customerRow.notes != null && customerRow.notes!.trim().isNotEmpty)
              'notes': customerRow.notes!.trim(),
            'created_at': customerRow.createdAt.toUtc().toIso8601String(),
            'last_catalog_design_name': catalogItem.catalogDesignName.trim(),
            if (catalogItem.catalogDesignerShopName.trim().isNotEmpty)
              'last_catalog_designer_shop_name':
                  catalogItem.catalogDesignerShopName.trim(),
            if (catalogItem.catalogItemInternalId != null)
              'last_catalog_item_internal_id': catalogItem.catalogItemInternalId,
            if (catalogItem.catalogThumbnailPath != null &&
                catalogItem.catalogThumbnailPath!.trim().isNotEmpty)
              'last_catalog_thumbnail_path':
                  catalogItem.catalogThumbnailPath!.trim(),
          }),
        );
      }
    }

    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.orderCreate,
      entityRef: orderId,
      shopId: shopId,
      payloadJson: jsonEncode(
        buildNewOrderCreateSyncPayload(
          customerInternalId: customerId,
          deliveryDate: deliveryDate,
          totalAmountMinor: totalMinor,
          initialPaidMinor: paidMinor,
          items: createInputs,
          customerSnapshotName: _selectedCustomerName,
          customerSnapshotPhone: _selectedCustomerPhone,
        ),
      ),
    );

    if (paidMinor > 0) {
      final paymentId = await OrderPaymentMutations.persistAppend(
        repo: paymentsRepo,
        shopId: shopId,
        orderInternalId: orderId,
        amountMinor: paidMinor,
      );
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.paymentAppend,
        entityRef: paymentId,
        shopId: shopId,
        payloadJson: OrderPaymentMutations.appendPayloadJson(
          orderInternalId: orderId,
          amountMinor: paidMinor,
        ),
      );
    }

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.ordersComposerSaved,
    );
    if (widget.isTabRoot) {
      await _showPostSaveSheet(context, l10n, orderId);
      if (!context.mounted) return;
      setState(_resetForm);
      return;
    }
    await _showPostSaveSheet(context, l10n, orderId);
    if (context.mounted) {
      context.go('/app/orders/$orderId?fromNew=1');
    }
  }

  String _money(AppLocalizations l10n, int minor) {
    return AppNumberFormat.formatMoney(l10n, minor);
  }

  String _orderItemRepositoryErrorMessage(
    AppLocalizations l10n,
    OrderItemRepositoryException error,
  ) {
    return switch (error.code) {
      'item_price_required' => l10n.ordersComposerItemPriceRequired,
      'order_total_below_paid' => l10n.ordersPaymentTotalBelowPaid,
      'cannot_remove_last_item' => l10n.ordersComposerNoItemsError,
      _ => l10n.genericError,
    };
  }

  void _onSavePressed(BuildContext context, AppLocalizations l10n) {
    final clothBlockEnabled =
        ref.read(composerVisibilitySettingsProvider).showClothBlock;
    _syncItemPricesFromControllers();

    var paidMinor = _composerPaidMinor;
    if (paidMinor < 0) paidMinor = 0;

    final issue = firstOrderComposerSaveValidationIssue(
      draft: _draft,
      customerSelected: _hasCustomerForSave,
      paidMinor: paidMinor,
      clothBlockEnabled: clothBlockEnabled,
      requireInitialPayment: _editingOrderId == null,
    );
    if (issue != null) {
      setState(() {
        _highlightCustomerError =
            issue == OrderComposerSaveValidationIssue.customerRequired;
        _highlightPaymentError =
            issue == OrderComposerSaveValidationIssue.initialPaymentRequired ||
            issue == OrderComposerSaveValidationIssue.paymentExceedsTotal;
      });
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: _saveValidationMessage(l10n, issue),
      );
      _scrollToValidationIssue(issue);
      return;
    }

    setState(() {
      _highlightCustomerError = false;
      _highlightPaymentError = false;
    });
    _save(context, l10n);
  }

  void _resetForm({bool confirm = true}) {
    _referenceOrderOverrideId = null;
    _lastPrefilledReferenceId = null;
    _editingOrderId = null;
    _editingStatus = null;
    _orderEditPrefillApplied = false;
    _selectedCustomerId = null;
    _selectedCustomerLabel = null;
    _selectedCustomerName = null;
    _selectedCustomerPhone = null;
    _paidController.clear();
    _deliveryDate = null;
    _clearItemDrafts();
  }

  ({
    List<Widget> meta,
    List<Widget> garments,
    List<Widget> footer,
  }) _composerLayoutSections({
    required AppLocalizations l10n,
    required String locale,
    required DateCalendarSystem calendar,
    required List<OrderSummary> ordersForRef,
    required List<CustomerSummary> customersForSearch,
    required OrderSummary? referenceOrder,
    required List<MeasurementProfileSummary> measurementProfiles,
    required String deliveryLabel,
    required Map<String, int> referencePaidByOrderId,
    required bool paymentsLedgerLoaded,
    required bool clothBlockEnabled,
  }) {
    final meta = <Widget>[
      KeyedSubtree(
        key: _customerSectionKey,
        child: _ComposerCustomerSearchSection(
          l10n: l10n,
          selectedCustomerId: _selectedCustomerId,
          selectedCustomerLabel: _selectedCustomerLabel,
          showError: _highlightCustomerError,
          onClearCustomer: _clearSelectedCustomer,
          onSearchCustomer: () =>
              _pickCustomerFromList(customersForSearch, l10n),
          onAddCustomer: () => _openNewCustomerForOrder(),
        ),
      ),
      if (_selectedCustomerId != null) ...[
        Builder(
          builder: (context) {
            final customerOrders = customerOrdersForReference(
              ordersForRef,
              _selectedCustomerId!,
            ).where((o) => o.internalId != _editingOrderId).toList();
            if (customerOrders.length <= 1) {
              return const SizedBox.shrink();
            }
            return Align(
              alignment: AlignmentDirectional.centerStart,
              child: TextButton.icon(
                onPressed: () => showComposerReferenceOrderPicker(
                  context,
                  l10n,
                  calendar,
                  locale,
                  customerOrders,
                  referenceOrder?.internalId ??
                      customerOrders.first.internalId,
                  _onReferenceOrderSelected,
                  _money,
                  referencePaidByOrderId,
                  paymentsLedgerLoaded,
                ),
                icon: const Icon(Icons.swap_horiz, size: 18),
                label: Text(l10n.ordersComposerChangeReferenceOrderCta),
              ),
            );
          },
        ),
      ],
      if (_editingOrderId != null && _editingStatus != null) ...[
        const SizedBox(height: _kComposerSectionGap),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 4),
          child: DropdownButtonFormField<OrderLocalStatus>(
            value: _editingStatus,
            decoration: InputDecoration(
              labelText: l10n.ordersAuditStatus,
              border: const OutlineInputBorder(),
              isDense: true,
            ),
            items: [
              for (final s in OrderLocalStatus.values)
                DropdownMenuItem(
                  value: s,
                  child: Text(orderStatusLabel(s, l10n)),
                ),
            ],
            onChanged: (v) {
              if (v == null) return;
              setState(() => _editingStatus = v);
            },
          ),
        ),
      ],
      const SizedBox(height: _kComposerSectionGap),
      Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final type in GarmentType.values)
            FilterChip(
              avatar: ComposerGarmentIcon(type: type, size: 18),
              label: Text(composerGarmentLabel(l10n, type)),
              selected: _draft.items[type]!.included,
              onSelected: (v) => _onGarmentChipSelected(type, v),
            ),
        ],
      ),
    ];

    final garments = <Widget>[
      for (final type in _draft.selectedGarmentTypes)
        Builder(
          builder: (context) {
            final itemDraft = _itemDraft(type);
            final refItem = referenceOrder != null
                ? referenceOrderItem(referenceOrder, type)
                : null;
            return OrderComposerReceiptGarmentBlock(
              l10n: l10n,
              garmentType: type,
              draft: itemDraft,
              styleSelection: _styleSelections[type] ??
                  const StyleOrderSelection.empty(),
              measurementsPanelKey: _measurementPanelKeys[type],
              customerId: _selectedCustomerId,
              measurementProfiles: measurementProfiles,
              referenceOrder: referenceOrder,
              referenceItem: refItem,
              moneyFormatter: _money,
              onDraftUpdate: (update) {
                _draft = _draft.updateItem(type, update(_itemDraft(type)));
                _notifyFormRevision();
              },
              onStyleSelectionChanged: (selection) {
                _styleSelections[type] = selection;
                _notifyFormRevision();
              },
              onUsePreviousMeasurements: referenceOrder != null
                  ? () => _applyPreviousMeasurements(
                        referenceOrder,
                        type,
                      )
                  : null,
              onUsePreviousStyle: referenceOrder != null
                  ? () => _applyPreviousStyle(referenceOrder, type)
                  : null,
              onUsePreviousDesign: referenceOrder != null &&
                      type == GarmentType.perahanTunban
                  ? () => _applyPreviousDesign(referenceOrder)
                  : null,
              onUsePreviousFabric: referenceOrder != null
                  ? () => _applyPreviousFabric(referenceOrder, type)
                  : null,
              onUseSameFabric: type == GarmentType.waistcoat &&
                      _draft.items[GarmentType.perahanTunban]!.included &&
                      _draft.items[GarmentType.perahanTunban]!.hasFabric
                  ? _copyFabricFromPerahanToWaistcoat
                  : null,
            );
          },
        ),
    ];

    final footer = <Widget>[
      const SizedBox(height: _kComposerSectionGap),
      PrideOptionalPanel(
        isEmpty: _deliveryDate == null,
        padding: EdgeInsets.zero,
        child: OutlinedButton.icon(
          onPressed: () async {
            final now = DateTime.now();
            final date = await showAppDatePicker(
              context: context,
              l10n: l10n,
              system: calendar,
              initialDate: _deliveryDate ??
                  now.add(const Duration(days: 2)),
              firstDate: DateTime(now.year - 1),
              lastDate: DateTime(now.year + 3),
            );
            if (date == null || !mounted) return;
            setState(
              () => _deliveryDate = DateTime(
                date.year,
                date.month,
                date.day,
              ),
            );
          },
          icon: const Icon(Icons.event_outlined),
          label: Text(deliveryLabel),
        ),
      ),
      const SizedBox(height: _kComposerSectionGap),
      KeyedSubtree(
        key: _paymentSectionKey,
        child: ListenableBuilder(
          listenable: _paymentFieldsListenable,
          builder: (context, _) {
            final total = _composerTotalMinor(clothBlockEnabled);
            final paid = _composerPaidMinor;
            final remaining = OrderPaymentRules.remainingMinor(total, paid);
            final clothLines =
                _draft.clothPaymentLines(clothBlockEnabled: clothBlockEnabled);
            final scheme = Theme.of(context).colorScheme;
            final paymentBorder = _highlightPaymentError
                ? Border.all(color: scheme.error, width: 1.5)
                : null;
            return DecoratedBox(
              decoration: BoxDecoration(
                border: paymentBorder,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Padding(
                padding: paymentBorder == null
                    ? EdgeInsets.zero
                    : const EdgeInsets.all(8),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    for (final type in _draft.selectedGarmentTypes) ...[
                      PrideMoneyField(
                        controller: _itemPriceControllers[type]!,
                        labelText: l10n.ordersComposerGarmentPriceLabel(
                          composerGarmentLabel(l10n, type),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    for (final line in clothLines) ...[
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        dense: true,
                        title: Text(
                          l10n.ordersComposerClothPriceLineLabel(
                            composerGarmentLabel(l10n, line.type),
                          ),
                        ),
                        trailing: Text(
                          _money(l10n, line.amountMinor),
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                      ),
                    ],
                    if (clothLines.isNotEmpty) const SizedBox(height: 4),
                    Text(
                      '${l10n.paymentTotal}: ${_money(l10n, total)}',
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    PrideMoneyField(
                      controller: _paidController,
                      labelText: l10n.ordersComposerPaidLabel,
                    ),
                    if (total > 0 && remaining > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Text(
                          '${l10n.ordersComposerStillOwedLabel}: ${_money(l10n, remaining)}',
                          style: Theme.of(context).textTheme.bodyMedium,
                        ),
                      ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
      const SizedBox(height: _kComposerSectionGap),
      if (_selectedCustomerId != null && !widget.isTabRoot)
        _ComposerRecentOrdersCard(
          customerId: _selectedCustomerId!,
          l10n: l10n,
          money: _money,
        ),
    ];

    return (meta: meta, garments: garments, footer: footer);
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(customersListStreamProvider, (previous, next) {
      if (!_customerPrefillApplied &&
          widget.initialCustomerId != null &&
          next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _attemptCustomerPrefill();
        });
      }
    });
    ref.listen(ordersListStreamProvider, (previous, next) {
      if (_selectedCustomerId != null &&
          _lastPrefilledReferenceId == null &&
          _editingOrderId == null &&
          next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _scheduleReferencePrefill();
        });
      }
      if (!_orderEditPrefillApplied &&
          widget.initialOrderId != null &&
          next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _attemptOrderEditPrefill();
        });
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final deliveryLabel = _deliveryDate == null
        ? l10n.ordersComposerDeliveryDateUnset
        : AppCalendarFormat.mediumDate(l10n, calendar, _deliveryDate!, locale);

    // Select value only — avoids full composer rebuild on AsyncLoading transitions.
    final ordersForRef = ref.watch(
          ordersListStreamProvider.select((async) => async.valueOrNull),
        ) ??
        const <OrderSummary>[];
    final customersForSearch = ref.watch(
          customersListStreamProvider.select((async) => async.valueOrNull),
        ) ??
        const <CustomerSummary>[];
    final referenceOrdersForCustomer = _selectedCustomerId == null
        ? const <OrderSummary>[]
        : customerOrdersForReference(ordersForRef, _selectedCustomerId!)
            .where((o) => o.internalId != _editingOrderId)
            .toList();
    final referenceOrder = referenceOrdersForCustomer.isEmpty
        ? null
        : resolveReferenceOrder(
            referenceOrdersForCustomer,
            _referenceOrderOverrideId,
          );
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncShopPayments = ref.watch(paymentsForShopProvider(shopId));
    final referencePaidByOrderId = asyncShopPayments.hasValue
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
    final clothBlockEnabled =
        ref.watch(composerVisibilitySettingsProvider).showClothBlock;
    final measurementProfiles = _selectedCustomerId == null
        ? const <MeasurementProfileSummary>[]
        : ref
                .watch(
                  measurementProfilesForCustomerProvider(_selectedCustomerId!),
                )
                .valueOrNull ??
            const <MeasurementProfileSummary>[];
    final sections = _composerLayoutSections(
      l10n: l10n,
      locale: locale,
      calendar: calendar,
      ordersForRef: ordersForRef,
      customersForSearch: customersForSearch,
      referenceOrder: referenceOrder,
      measurementProfiles: measurementProfiles,
      deliveryLabel: deliveryLabel,
      referencePaidByOrderId: referencePaidByOrderId,
      paymentsLedgerLoaded: paymentsLedgerLoaded,
      clothBlockEnabled: clothBlockEnabled,
    );
    final scaffold = Scaffold(
      appBar: AppBar(
        leading: widget.isTabRoot
            ? null
            : BackButton(onPressed: () => context.pop()),
        automaticallyImplyLeading: !widget.isTabRoot,
        title: Text(
          _editingOrderId != null ? l10n.ordersEditTitle : l10n.ordersNewTitle,
        ),
      ),
      body: ListView(
        controller: _scrollController,
        padding: prideComposerScrollPadding(context),
        children: [
          ...sections.meta,
          ...sections.garments,
          ...sections.footer,
        ],
      ),
      bottomNavigationBar: ListenableBuilder(
        listenable: _composerFormListenable,
        builder: (context, _) {
          return PrideFormBottomBar(
            onCancel: widget.isTabRoot
                ? null
                : () => context.pop(),
            cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
            primary: FilledButton.icon(
              onPressed: () => _onSavePressed(context, l10n),
              style: prideButtonStyle(context, PrideButtonVariant.add),
              icon: const Icon(Icons.check),
              label: Text(l10n.ordersComposerSaveCta),
            ),
          );
        },
      ),
    );

    return scaffold;
  }
}

/// Customer pick/create: search icon opens picker sheet; add icon opens new customer.
class _ComposerCustomerSearchSection extends StatelessWidget {
  const _ComposerCustomerSearchSection({
    required this.l10n,
    required this.selectedCustomerId,
    required this.selectedCustomerLabel,
    required this.showError,
    required this.onClearCustomer,
    required this.onSearchCustomer,
    required this.onAddCustomer,
  });

  final AppLocalizations l10n;
  final String? selectedCustomerId;
  final String? selectedCustomerLabel;
  final bool showError;
  final VoidCallback onClearCustomer;
  final VoidCallback onSearchCustomer;
  final VoidCallback onAddCustomer;

  @override
  Widget build(BuildContext context) {
    if (selectedCustomerId != null) {
      final label = selectedCustomerLabel ?? '';
      return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: const Icon(Icons.person_outline),
        title: Text(label),
        trailing: PrideCloseIconButton(
          tooltip: l10n.editCta,
          onPressed: onClearCustomer,
        ),
      );
    }

    final scheme = Theme.of(context).colorScheme;
    final labelColor =
        showError ? scheme.error : scheme.onSurfaceVariant;
    final content = Row(
      children: [
        Expanded(
          child: Text(
            l10n.ordersComposerCustomerRequired,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: labelColor,
                  fontWeight: showError ? FontWeight.w600 : null,
                ),
          ),
        ),
        IconButton(
          tooltip: l10n.customersSearchHint,
          onPressed: onSearchCustomer,
          icon: Icon(Icons.search, color: showError ? scheme.error : null),
        ),
        IconButton(
          tooltip: l10n.customersAddCta,
          onPressed: onAddCustomer,
          icon: Icon(
            Icons.person_add_outlined,
            color: showError ? scheme.error : null,
          ),
        ),
      ],
    );

    if (!showError) return content;

    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: scheme.error, width: 1.5),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        child: content,
      ),
    );
  }
}

class _ComposerRecentOrdersCard extends ConsumerWidget {
  const _ComposerRecentOrdersCard({
    required this.customerId,
    required this.l10n,
    required this.money,
  });

  final String customerId;
  final AppLocalizations l10n;
  final String Function(AppLocalizations l10n, int minor) money;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final shopId = ref.watch(effectiveShopIdProvider);
    final asyncShopPayments = ref.watch(paymentsForShopProvider(shopId));
    final paidByOrderId = asyncShopPayments.hasValue
        ? OrderPaymentRules.sumPaidMinorByOrderId(
            (asyncShopPayments.value ?? const [])
                .map((p) => (orderInternalId: p.orderInternalId, amountMinor: p.amountMinor)),
          )
        : const <String, int>{};
    final paymentsLedgerLoaded = asyncShopPayments.hasValue;

    return ordersAsync.when(
      data: (orders) {
        final recent = customerOrdersForReference(orders, customerId)
            .take(10)
            .toList();
        if (recent.isEmpty) return const SizedBox.shrink();
        return Card(
          clipBehavior: Clip.antiAlias,
          child: Column(
            children: [
              ListTile(
                title: Text(l10n.ordersComposerRecentOrdersTitle),
                subtitle: Text(l10n.ordersComposerRecentOrdersSubtitle),
              ),
              const Divider(height: 1),
              for (final o in recent) ...[
                ListTile(
                  title: Text('#${o.displayOrderNo} • ${o.customerName}'),
                  subtitle: Text(
                    l10n.ordersComposerRecentOrderRowSubtitle(
                      AppCalendarFormat.mediumDate(
                        l10n,
                        calendar,
                        o.deliveryDate,
                        locale,
                      ),
                      money(
                        l10n,
                        OrderPaymentRules.remainingMinor(
                          o.totalAmountMinor,
                          OrderPaymentRules.paidMinorForOrder(
                            orderSummaryPaidMinor: o.paidAmountMinor,
                            paidByOrderId: paidByOrderId,
                            orderInternalId: o.internalId,
                            paymentsLedgerLoaded: paymentsLedgerLoaded,
                          ),
                        ),
                      ),
                    ),
                  ),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.edit_outlined),
                        tooltip: l10n.ordersDetailEditCta,
                        onPressed: () => context.go(
                          orderComposerRoute(orderId: o.internalId),
                        ),
                      ),
                      const Icon(Icons.chevron_right),
                    ],
                  ),
                  onTap: () => context.go(
                    orderComposerRoute(
                      customerId: customerId,
                      referenceOrderId: o.internalId,
                    ),
                  ),
                ),
                if (o != recent.last) const Divider(height: 1),
              ],
            ],
          ),
        );
      },
      loading: () => const SizedBox.shrink(),
      error: (e, st) => const SizedBox.shrink(),
    );
  }
}

