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
import '../customers/customer_search_filter.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_name_rules.dart';
import '../../data/local/customer_repository_exception.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/customer_uniqueness.dart';
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
import '../settings/composer_visibility_provider.dart';
import 'order_composer_draft.dart';
import 'order_composer_receipt_garment_block.dart';
import 'order_composer_item_card.dart';
import 'order_composer_reference.dart';
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
  final price = draft.priceAmountMinor > 0
      ? draft.priceAmountMinor
      : (existing?.priceAmountMinor ?? 0);
  if (existing != null) {
    return orderItemCreateInputFromSummary(
      existing,
      priceAmountMinor: price,
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
      measurementSnapshotItems: draft.measurementSnapshotItems,
    );
  }
  return OrderItemCreateInput(
    garmentType: draft.garmentType,
    priceAmountMinor: price,
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
    measurementSnapshotItems: draft.measurementSnapshotItems,
  );
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
  final _customerSearchController = TextEditingController();

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

  final _paidController = TextEditingController();

  DateTime? _deliveryDate;

  final _formRevision = ValueNotifier<int>(0);

  Listenable get _paymentFieldsListenable => Listenable.merge([
        _paidController,
        ..._itemPriceControllers.values,
      ]);

  /// Rebuilds save affordances without rebuilding the full composer body.
  Listenable get _composerFormListenable => Listenable.merge([
        _paymentFieldsListenable,
        _customerSearchController,
        _formRevision,
      ]);

  void _notifyFormRevision() {
    _formRevision.value++;
  }

  @override
  void initState() {
    super.initState();
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

  void _populateFromOrder(OrderSummary order) {
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
      _customerSearchController.clear();
    } else {
      _selectedCustomerId = order.customerInternalId;
      _selectedCustomerName = order.customerName;
      _selectedCustomerPhone = order.customerPhone;
      _selectedCustomerLabel = order.customerName;
    }
    _clearItemDrafts();
    for (final item in orderItemsForComposerEdit(order)) {
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
      setState(() => _populateFromOrder(order));
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
    _customerSearchController.dispose();
    _paidController.dispose();
    _formRevision.dispose();
    for (final c in _itemPriceControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  void _syncItemPricesFromControllers() {
    var draft = _draft;
    for (final type in GarmentType.values) {
      final minor = tryParseMoneyAmount(_itemPriceControllers[type]!.text) ?? 0;
      draft = draft.updateItemPrice(type, minor);
    }
    _draft = draft;
  }

  int _composerTotalMinor(bool clothBlockEnabled) {
    _syncItemPricesFromControllers();
    return _draft.totalMinor(clothBlockEnabled: clothBlockEnabled);
  }

  int get _composerPaidMinor =>
      tryParseMoneyAmount(_paidController.text) ?? 0;

  /// Customer name is required: selected customer or typed name (min 2 chars).
  bool get _hasCustomerForSave {
    if (_selectedCustomerId != null) {
      return isValidCustomerName(_selectedCustomerName);
    }
    return isValidCustomerName(_customerSearchController.text);
  }

  bool _canSave(bool clothBlockEnabled) {
    _syncItemPricesFromControllers();
    return _draft.canSave(
      customerSelected: _hasCustomerForSave,
      paidMinor: _composerPaidMinor,
      clothBlockEnabled: clothBlockEnabled,
    );
  }

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
    setState(() {
      _referenceOrderOverrideId = null;
      _lastPrefilledReferenceId = null;
      _selectedCustomerId = c.internalId;
      _selectedCustomerName = c.name;
      _selectedCustomerPhone = c.phone;
      _selectedCustomerLabel = _customerSummaryLabel(c);
      _clearItemDrafts();
      _customerSearchController.clear();
    });
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

  Future<void> _openNewCustomerForOrder(String name) async {
    final trimmed = name.trim();
    if (!isValidCustomerName(trimmed)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: AppLocalizations.of(context)!.customerNameTooShort,
      );
      return;
    }
    final result = await context.push<NewCustomerForOrderResult>(
      newCustomerRoute(returnTo: 'orderComposer', name: trimmed),
    );
    if (!mounted || result == null) return;
    setState(() {
      _referenceOrderOverrideId = null;
      _lastPrefilledReferenceId = null;
      _selectedCustomerId = result.internalId;
      _selectedCustomerName = result.name;
      _selectedCustomerPhone = result.phone;
      _selectedCustomerLabel = _newCustomerResultLabel(result);
      _clearItemDrafts();
      _customerSearchController.clear();
    });
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
    if (_selectedCustomerId != null) {
      if (!isValidCustomerName(_selectedCustomerName)) {
        showAppFeedback(
          context,
          ref,
          kind: AppFeedbackKind.error,
          message: l10n.customerNameRequired,
        );
        return null;
      }
      return _selectedCustomerId;
    }
    final typed = _customerSearchController.text.trim();
    if (typed.isEmpty) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.customerNameRequired,
      );
      return null;
    }
    if (!isValidCustomerName(typed)) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.customerNameTooShort,
      );
      return null;
    }
    final customers =
        ref.read(customersListStreamProvider).valueOrNull ?? const [];
    final existing = findCustomerByExactName(customers, typed);
    if (existing != null) {
      _selectedCustomerId = existing.internalId;
      _selectedCustomerName = existing.name;
      _selectedCustomerPhone = existing.phone;
      _selectedCustomerLabel = _customerSummaryLabel(existing);
      return existing.internalId;
    }
    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final customersRepo =
        await ref.read(customerListRepositoryProvider.future);
    try {
      final id = await customersRepo.createCustomer(
        shopId: shopId,
        name: typed,
        phone: _selectedCustomerPhone,
      );
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.customerUpsert,
        entityRef: id,
        shopId: shopId,
        payloadJson: jsonEncode({
          'name': typed,
          if (_selectedCustomerPhone != null &&
              _selectedCustomerPhone!.trim().isNotEmpty)
            'phone': _selectedCustomerPhone!.trim(),
        }),
      );
      _selectedCustomerId = id;
      _selectedCustomerName = typed;
      _selectedCustomerLabel = typed;
      return id;
    } on CustomerRepositoryException catch (e) {
      if (!context.mounted) return null;
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: customerRepositoryErrorMessage(e, l10n),
      );
      return null;
    }
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
    final clothBlockEnabled =
        ref.read(composerVisibilitySettingsProvider).showClothBlock;
    final totalMinor = _draft.totalMinor(clothBlockEnabled: clothBlockEnabled);
    var paidMinor = _composerPaidMinor;
    if (paidMinor < 0) paidMinor = 0;
    if (totalMinor > 0 && paidMinor > totalMinor) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.ordersComposerPaymentRequired,
      );
      return;
    }
    final now = DateTime.now();
    final deliveryDate = _deliveryDate ??
        DateTime(now.year, now.month, now.day);
    final createInputs = _draft.toCreateInputs(styleSelections: _styleSelections);

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
          if (merged.priceAmountMinor <= 0) {
            if (!context.mounted) return;
            showAppFeedback(
              context,
              ref,
              kind: AppFeedbackKind.error,
              message: l10n.ordersComposerItemPriceRequired,
            );
            return;
          }
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
    _customerSearchController.clear();
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
      _ComposerCustomerSearchSection(
        l10n: l10n,
        searchController: _customerSearchController,
        customers: customersForSearch,
        selectedCustomerId: _selectedCustomerId,
        selectedCustomerLabel: _selectedCustomerLabel,
        onCustomerSelected: _applyCustomer,
        onClearCustomer: _clearSelectedCustomer,
        onNewCustomerName: _openNewCustomerForOrder,
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
              customerId: _selectedCustomerId,
              measurementProfiles: measurementProfiles,
              referenceOrder: referenceOrder,
              referenceItem: refItem,
              moneyFormatter: _money,
              onDraftChanged: (next) {
                _draft = _draft.updateItem(type, next);
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
      ListenableBuilder(
        listenable: _paymentFieldsListenable,
        builder: (context, _) {
          final total = _composerTotalMinor(clothBlockEnabled);
          final paid = _composerPaidMinor;
          final remaining = OrderPaymentRules.remainingMinor(total, paid);
          final clothLines =
              _draft.clothPaymentLines(clothBlockEnabled: clothBlockEnabled);
          return Column(
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
              PrideOptionalPanel(
                isEmpty: paid <= 0 && total <= 0,
                padding: EdgeInsets.zero,
                child: PrideMoneyField(
                  controller: _paidController,
                  labelText: l10n.paymentPaid,
                ),
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
          );
        },
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
    return Scaffold(
      appBar: AppBar(
        leading: widget.isTabRoot
            ? null
            : BackButton(onPressed: () => context.pop()),
        automaticallyImplyLeading: !widget.isTabRoot,
        title: Text(
          _editingOrderId != null ? l10n.ordersEditTitle : l10n.ordersNewTitle,
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          final padding = prideComposerScrollPadding(context);
          if (!prideIsTabletOrWider(constraints.maxWidth)) {
            return ListView(
              padding: padding,
              children: [
                ...sections.meta,
                ...sections.garments,
                ...sections.footer,
              ],
            );
          }
          return SingleChildScrollView(
            padding: padding,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 2,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      ...sections.meta,
                      ...sections.footer,
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  flex: 3,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: sections.garments,
                  ),
                ),
              ],
            ),
          );
        },
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
              onPressed: _canSave(clothBlockEnabled)
                  ? () => _onSavePressed(context, l10n)
                  : null,
              style: prideButtonStyle(context, PrideButtonVariant.add),
              icon: const Icon(Icons.check),
              label: Text(l10n.ordersComposerSaveCta),
            ),
          );
        },
      ),
    );
  }
}

/// Isolated customer search — [ValueListenableBuilder] avoids parent rebuilds
/// that dismiss the keyboard on each keystroke.
class _ComposerCustomerSearchSection extends StatefulWidget {
  const _ComposerCustomerSearchSection({
    required this.l10n,
    required this.searchController,
    required this.customers,
    required this.selectedCustomerId,
    required this.selectedCustomerLabel,
    required this.onCustomerSelected,
    required this.onClearCustomer,
    required this.onNewCustomerName,
  });

  final AppLocalizations l10n;
  final TextEditingController searchController;
  final List<CustomerSummary> customers;
  final String? selectedCustomerId;
  final String? selectedCustomerLabel;
  final ValueChanged<CustomerSummary> onCustomerSelected;
  final VoidCallback onClearCustomer;
  final ValueChanged<String> onNewCustomerName;

  @override
  State<_ComposerCustomerSearchSection> createState() =>
      _ComposerCustomerSearchSectionState();
}

class _ComposerCustomerSearchSectionState
    extends State<_ComposerCustomerSearchSection> {
  late final FocusNode _searchFocus;

  @override
  void initState() {
    super.initState();
    _searchFocus = FocusNode();
  }

  @override
  void dispose() {
    _searchFocus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.selectedCustomerId != null) {
      final label = widget.selectedCustomerLabel ?? '';
      return ListTile(
        contentPadding: EdgeInsets.zero,
        dense: true,
        leading: const Icon(Icons.person_outline),
        title: Text(label),
        trailing: PrideCloseIconButton(
          tooltip: widget.l10n.editCta,
          onPressed: widget.onClearCustomer,
        ),
      );
    }

    return ValueListenableBuilder<TextEditingValue>(
      valueListenable: widget.searchController,
      builder: (context, value, _) {
        final query = value.text;
        final trimmed = query.trim();
        final matches = trimmed.isEmpty
            ? const <CustomerSummary>[]
            : filterCustomersBySearchQuery(widget.customers, query);
        final hasExactMatch = trimmed.isNotEmpty &&
            matches.any(
              (c) => c.name.trim().toLowerCase() == trimmed.toLowerCase(),
            );
        final showAddNew =
            trimmed.isNotEmpty && !hasExactMatch && isValidCustomerName(trimmed);

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            TextField(
              focusNode: _searchFocus,
              controller: widget.searchController,
              decoration: InputDecoration(
                hintText: widget.l10n.customersSearchHint,
                prefixIcon: const Icon(Icons.search),
                suffixIcon: query.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        tooltip: MaterialLocalizations.of(context)
                            .clearButtonTooltip,
                        onPressed: widget.searchController.clear,
                      )
                    : null,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              textInputAction: TextInputAction.search,
              onSubmitted: (text) {
                final q = text.trim();
                if (q.isEmpty) return;
                final match = findFirstCustomerBySearchQuery(
                  widget.customers,
                  q,
                );
                if (match != null) {
                  widget.onCustomerSelected(match);
                } else if (isValidCustomerName(q)) {
                  widget.onNewCustomerName(q);
                }
              },
            ),
            if (trimmed.isNotEmpty) ...[
              const SizedBox(height: 4),
              if (matches.isNotEmpty)
                ConstrainedBox(
                  constraints: const BoxConstraints(maxHeight: 220),
                  child: ListView.separated(
                    shrinkWrap: true,
                    physics: const ClampingScrollPhysics(),
                    padding: EdgeInsets.zero,
                    itemCount: matches.length,
                    separatorBuilder: (context, index) =>
                        const Divider(height: 1),
                    itemBuilder: (context, i) {
                      final c = matches[i];
                      final idLabel =
                          parseStoredDisplayCustomerNo(c.displayCustomerNo) > 0
                              ? formatDisplayCustomerNo(c.displayCustomerNo)
                              : null;
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.person_outline, size: 20),
                        title: Text(c.name),
                        subtitle: Text(
                          [
                            if (idLabel != null) idLabel,
                            c.phone ?? widget.l10n.customersPhoneMissing,
                          ].join(' • '),
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                        onTap: () => widget.onCustomerSelected(c),
                      );
                    },
                  ),
                ),
              if (showAddNew)
                ListTile(
                  dense: true,
                  contentPadding: EdgeInsets.zero,
                  leading: const Icon(Icons.person_add_outlined, size: 20),
                  title: Text(
                    widget.l10n.ordersComposerUseNewCustomer(trimmed),
                  ),
                  onTap: () => widget.onNewCustomerName(trimmed),
                ),
            ],
          ],
        );
      },
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

