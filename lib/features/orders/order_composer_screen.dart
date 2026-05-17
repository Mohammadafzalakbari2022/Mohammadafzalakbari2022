import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_close_button.dart';
import 'package:pride_v3/core/widgets/pride_form_bottom_bar.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/core/widgets/pride_alert_dialog.dart';
import 'package:pride_v3/core/printing/thermal_print_order.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../customers/new_customer_screen.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import '../../data/local/style/style_order_selection.dart';
import 'order_composer_customer_picker.dart';
import 'order_composer_measurements_sheet.dart';
import 'order_composer_progress_header.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_composer_style_sheet.dart';
import 'order_invoice_share.dart';
import 'order_status_label.dart';

class OrderComposerScreen extends ConsumerStatefulWidget {
  const OrderComposerScreen({super.key});

  @override
  ConsumerState<OrderComposerScreen> createState() => _OrderComposerScreenState();
}

const _kComposerSectionGap = 14.0;

class _OrderComposerScreenState extends ConsumerState<OrderComposerScreen> {
  final _customerSearchController = TextEditingController();

  String? _selectedCustomerId;
  String? _selectedCustomerLabel;
  String? _selectedCustomerName;
  String? _selectedCustomerPhone;

  String? _measurementSourceProfileId;
  String _measurementSourceProfileLabel = '';
  List<OrderMeasurementSnapshotItemInput> _measurementSnapshotItems = [];

  final _measurementsController = TextEditingController();

  final _totalController = TextEditingController();
  final _paidController = TextEditingController();

  String _styleName = '';
  String? _styleNameInternalId;
  StyleOrderSelection _styleSelection = const StyleOrderSelection.empty();
  String _styleSummary = '';

  String? _catalogItemInternalId;
  String _catalogDesignName = '';
  String _catalogDesignerShopName = '';
  String? _catalogImagePath;
  String? _catalogThumbnailPath;

  String _fabricName = '';
  String _fabricColor = '';
  String _fabricId = '';
  String? _fabricNamePresetInternalId;
  String? _fabricColorPresetInternalId;

  DateTime? _deliveryDate;

  bool get _hasFabric =>
      _fabricName.trim().isNotEmpty ||
      _fabricColor.trim().isNotEmpty ||
      _fabricId.trim().isNotEmpty;

  @override
  void initState() {
    super.initState();
    void onPaymentFieldsChanged() {
      if (mounted) setState(() {});
    }
    _totalController.addListener(onPaymentFieldsChanged);
    _paidController.addListener(onPaymentFieldsChanged);
  }

  @override
  void dispose() {
    _customerSearchController.dispose();
    _measurementsController.dispose();
    _totalController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  bool get _canSave {
    final total = tryParseMoneyAmount(_totalController.text);
    final paid = tryParseMoneyAmount(_paidController.text) ?? 0;
    if (_selectedCustomerId == null) return false;
    if (_measurementsController.text.trim().isEmpty) return false;
    if (_styleName.trim().isEmpty) return false;
    if (_deliveryDate == null) return false;
    if (total == null || total <= 0) return false;
    if (paid < 0) return false;
    if (paid > total) return false;
    return true;
  }

  void _applyCustomer(CustomerSummary c) {
    setState(() {
      _selectedCustomerId = c.internalId;
      _selectedCustomerName = c.name;
      _selectedCustomerPhone = c.phone;
      _selectedCustomerLabel =
          c.phone == null ? c.name : '${c.name} • ${c.phone}';
      _measurementSourceProfileId = null;
      _measurementSourceProfileLabel = '';
      _measurementSnapshotItems = [];
      _measurementsController.clear();
      _styleName = '';
      _styleNameInternalId = null;
      _styleSelection = const StyleOrderSelection.empty();
      _styleSummary = '';
      _catalogItemInternalId = null;
      _catalogDesignName = '';
      _catalogDesignerShopName = '';
      _catalogImagePath = null;
      _catalogThumbnailPath = null;
      _fabricName = '';
      _fabricColor = '';
      _fabricId = '';
      _fabricNamePresetInternalId = null;
      _fabricColorPresetInternalId = null;
    });
  }

  void _clearSelectedCustomer() {
    setState(() {
      _selectedCustomerId = null;
      _selectedCustomerLabel = null;
      _selectedCustomerName = null;
      _selectedCustomerPhone = null;
      _measurementSourceProfileId = null;
      _measurementSourceProfileLabel = '';
      _measurementSnapshotItems = [];
      _measurementsController.clear();
    });
  }

  Future<void> _openStyleSheet(BuildContext context) async {
    final result = await showOrderComposerStyleSheet(
      context: context,
      ref: ref,
      initialMainStyle: _styleName,
      initialStyleNameInternalId: _styleNameInternalId,
      initialSelection: _styleSelection,
      initialCatalogItemInternalId: _catalogItemInternalId,
      initialCatalogDesignName: _catalogDesignName,
      initialCatalogDesignerShopName: _catalogDesignerShopName,
      initialCatalogImagePath: _catalogImagePath,
      initialCatalogThumbnailPath: _catalogThumbnailPath,
    );
    if (!mounted || result == null) return;
    setState(() {
      _styleName = result.mainStyleName;
      _styleNameInternalId = result.styleNameInternalId;
      _styleSelection = result.selection;
      _styleSummary = result.summary;
      _catalogItemInternalId = result.catalogItemInternalId;
      _catalogDesignName = result.catalogDesignName;
      _catalogDesignerShopName = result.catalogDesignerShopName;
      _catalogImagePath = result.catalogImagePath;
      _catalogThumbnailPath = result.catalogThumbnailPath;
    });
  }

  Future<void> _openFabricSheet(BuildContext context) async {
    final result = await showOrderComposerFabricSheet(
      context: context,
      initialName: _fabricName,
      initialColor: _fabricColor,
      initialFabricId: _fabricId,
      initialNamePresetId: _fabricNamePresetInternalId,
      initialColorPresetId: _fabricColorPresetInternalId,
    );
    if (!mounted) return;
    setState(() {
      if (result == null || result.isEmpty) {
        _fabricName = '';
        _fabricColor = '';
        _fabricId = '';
        _fabricNamePresetInternalId = null;
        _fabricColorPresetInternalId = null;
      } else {
        _fabricName = result.fabricName;
        _fabricColor = result.fabricColor;
        _fabricId = result.fabricId;
        _fabricNamePresetInternalId = result.fabricNamePresetInternalId;
        _fabricColorPresetInternalId = result.fabricColorPresetInternalId;
      }
    });
  }

  Future<void> _pickDeliveryDate(BuildContext context) async {
    final l10n = AppLocalizations.of(context)!;
    final now = DateTime.now();
    final initial = _deliveryDate ?? now.add(const Duration(days: 2));
    final calendar = ref.read(dateCalendarSystemProvider);
    final picked = await showAppDatePicker(
      context: context,
      l10n: l10n,
      system: calendar,
      initialDate: initial,
      firstDate: DateTime(now.year - 1),
      lastDate: DateTime(now.year + 3),
    );
    if (!mounted) return;
    if (picked == null) return;
    setState(
      () => _deliveryDate = DateTime(picked.year, picked.month, picked.day),
    );
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
      _selectedCustomerId = null;
      _selectedCustomerLabel = null;
      _selectedCustomerName = null;
      _selectedCustomerPhone = null;
      _measurementSourceProfileId = null;
      _measurementSourceProfileLabel = '';
      _measurementSnapshotItems = [];
      _measurementsController.clear();
      _totalController.clear();
      _paidController.clear();
      _deliveryDate = null;
      _styleName = '';
      _styleNameInternalId = null;
      _styleSelection = const StyleOrderSelection.empty();
      _styleSummary = '';
      _catalogItemInternalId = null;
      _catalogDesignName = '';
      _catalogDesignerShopName = '';
      _catalogImagePath = null;
      _catalogThumbnailPath = null;
      _fabricName = '';
      _fabricColor = '';
      _fabricId = '';
      _fabricNamePresetInternalId = null;
      _fabricColorPresetInternalId = null;
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

  Future<void> _openMeasurementsEditor(
    BuildContext context,
    AppLocalizations l10n,
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
    final r = await showOrderMeasurementsEditorSheet(
      context: context,
      ref: ref,
      l10n: l10n,
      shopId: shopId,
      customerId: _selectedCustomerId,
      initialSnapshotText: _measurementsController.text,
      initialItems: List<OrderMeasurementSnapshotItemInput>.of(
        _measurementSnapshotItems,
      ),
      initialProfileId: _measurementSourceProfileId,
      initialProfileLabel: _measurementSourceProfileLabel,
      profiles: profiles,
    );
    if (r == null || !mounted) return;
    setState(() {
      _measurementsController.text = r.measurementsSnapshot;
      _measurementSnapshotItems = r.measurementSnapshotItems;
      _measurementSourceProfileId = r.sourceMeasurementProfileId;
      _measurementSourceProfileLabel = r.sourceMeasurementProfileLabel;
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
    final totalMinor = tryParseMoneyAmount(_totalController.text)!;
    final paidMinor = tryParseMoneyAmount(_paidController.text) ?? 0;
    final deliveryDate = _deliveryDate!;

    final shopId =
        effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);

    final ordersRepo = await ref.read(orderListRepositoryProvider.future);
    final paymentsRepo = await ref.read(paymentRepositoryProvider.future);

    final orderId = await ordersRepo.createOrder(
      shopId: shopId,
      customerInternalId: customerId,
      deliveryDate: deliveryDate,
      totalAmountMinor: totalMinor,
      measurementsSnapshot: _measurementsController.text.trim(),
      customerSnapshotName: _selectedCustomerName,
      customerSnapshotPhone: _selectedCustomerPhone,
      sourceMeasurementProfileId: _measurementSourceProfileId,
      sourceMeasurementProfileLabel: _measurementSourceProfileLabel,
      measurementSnapshotItems:
          _measurementSnapshotItems.isEmpty ? null : _measurementSnapshotItems,
      styleName: _styleName.trim(),
      styleNameInternalId: _styleNameInternalId,
      styleSelectionJson: _styleSelection.toJsonString(),
      styleSummary: _styleSummary,
      catalogItemInternalId: _catalogItemInternalId,
      catalogDesignNameSnapshot: _catalogDesignName,
      catalogDesignerShopNameSnapshot: _catalogDesignerShopName,
      catalogSourceImagePath: _catalogImagePath,
      catalogSourceThumbnailPath: _catalogThumbnailPath,
      fabricNameSnapshot: _fabricName,
      fabricColorSnapshot: _fabricColor,
      fabricIdSnapshot: _fabricId,
      fabricNamePresetInternalId: _fabricNamePresetInternalId,
      fabricColorPresetInternalId: _fabricColorPresetInternalId,
    );

    if (_catalogDesignName.trim().isNotEmpty) {
      final customersRepo =
          await ref.read(customerListRepositoryProvider.future);
      await customersRepo.updateCustomerLastCatalogDesign(
        internalId: customerId,
        designName: _catalogDesignName.trim(),
        designerShopName: _catalogDesignerShopName.trim(),
        catalogItemInternalId: _catalogItemInternalId,
        thumbnailPath: _catalogThumbnailPath,
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
            if (customerRow.phone != null && customerRow.phone!.trim().isNotEmpty)
              'phone': customerRow.phone!.trim(),
            if (customerRow.address != null &&
                customerRow.address!.trim().isNotEmpty)
              'address': customerRow.address!.trim(),
            if (customerRow.notes != null && customerRow.notes!.trim().isNotEmpty)
              'notes': customerRow.notes!.trim(),
            'created_at': customerRow.createdAt.toUtc().toIso8601String(),
            'last_catalog_design_name': _catalogDesignName.trim(),
            if (_catalogDesignerShopName.trim().isNotEmpty)
              'last_catalog_designer_shop_name':
                  _catalogDesignerShopName.trim(),
            if (_catalogItemInternalId != null)
              'last_catalog_item_internal_id': _catalogItemInternalId,
            if (_catalogThumbnailPath != null &&
                _catalogThumbnailPath!.trim().isNotEmpty)
              'last_catalog_thumbnail_path': _catalogThumbnailPath!.trim(),
          }),
        );
      }
    }

    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.orderCreate,
      entityRef: orderId,
      shopId: shopId,
      payloadJson: jsonEncode({
        'customer_internal_id': customerId,
        'delivery_date': deliveryDate.toUtc().toIso8601String(),
        'total_amount_minor': totalMinor,
        'initial_paid_minor': paidMinor,
        'measurements_snapshot': _measurementsController.text.trim(),
        if (_selectedCustomerName != null &&
            _selectedCustomerName!.trim().isNotEmpty)
          'customer_snapshot_name': _selectedCustomerName!.trim(),
        if (_selectedCustomerPhone != null &&
            _selectedCustomerPhone!.trim().isNotEmpty)
          'customer_snapshot_phone': _selectedCustomerPhone!.trim(),
        if (_measurementSourceProfileId != null &&
            _measurementSourceProfileId!.trim().isNotEmpty)
          'source_measurement_profile_id': _measurementSourceProfileId!.trim(),
        'source_measurement_profile_label':
            _measurementSourceProfileLabel.trim(),
        'style_name': _styleName.trim(),
        if (_styleNameInternalId != null &&
            _styleNameInternalId!.trim().isNotEmpty)
          'style_name_internal_id': _styleNameInternalId!.trim(),
        if (_styleSelection.selectedFigureIds.isNotEmpty)
          'style_selection_json': _styleSelection.toJsonString(),
        if (_styleSummary.trim().isNotEmpty)
          'style_summary': _styleSummary.trim(),
        if (_catalogItemInternalId != null)
          'catalog_item_internal_id': _catalogItemInternalId,
        if (_catalogDesignName.trim().isNotEmpty)
          'catalog_design_name_snapshot': _catalogDesignName.trim(),
        if (_catalogDesignerShopName.trim().isNotEmpty)
          'catalog_designer_shop_name_snapshot':
              _catalogDesignerShopName.trim(),
        if (_hasFabric) ...{
          if (_fabricName.trim().isNotEmpty)
            'fabric_name': _fabricName.trim(),
          if (_fabricColor.trim().isNotEmpty)
            'fabric_color': _fabricColor.trim(),
          if (_fabricId.trim().isNotEmpty) 'fabric_id': _fabricId.trim(),
          if (_fabricNamePresetInternalId != null &&
              _fabricNamePresetInternalId!.trim().isNotEmpty)
            'fabric_name_preset_internal_id':
                _fabricNamePresetInternalId!.trim(),
          if (_fabricColorPresetInternalId != null &&
              _fabricColorPresetInternalId!.trim().isNotEmpty)
            'fabric_color_preset_internal_id':
                _fabricColorPresetInternalId!.trim(),
        },
      }),
    );

    if (paidMinor > 0) {
      final paymentId = const Uuid().v4();
      await paymentsRepo.addPayment(
        shopId: shopId,
        orderInternalId: orderId,
        amountMinor: paidMinor,
        method: 'cash',
        isAdjustment: false,
        internalId: paymentId,
      );
      recordSyncOutboxMutation(
        ref,
        kind: SyncOutboxKinds.paymentAppend,
        entityRef: paymentId,
        shopId: shopId,
        payloadJson: jsonEncode({
          'order_internal_id': orderId,
          'amount_minor': paidMinor,
          'method': 'cash',
          'is_adjustment': false,
          'created_at': DateTime.now().toUtc().toIso8601String(),
        }),
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
    final fmt = NumberFormat.decimalPattern();
    return l10n.moneyAfn(fmt.format(minor));
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
    if (_measurementsController.text.trim().isEmpty) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.straighten,
          iconColor: prideSettingsIconColor(1),
          label: l10n.ordersComposerMeasurementsRequired,
        ),
      );
    }
    if (_styleName.trim().isEmpty) {
      missing.add(
        PrideAlertDialogBullet(
          icon: Icons.checkroom_outlined,
          iconColor: prideSettingsIconColor(2),
          label: l10n.ordersComposerStyleRequired,
        ),
      );
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
    final total = tryParseMoneyAmount(_totalController.text);
    final paid = tryParseMoneyAmount(_paidController.text) ?? 0;
    if (total == null || total <= 0 || paid < 0 || paid > total) {
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

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(
          child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ),
        const SizedBox(width: 12),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final total = tryParseMoneyAmount(_totalController.text) ?? 0;
    final paid = tryParseMoneyAmount(_paidController.text) ?? 0;
    final remaining = total - paid;

    final deliveryLabel = _deliveryDate == null
        ? l10n.ordersComposerDeliveryDateUnset
        : AppCalendarFormat.mediumDate(l10n, calendar, _deliveryDate!, locale);

    final customerSubtitle =
        _selectedCustomerLabel ?? l10n.ordersComposerCustomerRequired;
    final measurementsSubtitle = _measurementsController.text.trim().isEmpty
        ? l10n.ordersComposerMeasurementsRequired
        : l10n.ordersComposerMeasurementsSummary;
    final styleSubtitle = _styleName.trim().isEmpty
        ? l10n.ordersComposerStyleRequired
        : (_catalogDesignName.trim().isNotEmpty
            ? '${_styleSummary.trim().isNotEmpty ? _styleSummary.trim().split('\n').first : _styleName.trim()} · ${_catalogDesignName.trim()}'
            : (_styleSummary.trim().isNotEmpty
                ? _styleSummary.trim().split('\n').first
                : _styleName.trim()));
    final fabricSubtitle = !_hasFabric
        ? l10n.ordersComposerFabricUnset
        : (_fabricId.trim().isNotEmpty &&
                _fabricName.trim().isNotEmpty &&
                _fabricColor.trim().isNotEmpty
            ? l10n.ordersComposerFabricSummary(
                _fabricName.trim(),
                _fabricColor.trim(),
                _fabricId.trim(),
              )
            : l10n.ordersComposerFabricPartialSummary(
                _fabricName.trim().isEmpty ? '—' : _fabricName.trim(),
                _fabricColor.trim().isEmpty ? '—' : _fabricColor.trim(),
              ));
    final paymentSubtitle = total <= 0
        ? l10n.ordersComposerPaymentRequired
        : l10n.ordersComposerPaymentSummary(
            _money(l10n, total),
            _money(l10n, paid),
            _money(l10n, remaining),
          );
    final paymentOk = total > 0 && paid >= 0 && paid <= total;

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
          OrderComposerProgressHeader(
            l10n: l10n,
            customerDone: _selectedCustomerId != null,
            measurementsDone: _measurementsController.text.trim().isNotEmpty,
            styleDone: _styleName.trim().isNotEmpty,
            fabricDone: _hasFabric,
            deliveryDone: _deliveryDate != null,
            paymentDone: paymentOk,
          ),
          const SizedBox(height: _kComposerSectionGap),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(12, 12, 12, 0),
                  child: TextField(
                    controller: _customerSearchController,
                    decoration: InputDecoration(
                      prefixIcon: const Icon(Icons.search),
                      hintText: l10n.customersSearchHint,
                      isDense: true,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                    onSubmitted: (_) {
                      final q = _customerSearchController.text.trim();
                      if (q.isEmpty) {
                        _pickExistingCustomer(context, l10n);
                        return;
                      }
                      final customers =
                          ref.read(customersListStreamProvider).valueOrNull ??
                              const <CustomerSummary>[];
                      final lower = q.toLowerCase();
                      for (final c in customers) {
                        final phone = (c.phone ?? '').toLowerCase();
                        if (c.name.toLowerCase().contains(lower) ||
                            phone.contains(lower)) {
                          _applyCustomer(c);
                          return;
                        }
                      }
                      _pickExistingCustomer(context, l10n);
                    },
                  ),
                ),
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
                  title: Text(l10n.ordersComposerMeasurementsTitle),
                  subtitle: Text(measurementsSubtitle),
                  leading: PrideColoredLeading(
                    icon: Icons.straighten,
                    color: prideSettingsIconColor(1),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openMeasurementsEditor(context, l10n),
                ),
                if (_measurementsController.text.trim().isEmpty)
                  _composerRequiredHint(l10n.ordersComposerMeasurementsRequired),
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
                  title: Text(l10n.ordersComposerStyleTitle),
                  subtitle: Text(styleSubtitle, maxLines: 3),
                  isThreeLine: styleSubtitle.length > 48,
                  leading: PrideColoredLeading(
                    icon: Icons.checkroom_outlined,
                    color: prideSettingsIconColor(2),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openStyleSheet(context),
                ),
                if (_styleName.trim().isEmpty)
                  _composerRequiredHint(l10n.ordersComposerStyleRequired),
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
                  title: Text(l10n.ordersComposerFabricTitle),
                  subtitle: Text(fabricSubtitle, maxLines: 2),
                  isThreeLine: fabricSubtitle.length > 48,
                  leading: PrideColoredLeading(
                    icon: Icons.texture_outlined,
                    color: prideSettingsIconColor(3),
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _openFabricSheet(context),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
                  child: Text(
                    l10n.ordersComposerFabricOptional,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                ),
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
                  leading: PrideColoredLeading(
                    icon: Icons.event_outlined,
                    color: prideSettingsIconColor(4),
                  ),
                  title: Text(l10n.ordersComposerDeliveryDateTitle),
                  subtitle: Text(deliveryLabel),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => _pickDeliveryDate(context),
                ),
                if (_deliveryDate == null)
                  _composerRequiredHint(l10n.ordersComposerDeliveryDateUnset),
              ],
            ),
          ),
          const SizedBox(height: _kComposerSectionGap),
          Card(
            clipBehavior: Clip.antiAlias,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 12),
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
                  ),
                  if (!paymentOk)
                    _composerRequiredHint(l10n.ordersComposerPaymentRequired),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: Column(
                      children: [
                        PrideMoneyField(
                          controller: _totalController,
                          labelText: l10n.ordersComposerTotalLabel,
                          hintText: l10n.ordersComposerTotalHint,
                          textInputAction: TextInputAction.next,
                        ),
                        const SizedBox(height: 12),
                        PrideMoneyField(
                          controller: _paidController,
                          labelText: l10n.ordersComposerPaidLabel,
                          hintText: l10n.ordersComposerPaidHint,
                        ),
                        const SizedBox(height: 12),
                        Card(
                          clipBehavior: Clip.antiAlias,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              children: [
                                _summaryRow(l10n.paymentTotal, _money(l10n, total)),
                                const SizedBox(height: 6),
                                _summaryRow(l10n.paymentPaid, _money(l10n, paid)),
                                const SizedBox(height: 6),
                                _summaryRow(
                                  l10n.paymentRemaining,
                                  _money(l10n, remaining),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
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
                      money(l10n, o.remainingAmountMinor),
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

