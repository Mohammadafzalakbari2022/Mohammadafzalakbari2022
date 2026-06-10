import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/formatting/app_number_format.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/widgets/pride_close_button.dart';
import 'package:pride_v3/core/widgets/pride_form_bottom_bar.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/core/widgets/pride_alert_dialog.dart';
import 'package:pride_v3/core/printing/thermal_print_order.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../customers/new_customer_screen.dart';
import '../customers/customer_search_filter.dart';
import '../../data/local/customer_display_no.dart';
import '../../data/local/customer_summary.dart';
import 'package:pride_v3/core/formatting/display_customer_no_format.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/entities/garment_type.dart';
import '../../data/local/order_item_draft.dart';
import '../../data/local/order_item_snapshot_key.dart';
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
import 'order_composer_customer_picker.dart';
import 'order_composer_draft.dart';
import 'order_composer_item_card.dart';
import 'order_composer_measurements_sheet.dart';
import 'order_composer_progress_header.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_composer_reference.dart';
import 'order_composer_style_sheet.dart';
import 'order_invoice_share.dart';
import 'order_invoice_view.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';

import 'order_payment_mutations.dart';
import 'order_payment_rules.dart';
import 'order_payment_sheet.dart';
import 'order_status_label.dart';

/// Route to the order composer, optionally with a preselected customer and
/// in-memory reference order override.
String orderComposerRoute({
  String? customerId,
  String? referenceOrderId,
}) {
  final id = customerId?.trim();
  final refId = referenceOrderId?.trim();
  final params = <String, String>{};
  if (id != null && id.isNotEmpty) {
    params['customerId'] = id;
  }
  if (refId != null && refId.isNotEmpty) {
    params['referenceOrderId'] = refId;
  }
  if (params.isEmpty) return '/app/orders/new';
  final query = params.entries
      .map((e) => '${e.key}=${Uri.encodeComponent(e.value)}')
      .join('&');
  return '/app/orders/new?$query';
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

class OrderComposerScreen extends ConsumerStatefulWidget {
  const OrderComposerScreen({
    super.key,
    this.initialCustomerId,
    this.initialReferenceOrderId,
  });

  final String? initialCustomerId;

  /// In-memory reference override only; never persisted on the new order.
  final String? initialReferenceOrderId;

  @override
  ConsumerState<OrderComposerScreen> createState() => _OrderComposerScreenState();
}

const _kComposerSectionGap = 14.0;

class _OrderComposerScreenState extends ConsumerState<OrderComposerScreen> {
  final _customerSearchController = TextEditingController();

  var _customerPrefillApplied = false;
  var _referencePrefillApplied = false;

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

  Listenable get _paymentFieldsListenable => Listenable.merge([
        _paidController,
        ..._itemPriceControllers.values,
      ]);

  @override
  void initState() {
    super.initState();
    if (widget.initialCustomerId != null &&
        widget.initialCustomerId!.trim().isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        _attemptCustomerPrefill();
      });
    }
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _paidController.dispose();
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

  int get _composerTotalMinor {
    _syncItemPricesFromControllers();
    return _draft.totalMinor();
  }

  int get _composerPaidMinor =>
      tryParseMoneyAmount(_paidController.text) ?? 0;

  bool get _canSave {
    _syncItemPricesFromControllers();
    return _draft.canSave(
      customerSelected: _selectedCustomerId != null,
      deliveryDateSet: _deliveryDate != null,
      paidMinor: _composerPaidMinor,
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
      _selectedCustomerId = c.internalId;
      _selectedCustomerName = c.name;
      _selectedCustomerPhone = c.phone;
      _selectedCustomerLabel = _customerSummaryLabel(c);
      _clearItemDrafts();
      _customerSearchController.clear();
    });
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
      _attemptReferencePrefill(match.internalId);
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

  void _attemptReferencePrefill(String customerId) {
    if (_referencePrefillApplied || !mounted) return;
    final initialRef = widget.initialReferenceOrderId;
    if (initialRef == null || initialRef.trim().isEmpty) {
      _referencePrefillApplied = true;
      return;
    }

    final asyncOrders = ref.read(ordersListStreamProvider);
    if (asyncOrders.isLoading) return;

    final validId = resolveInitialReferenceOrderId(
      allOrders: asyncOrders.valueOrNull ?? const [],
      customerId: customerId,
      referenceOrderId: initialRef,
    );
    _referencePrefillApplied = true;
    if (validId != null) {
      setState(() => _referenceOrderOverrideId = validId);
    }
  }

  void _clearSelectedCustomer() {
    setState(() {
      _referenceOrderOverrideId = null;
      _selectedCustomerId = null;
      _selectedCustomerLabel = null;
      _selectedCustomerName = null;
      _selectedCustomerPhone = null;
      _clearItemDrafts();
    });
  }

  Future<void> _openStyleSheet(
    BuildContext context,
    GarmentType garmentType,
  ) async {
    final draft = _itemDraft(garmentType);
    final orders = ref.read(ordersListStreamProvider).valueOrNull ?? const [];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(orders, _selectedCustomerId!),
            _referenceOrderOverrideId,
          );
    final refItem =
        referenceOrder != null ? referenceOrderItem(referenceOrder, garmentType) : null;
    final result = await showOrderComposerStyleSheet(
      context: context,
      ref: ref,
      garmentType: garmentType,
      initialMainStyle: draft.styleName,
      initialStyleNameInternalId: draft.styleNameInternalId,
      initialSelection:
          _styleSelections[garmentType] ?? const StyleOrderSelection.empty(),
      initialCatalogItemInternalId: draft.catalogItemInternalId,
      initialCatalogDesignName: draft.catalogDesignName,
      initialCatalogDesignerShopName: draft.catalogDesignerShopName,
      initialCatalogImagePath: draft.catalogImagePath,
      initialCatalogThumbnailPath: draft.catalogThumbnailPath,
      referenceOrder: referenceOrder,
      referenceItem: refItem,
      initialStyleSummary: draft.styleSummary,
      moneyFormatter: _money,
      onUsePreviousStyle: referenceOrder != null
          ? () {
              _applyPreviousStyle(referenceOrder, garmentType);
              if (context.mounted) Navigator.of(context).pop();
            }
          : null,
      onUsePreviousDesign:
          referenceOrder != null && garmentType == GarmentType.perahanTunban
              ? () async {
                  await _applyPreviousDesign(referenceOrder);
                  if (context.mounted) Navigator.of(context).pop();
                }
              : null,
    );
    if (!mounted || result == null) return;
    setState(() {
      _styleSelections[garmentType] = result.selection;
      _draft = _draft.updateItem(
        garmentType,
        draft.copyWith(
          styleName: result.mainStyleName,
          styleNameInternalId: result.styleNameInternalId,
          styleSummary: result.summary,
          catalogItemInternalId: result.catalogItemInternalId,
          catalogDesignName: result.catalogDesignName,
          catalogDesignerShopName: result.catalogDesignerShopName,
          catalogImagePath: result.catalogImagePath,
          catalogThumbnailPath: result.catalogThumbnailPath,
        ),
      );
    });
  }

  Future<void> _openPaymentSheet(BuildContext context) async {
    final total = _composerTotalMinor;
    final paid = _composerPaidMinor;
    final l10n = AppLocalizations.of(context)!;
    final orders = ref.read(ordersListStreamProvider).valueOrNull ?? const [];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(orders, _selectedCustomerId!),
            _referenceOrderOverrideId,
          );
    Widget? previousSection;
    if (referenceOrder != null) {
      previousSection = ComposerSheetPreviousHeader(
        title: l10n.ordersComposerPreviousOrderTitle,
        previousSection: ComposerSheetPreviousSection(
          referenceOrder: referenceOrder,
          kind: ComposerSheetPreviousKind.payment,
          currentTextForDiff: _money(l10n, paid),
          currentIsMeaningfulForDiff: paid > 0,
          money: _money,
        ),
      );
    }
    final result = await showOrderPaymentDraftSheet(
      context: context,
      initialTotalMinor: total,
      initialPaidMinor: paid,
      itemBreakdown: paymentBreakdownFromDraft(_draft),
      totalReadOnly: true,
      previousOrderSection: previousSection,
    );
    if (!mounted || result == null) return;
    setState(() {
      _paidController.text = result.initialPaidMinor.toString();
      for (final entry in result.itemPricesMinor.entries) {
        final minor = entry.value;
        _itemPriceControllers[entry.key]!.text =
            minor > 0 ? minor.toString() : '';
        _draft = _draft.updateItemPrice(entry.key, minor);
      }
    });
  }

  Future<void> _openFabricSheet(
    BuildContext context,
    GarmentType garmentType,
  ) async {
    final l10n = AppLocalizations.of(context)!;
    final draft = _itemDraft(garmentType);
    final orders = ref.read(ordersListStreamProvider).valueOrNull ?? const [];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(orders, _selectedCustomerId!),
            _referenceOrderOverrideId,
          );
    final refItem =
        referenceOrder != null ? referenceOrderItem(referenceOrder, garmentType) : null;
    final fabricSummary = draft.hasFabric
        ? l10n.ordersComposerFabricSummary(
            draft.fabricName,
            draft.fabricColor,
            draft.fabricId,
          )
        : '';
    final result = await showOrderComposerFabricSheet(
      context: context,
      initialName: draft.fabricName,
      initialColor: draft.fabricColor,
      initialFabricId: draft.fabricId,
      initialNamePresetId: draft.fabricNamePresetInternalId,
      initialColorPresetId: draft.fabricColorPresetInternalId,
      referenceOrder: referenceOrder,
      referenceItem: refItem,
      initialFabricSummary: fabricSummary,
      moneyFormatter: _money,
      onUsePreviousFabric: referenceOrder != null
          ? () {
              _applyPreviousFabric(referenceOrder, garmentType);
              if (context.mounted) Navigator.of(context).pop();
            }
          : null,
    );
    if (!mounted) return;
    setState(() {
      if (result == null || result.isEmpty) {
        _draft = _draft.updateItem(
          garmentType,
          draft.copyWith(
            fabricName: '',
            fabricColor: '',
            fabricId: '',
            fabricNamePresetInternalId: null,
            fabricColorPresetInternalId: null,
          ),
        );
      } else {
        _draft = _draft.updateItem(
          garmentType,
          draft.copyWith(
            fabricName: result.fabricName,
            fabricColor: result.fabricColor,
            fabricId: result.fabricId,
            fabricNamePresetInternalId: result.fabricNamePresetInternalId,
            fabricColorPresetInternalId: result.fabricColorPresetInternalId,
          ),
        );
      }
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
        ),
      );
    });
  }

  Future<void> _openDeliverySheet(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final calendar = ref.read(dateCalendarSystemProvider);
    final locale = Localizations.localeOf(context).toString();
    final orders = ref.read(ordersListStreamProvider).valueOrNull ?? const [];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(orders, _selectedCustomerId!),
            _referenceOrderOverrideId,
          );
    final deliveryLabel = _deliveryDate == null
        ? l10n.ordersComposerDeliveryDateUnset
        : AppCalendarFormat.mediumDate(l10n, calendar, _deliveryDate!, locale);

    final picked = await showPrideModalBottomSheet<DateTime>(
      context: context,
      builder: (ctx) {
        return PrideDraggableSheetScaffold(
          header: Padding(
            padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
            child: Row(
              children: [
                IconButton(
                  onPressed: () => Navigator.pop(ctx),
                  icon: const Icon(Icons.close),
                ),
                Expanded(
                  child: Text(
                    l10n.ordersComposerDeliveryDateTitle,
                    style: Theme.of(ctx).textTheme.titleLarge,
                  ),
                ),
              ],
            ),
          ),
          body: (scroll) => ListView(
            controller: scroll,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
            children: [
              if (referenceOrder != null) ...[
                ComposerSheetPreviousSection(
                  referenceOrder: referenceOrder,
                  kind: ComposerSheetPreviousKind.delivery,
                  currentTextForDiff: deliveryLabel,
                  currentIsMeaningfulForDiff: _deliveryDate != null,
                  money: _money,
                ),
                const Divider(height: 24),
              ],
              ListTile(
                contentPadding: EdgeInsets.zero,
                title: Text(l10n.ordersComposerDeliveryDateTitle),
                subtitle: Text(deliveryLabel),
                trailing: const Icon(Icons.event_outlined),
                onTap: () async {
                  final initial = _deliveryDate ?? now.add(const Duration(days: 2));
                  final date = await showAppDatePicker(
                    context: ctx,
                    l10n: l10n,
                    system: calendar,
                    initialDate: initial,
                    firstDate: DateTime(now.year - 1),
                    lastDate: DateTime(now.year + 3),
                  );
                  if (date == null || !ctx.mounted) return;
                  Navigator.pop(
                    ctx,
                    DateTime(date.year, date.month, date.day),
                  );
                },
              ),
            ],
          ),
        );
      },
    );
    if (!mounted || picked == null) return;
    setState(() => _deliveryDate = picked);
  }

  Future<void> _confirmReset(BuildContext context, AppLocalizations l10n) async {
    final ok = await showPrideAlertDialog<bool>(
      context: context,
      icon: Icons.restart_alt_outlined,
      title: l10n.ordersComposerResetTitle,
      content: Text(l10n.ordersComposerResetBody),
      actions: prideDialogCancelSave(
        context: context,
        onCancel: () => Navigator.of(context).pop(false),
        onConfirm: () => Navigator.of(context).pop(true),
        saveLabel: l10n.resetCta,
        confirmVariant: PrideButtonVariant.warning,
      ),
    );
    if (ok != true) return;
    setState(() {
      _referenceOrderOverrideId = null;
      _selectedCustomerId = null;
      _selectedCustomerLabel = null;
      _selectedCustomerName = null;
      _selectedCustomerPhone = null;
      _paidController.clear();
      _deliveryDate = null;
      _clearItemDrafts();
    });
  }

  void _applyNewCustomerForOrder(NewCustomerForOrderResult created) {
    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    _applyCustomer(
      CustomerSummary(
        shopId: shopId,
        internalId: created.internalId,
        name: created.name,
        displayCustomerNo: created.displayCustomerNo,
        phone: created.phone,
        createdAt: DateTime.now(),
      ),
    );
  }

  Future<void> _pickExistingCustomer(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    var customers = ref.read(customersListStreamProvider).valueOrNull;
    if (customers == null) {
      await ref.read(customersListStreamProvider.future);
      if (!context.mounted) return;
      customers = ref.read(customersListStreamProvider).valueOrNull;
    }
    final list = customers ?? const <CustomerSummary>[];

    final picked = await showOrderComposerCustomerPicker(
      context: context,
      customers: list,
      l10n: l10n,
      selectedId: _selectedCustomerId,
      initialQuery: _customerSearchController.text,
    );
    if (picked != null && mounted) _applyCustomer(picked);
  }

  Future<void> _openNewCustomerForm(BuildContext context) async {
    final result = await context.push<Object?>(
      '/app/customers/new?returnTo=orderComposer',
    );
    if (!mounted || result == null) return;
    if (result is NewCustomerForOrderResult) {
      _applyNewCustomerForOrder(result);
      return;
    }
    // Legacy: id-only pop (stream lookup).
    if (result is String) {
      final list =
          ref.read(customersListStreamProvider).valueOrNull ?? const [];
      for (final c in list) {
        if (c.internalId == result) {
          _applyCustomer(c);
          return;
        }
      }
    }
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
        ),
      );
    });
  }

  Future<void> _openMeasurementsEditor(
    BuildContext context,
    AppLocalizations l10n,
    GarmentType garmentType,
  ) async {
    if (_selectedCustomerId == null) {
      await showPrideAlertDialog<void>(
        context: context,
        icon: Icons.person_outline,
        iconColor: prideSettingsIconColor(0),
        title: l10n.ordersComposerSelectCustomerFirstTitle,
        content: Text(l10n.ordersComposerSelectCustomerFirstBody),
        actions: [
          FilledButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text(MaterialLocalizations.of(context).okButtonLabel),
          ),
        ],
      );
      return;
    }

    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);

    // Wait for types to load — a null [AsyncValue] previously opened a freeform
    // "notes" sheet on the first tap while the stream was still loading.
    final typesState = ref.read(measurementTypesStreamProvider);
    if (!typesState.hasValue && !typesState.hasError) {
      await ref.read(measurementTypesStreamProvider.future);
      if (!context.mounted) return;
    }

    final profiles = ref
            .read(measurementProfilesForCustomerProvider(_selectedCustomerId!))
            .valueOrNull ??
        const <MeasurementProfileSummary>[];

    if (!context.mounted) return;
    final draft = _itemDraft(garmentType);
    final orders = ref.read(ordersListStreamProvider).valueOrNull ?? const [];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(orders, _selectedCustomerId!),
            _referenceOrderOverrideId,
          );
    final refItem =
        referenceOrder != null ? referenceOrderItem(referenceOrder, garmentType) : null;
    final r = await showOrderMeasurementsEditorSheet(
      context: context,
      ref: ref,
      l10n: l10n,
      shopId: shopId,
      customerId: _selectedCustomerId,
      initialSnapshotText: draft.measurementsSnapshot,
      initialItems: List<OrderMeasurementSnapshotItemInput>.of(
        draft.measurementSnapshotItems,
      ),
      initialProfileId: draft.sourceMeasurementProfileId,
      initialProfileLabel: draft.sourceMeasurementProfileLabel,
      profiles: profiles,
      referenceOrder: referenceOrder,
      referenceItem: refItem,
      moneyFormatter: _money,
      onUsePreviousMeasurements: referenceOrder != null
          ? () async {
              await _applyPreviousMeasurements(referenceOrder, garmentType);
              if (context.mounted) Navigator.of(context).pop();
            }
          : null,
    );
    if (r == null || !mounted) return;
    setState(() {
      _draft = _draft.updateItem(
        garmentType,
        draft.copyWith(
          measurementsSnapshot: r.measurementsSnapshot,
          measurementSnapshotItems: r.measurementSnapshotItems,
          sourceMeasurementProfileId: r.sourceMeasurementProfileId,
          sourceMeasurementProfileLabel: r.sourceMeasurementProfileLabel,
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
                onTap: () => Navigator.pop(ctx),
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

    final customerId = _selectedCustomerId!;
    _syncItemPricesFromControllers();
    final totalMinor = _draft.totalMinor();
    final paidMinor = _composerPaidMinor;
    final deliveryDate = _deliveryDate!;
    final createInputs = _draft.toCreateInputs(styleSelections: _styleSelections);

    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);

    final ordersRepo = await ref.read(orderListRepositoryProvider.future);
    final paymentsRepo = await ref.read(paymentRepositoryProvider.future);

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
    await _showPostSaveSheet(context, l10n, orderId);
    if (context.mounted) {
      context.go('/app/orders/$orderId?fromNew=1');
    }
  }

  String _money(AppLocalizations l10n, int minor) {
    return AppNumberFormat.formatMoney(l10n, minor);
  }

  Future<void> _showValidationDialog(
    BuildContext context,
    AppLocalizations l10n,
  ) async {
    final missing = <Widget>[];
    if (_selectedCustomerId == null) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.person_outline,
          iconColor: prideSettingsIconColor(0),
          label: l10n.ordersComposerCustomerRequired,
        ),
      );
    }
    if (!_draft.hasAtLeastOneItem) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.checklist_outlined,
          iconColor: prideSettingsIconColor(1),
          label: l10n.ordersComposerNoItemsError,
        ),
      );
    }
    for (final type in _draft.selectedGarmentTypes) {
      final item = _draft.items[type]!;
      final label = composerGarmentLabel(l10n, type);
      if (!item.hasMeasurements) {
        missing.add(
          PrideAlertDialogBullet(
            icon: Icons.straighten,
            iconColor: prideSettingsIconColor(1),
            label: '$label: ${l10n.ordersComposerMeasurementsRequired}',
          ),
        );
      }
      if (!item.hasStyle) {
        missing.add(
          PrideAlertDialogBullet(
            icon: Icons.checkroom_outlined,
            iconColor: prideSettingsIconColor(2),
            label: '$label: ${l10n.ordersComposerStyleRequired}',
          ),
        );
      }
      if (!item.hasRequiredPrice) {
        missing.add(
          PrideAlertDialogBullet(
            icon: Icons.payments_outlined,
            iconColor: prideSettingsIconColor(2),
            label: '$label: ${l10n.ordersComposerItemPriceRequired}',
          ),
        );
      }
    }
    if (_deliveryDate == null) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.event_outlined,
          iconColor: prideSettingsIconColor(3),
          label: l10n.ordersComposerDeliveryDateUnset,
        ),
      );
    }
    final total = _draft.totalMinor();
    final paid = _composerPaidMinor;
    if (total <= 0 || !OrderPaymentRules.isValidInitialPay(total, paid)) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.payments_outlined,
          iconColor: Theme.of(context).extension<PrideActionColors>()!.payment,
          label: l10n.ordersComposerPaymentRequired,
        ),
      );
    }

    await showPrideAlertDialog<void>(
      context: context,
      icon: Icons.info_outline,
      title: l10n.ordersComposerValidationTitle,
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Text(l10n.ordersComposerValidationBody),
          const SizedBox(height: 12),
          ...missing,
        ],
      ),
      actions: [
        FilledButton(
          onPressed: () => Navigator.of(context).pop(),
          child: Text(MaterialLocalizations.of(context).okButtonLabel),
        ),
      ],
    );
  }

  void _onSavePressed(BuildContext context, AppLocalizations l10n) {
    if (_canSave) {
      _save(context, l10n);
    } else {
      _showValidationDialog(context, l10n);
    }
  }

  Widget _composerRequiredHint(String message) {
    final scheme = Theme.of(context).colorScheme;
    final warning = Theme.of(context).extension<PrideActionColors>()!.warning;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(Icons.info_outline, size: 18, color: warning),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                    color: scheme.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
            ),
          ),
        ],
      ),
    );
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
      if (_customerPrefillApplied &&
          !_referencePrefillApplied &&
          widget.initialReferenceOrderId != null &&
          _selectedCustomerId != null &&
          next.hasValue) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _attemptReferencePrefill(_selectedCustomerId!);
        });
      }
    });

    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final deliveryLabel = _deliveryDate == null
        ? l10n.ordersComposerDeliveryDateUnset
        : AppCalendarFormat.mediumDate(l10n, calendar, _deliveryDate!, locale);

    final customerSubtitle =
        _selectedCustomerLabel ?? l10n.ordersComposerCustomerRequired;
    final ordersForRef =
        ref.watch(ordersListStreamProvider).valueOrNull ?? const <OrderSummary>[];
    final customersForSearch =
        ref.watch(customersListStreamProvider).valueOrNull ??
            const <CustomerSummary>[];
    final customerSearchQuery = _customerSearchController.text;
    final customerSearchMatches = _selectedCustomerId == null
        ? filterCustomersBySearchQuery(customersForSearch, customerSearchQuery)
        : const <CustomerSummary>[];
    final referenceOrder = _selectedCustomerId == null
        ? null
        : resolveReferenceOrder(
            customerOrdersForReference(ordersForRef, _selectedCustomerId!),
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
    return Scaffold(
      appBar: AppBar(
        leading: BackButton(onPressed: () => context.pop()),
        title: Text(l10n.ordersNewTitle),
        actions: [
          TextButton(
            onPressed: () => _confirmReset(context, l10n),
            child: Text(l10n.resetCta),
          ),
        ],
      ),
      body: ListView(
        padding: prideFormScrollPadding(context),
        children: [
          ListenableBuilder(
            listenable: _paymentFieldsListenable,
            builder: (context, _) {
              final total = _composerTotalMinor;
              final paid = _composerPaidMinor;
              final paymentOk =
                  total > 0 && OrderPaymentRules.isValidInitialPay(total, paid);
              return OrderComposerProgressHeader(
                l10n: l10n,
                customerDone: _selectedCustomerId != null,
                measurementsDone: _draft.measurementsDoneForAllIncluded(),
                styleDone: _draft.styleDoneForAllIncluded(),
                fabricDone: _draft.fabricDoneForAnyIncluded(),
                deliveryDone: _deliveryDate != null,
                paymentDone: paymentOk,
              );
            },
          ),
          const SizedBox(height: _kComposerSectionGap),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: SearchBar(
                    hintText: l10n.customersSearchHint,
                    controller: _customerSearchController,
                    leading: const Icon(Icons.search),
                    trailing: [
                      if (_customerSearchController.text.isNotEmpty)
                        IconButton(
                          icon: const Icon(Icons.clear),
                          tooltip: MaterialLocalizations.of(context)
                              .clearButtonTooltip,
                          onPressed: () {
                            _customerSearchController.clear();
                            setState(() {});
                          },
                        ),
                    ],
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      final q = _customerSearchController.text.trim();
                      if (q.isEmpty) {
                        _pickExistingCustomer(context, l10n);
                        return;
                      }
                      final match = findFirstCustomerBySearchQuery(
                        customersForSearch,
                        q,
                      );
                      if (match != null) {
                        _applyCustomer(match);
                        return;
                      }
                      _pickExistingCustomer(context, l10n);
                    },
                  ),
                ),
                if (_selectedCustomerId == null &&
                    customerSearchQuery.trim().isNotEmpty) ...[
                  if (customerSearchMatches.isEmpty)
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                      child: Text(
                        customersForSearch.isEmpty
                            ? l10n.customersEmptyTitle
                            : l10n.customersFilteredEmpty,
                        style: Theme.of(context).textTheme.bodyMedium,
                        textAlign: TextAlign.center,
                      ),
                    )
                  else
                    ConstrainedBox(
                      constraints: const BoxConstraints(maxHeight: 220),
                      child: ListView.separated(
                        shrinkWrap: true,
                        padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                        itemCount: customerSearchMatches.length,
                        separatorBuilder: (context, index) =>
                            const Divider(height: 1),
                        itemBuilder: (context, i) {
                          final c = customerSearchMatches[i];
                          final idLabel =
                              parseStoredDisplayCustomerNo(c.displayCustomerNo) >
                                      0
                                  ? formatDisplayCustomerNo(c.displayCustomerNo)
                                  : null;
                          return ListTile(
                            dense: true,
                            leading: const Icon(Icons.person_outline),
                            title: Text(c.name),
                            subtitle: Text(
                              [
                                if (idLabel != null) idLabel,
                                c.phone ?? l10n.customersPhoneMissing,
                              ].join(' • '),
                            ),
                            onTap: () => _applyCustomer(c),
                          );
                        },
                      ),
                    ),
                ],
                ListTile(
                  title: Text(l10n.ordersComposerCustomerTitle),
                  subtitle: Text(customerSubtitle),
                  isThreeLine: customerSubtitle.length > 48,
                  leading: PrideColoredLeading(
                    icon: Icons.person_outline,
                    color: prideSettingsIconColor(0),
                  ),
                  trailing: _selectedCustomerId == null
                      ? const Icon(Icons.chevron_right)
                      : PrideCloseIconButton(
                          tooltip: l10n.editCta,
                          onPressed: _clearSelectedCustomer,
                        ),
                  onTap: () => _openNewCustomerForm(context),
                ),
                if (_selectedCustomerId == null)
                  _composerRequiredHint(l10n.ordersComposerCustomerRequired),
                if (_selectedCustomerId != null) ...[
                  Builder(
                    builder: (context) {
                      final customerOrders = customerOrdersForReference(
                        ordersForRef,
                        _selectedCustomerId!,
                      );
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
                            (id) => setState(
                              () => _referenceOrderOverrideId = id,
                            ),
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
              ],
            ),
          ),
          const SizedBox(height: _kComposerSectionGap),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  title: Text(l10n.ordersComposerOrderItemsTitle),
                  subtitle: Text(
                    _draft.hasAtLeastOneItem
                        ? l10n.ordersComposerOrderItemsSelectedCount(
                            _draft.selectedGarmentTypes.length,
                          )
                        : l10n.ordersComposerNoItemsError,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: [
                      for (final type in GarmentType.values)
                        FilterChip(
                          label: Text(composerGarmentLabel(l10n, type)),
                          selected: _draft.items[type]!.included,
                          onSelected: (v) => _onGarmentChipSelected(type, v),
                        ),
                    ],
                  ),
                ),
                if (!_draft.hasAtLeastOneItem)
                  _composerRequiredHint(l10n.ordersComposerNoItemsError),
              ],
            ),
          ),
          for (final type in _draft.selectedGarmentTypes) ...[
            Builder(
              builder: (context) {
                final itemDraft = _itemDraft(type);
                return OrderComposerItemCard(
                  l10n: l10n,
                  garmentType: type,
                  draft: itemDraft,
                  expanded: _itemCardExpanded[type] ?? false,
                  onExpandedChanged: (v) =>
                      setState(() => _itemCardExpanded[type] = v),
                  onOpenMeasurements: () =>
                      _openMeasurementsEditor(context, l10n, type),
                  onOpenStyle: () => _openStyleSheet(context, type),
                  onOpenFabric: () => _openFabricSheet(context, type),
                  onUseSameFabric: type == GarmentType.waistcoat &&
                          _draft.items[GarmentType.perahanTunban]!.included &&
                          _draft.items[GarmentType.perahanTunban]!.hasFabric
                      ? _copyFabricFromPerahanToWaistcoat
                      : null,
                );
              },
            ),
          ],
          const SizedBox(height: _kComposerSectionGap),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                ListTile(
                  leading: PrideColoredLeading(
                    icon: Icons.event_outlined,
                    color: prideSettingsIconColor(4),
                  ),
                  title: Text(l10n.ordersComposerDeliveryDateTitle),
                  subtitle: Text(deliveryLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openDeliverySheet(context),
                ),
                if (_deliveryDate == null)
                  _composerRequiredHint(l10n.ordersComposerDeliveryDateUnset),
              ],
            ),
          ),
          const SizedBox(height: _kComposerSectionGap),
          ListenableBuilder(
            listenable: _paymentFieldsListenable,
            builder: (context, _) {
              final total = _composerTotalMinor;
              final paid = _composerPaidMinor;
              final remaining = OrderPaymentRules.remainingMinor(total, paid);
              final paymentSubtitle = total <= 0
                  ? l10n.ordersComposerPaymentRequired
                  : remaining > 0
                      ? '${_money(l10n, total)} · ${l10n.ordersComposerStillOwedLabel}: ${_money(l10n, remaining)}'
                      : '${_money(l10n, total)} · ${l10n.paymentPaid}: ${_money(l10n, paid)}';
              final paymentOk = total > 0 && paid >= 0 && paid <= total;
              return Card(
                clipBehavior: Clip.antiAlias,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    ListTile(
                      title: Text(l10n.ordersComposerPaymentTitle),
                      subtitle: Text(paymentSubtitle),
                      leading: PrideColoredLeading(
                        icon: Icons.payments_outlined,
                        color: Theme.of(context)
                            .extension<PrideActionColors>()!
                            .payment,
                      ),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => _openPaymentSheet(context),
                    ),
                    if (!paymentOk)
                      _composerRequiredHint(
                        l10n.ordersComposerPaymentRequired,
                      ),
                  ],
                ),
              );
            },
          ),
          const SizedBox(height: _kComposerSectionGap),
          if (_selectedCustomerId != null)
            _ComposerRecentOrdersCard(
              customerId: _selectedCustomerId!,
              l10n: l10n,
              money: _money,
            ),
        ],
      ),
      bottomNavigationBar: PrideFormBottomBar(
        onCancel: () => context.pop(),
        cancelLabel: MaterialLocalizations.of(context).cancelButtonLabel,
        primary: FilledButton.icon(
          onPressed: () => _onSavePressed(context, l10n),
          style: prideButtonStyle(context, PrideButtonVariant.add),
          icon: const Icon(Icons.check),
          label: Text(l10n.ordersComposerSaveCta),
        ),
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
        final recent = orders
            .where((o) => o.customerInternalId == customerId)
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
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.go('/app/orders/${o.internalId}'),
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

