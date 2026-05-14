import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/app_date_picker.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';

class OrderComposerScreen extends ConsumerStatefulWidget {
  const OrderComposerScreen({super.key});

  @override
  ConsumerState<OrderComposerScreen> createState() => _OrderComposerScreenState();
}

class _OrderComposerScreenState extends ConsumerState<OrderComposerScreen> {
  String? _selectedCustomerId;
  String? _selectedCustomerLabel;
  String? _selectedCustomerName;
  String? _selectedCustomerPhone;

  String? _measurementSourceProfileId;
  String _measurementSourceProfileLabel = '';
  List<OrderMeasurementSnapshotItemInput> _measurementSnapshotItems = [];

  final _measurementsController = TextEditingController();
  final _styleController = TextEditingController();

  final _totalController = TextEditingController();
  final _paidController = TextEditingController();

  DateTime? _deliveryDate;
  int _expanded = 0;

  @override
  void dispose() {
    _measurementsController.dispose();
    _styleController.dispose();
    _totalController.dispose();
    _paidController.dispose();
    super.dispose();
  }

  bool get _canSave {
    final total = int.tryParse(_totalController.text.trim());
    final paid = int.tryParse(_paidController.text.trim()) ?? 0;
    if (_selectedCustomerId == null) return false;
    if (_measurementsController.text.trim().isEmpty) return false;
    if (_styleController.text.trim().isEmpty) return false;
    if (_deliveryDate == null) return false;
    if (total == null || total <= 0) return false;
    if (paid < 0) return false;
    if (paid > total) return false;
    return true;
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
    setState(() => _deliveryDate = DateTime(picked.year, picked.month, picked.day));
  }

  Future<void> _confirmReset(BuildContext context, AppLocalizations l10n) async {
    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.ordersComposerResetTitle),
        content: Text(l10n.ordersComposerResetBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.resetCta),
          ),
        ],
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
      _styleController.clear();
      _totalController.clear();
      _paidController.clear();
      _deliveryDate = null;
      _expanded = 0;
    });
  }

  Future<void> _save(BuildContext context, AppLocalizations l10n) async {
    final license = ref.read(licenseNotifierProvider);
    if (license.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.licenseExpiredReadOnly)),
      );
      return;
    }

    final customerId = _selectedCustomerId!;
    final totalMinor = int.parse(_totalController.text.trim());
    final paidMinor = int.tryParse(_paidController.text.trim()) ?? 0;
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
      styleNotes: _styleController.text.trim(),
      customerSnapshotName: _selectedCustomerName,
      customerSnapshotPhone: _selectedCustomerPhone,
      sourceMeasurementProfileId: _measurementSourceProfileId,
      sourceMeasurementProfileLabel: _measurementSourceProfileLabel,
      measurementSnapshotItems:
          _measurementSnapshotItems.isEmpty ? null : _measurementSnapshotItems,
    );

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
        'style_notes': _styleController.text.trim(),
        if (_selectedCustomerName != null && _selectedCustomerName!.trim().isNotEmpty)
          'customer_snapshot_name': _selectedCustomerName!.trim(),
        if (_selectedCustomerPhone != null && _selectedCustomerPhone!.trim().isNotEmpty)
          'customer_snapshot_phone': _selectedCustomerPhone!.trim(),
        if (_measurementSourceProfileId != null &&
            _measurementSourceProfileId!.trim().isNotEmpty)
          'source_measurement_profile_id': _measurementSourceProfileId!.trim(),
        'source_measurement_profile_label': _measurementSourceProfileLabel.trim(),
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
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.ordersComposerSaved)),
    );
    context.go('/app/orders/$orderId');
  }

  String _money(AppLocalizations l10n, int minor) {
    final fmt = NumberFormat.decimalPattern();
    return l10n.moneyAfn(fmt.format(minor));
  }

  Widget _summaryRow(String label, String value) {
    return Row(
      children: [
        Expanded(child: Text(label, style: const TextStyle(fontWeight: FontWeight.w600))),
        const SizedBox(width: 12),
        Flexible(child: Text(value, textAlign: TextAlign.end)),
      ],
    );
  }

  Future<void> _pickMeasurementProfile(
    BuildContext context,
    AppLocalizations l10n,
    List<MeasurementProfileSummary> profiles,
  ) async {
    final picked = await showModalBottomSheet<MeasurementProfileSummary>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(
                title: Text(l10n.measurementProfilePickSheetTitle),
              ),
              const Divider(height: 1),
              for (final p in profiles)
                ListTile(
                  title: Text(p.label),
                  subtitle: Text(
                    p.displayMeasurementsText,
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                  onTap: () => Navigator.pop(ctx, p),
                ),
            ],
          ),
        );
      },
    );
    if (!mounted || picked == null) return;
    var order = 0;
    final items = <OrderMeasurementSnapshotItemInput>[];
    for (final line in picked.lines) {
      if (line.value.trim().isEmpty) continue;
      order += 10;
      items.add(
        OrderMeasurementSnapshotItemInput(
          measurementTypeInternalId: line.measurementTypeInternalId,
          typeName: line.typeName,
          value: line.value.trim(),
          unitCode: line.unitCode,
          sortOrder: order,
        ),
      );
    }
    setState(() {
      _measurementsController.text = picked.displayMeasurementsText;
      _measurementSourceProfileId = picked.internalId;
      _measurementSourceProfileLabel = picked.label;
      _measurementSnapshotItems = items;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final customersAsync = ref.watch(customersListStreamProvider);
    final ordersAsync = ref.watch(ordersListStreamProvider);
    final profilesAsync = _selectedCustomerId == null
        ? null
        : ref.watch(measurementProfilesForCustomerProvider(_selectedCustomerId!));

    final total = int.tryParse(_totalController.text.trim()) ?? 0;
    final paid = int.tryParse(_paidController.text.trim()) ?? 0;
    final remaining = total - paid;

    final deliveryLabel = _deliveryDate == null
        ? l10n.ordersComposerDeliveryDateUnset
        : AppCalendarFormat.mediumDate(l10n, calendar, _deliveryDate!, locale);

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.ordersNewTitle),
        actions: [
          TextButton(
            onPressed: () => _confirmReset(context, l10n),
            child: Text(l10n.resetCta),
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
        children: [
          ExpansionPanelList.radio(
            initialOpenPanelValue: _expanded,
            expandedHeaderPadding: EdgeInsets.zero,
            children: [
              ExpansionPanelRadio(
                value: 0,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  final subtitle = _selectedCustomerLabel ?? l10n.ordersComposerCustomerRequired;
                  return ListTile(
                    title: Text(l10n.ordersComposerCustomerTitle),
                    subtitle: Text(subtitle),
                    trailing: _selectedCustomerId == null
                        ? const Icon(Icons.warning_amber_outlined)
                        : const Icon(Icons.check_circle_outline),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: customersAsync.when(
                    data: (customers) => _CustomerPicker(
                      customers: customers,
                      selectedId: _selectedCustomerId,
                      onSelected: (c) {
                        setState(() {
                          _selectedCustomerId = c.internalId;
                          _selectedCustomerName = c.name;
                          _selectedCustomerPhone = c.phone;
                          _selectedCustomerLabel = c.phone == null
                              ? c.name
                              : '${c.name} • ${c.phone}';
                          _measurementSourceProfileId = null;
                          _measurementSourceProfileLabel = '';
                          _measurementSnapshotItems = [];
                          _measurementsController.clear();
                          _expanded = 1;
                        });
                      },
                      onAddNew: () => context.push('/app/customers/new'),
                      l10n: l10n,
                    ),
                    loading: () => const Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: LinearProgressIndicator(),
                    ),
                    error: (e, st) => Text(l10n.genericError),
                  ),
                ),
              ),
              ExpansionPanelRadio(
                value: 1,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  final subtitle = _measurementsController.text.trim().isEmpty
                      ? l10n.ordersComposerMeasurementsRequired
                      : l10n.ordersComposerMeasurementsSummary;
                  return ListTile(
                    title: Text(l10n.ordersComposerMeasurementsTitle),
                    subtitle: Text(subtitle),
                    trailing: _measurementsController.text.trim().isEmpty
                        ? const Icon(Icons.warning_amber_outlined)
                        : const Icon(Icons.check_circle_outline),
                    onTap: () {
                      if (_selectedCustomerId == null) {
                        showDialog<void>(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text(l10n.ordersComposerSelectCustomerFirstTitle),
                            content: Text(l10n.ordersComposerSelectCustomerFirstBody),
                            actions: [
                              TextButton(
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text(MaterialLocalizations.of(context).okButtonLabel),
                              ),
                            ],
                          ),
                        );
                      }
                    },
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (profilesAsync != null)
                        profilesAsync.when(
                          data: (profiles) {
                            if (profiles.isEmpty) {
                              return const SizedBox.shrink();
                            }
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                OutlinedButton.icon(
                                  onPressed: () => _pickMeasurementProfile(
                                    context,
                                    l10n,
                                    profiles,
                                  ),
                                  icon: const Icon(Icons.folder_open_outlined),
                                  label: Text(l10n.ordersComposerLoadProfileCta),
                                ),
                                if (_measurementSourceProfileLabel.isNotEmpty)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: InputChip(
                                        label: Text(
                                          l10n.ordersComposerProfileLinked(
                                            _measurementSourceProfileLabel,
                                          ),
                                        ),
                                        deleteIcon: const Icon(Icons.close, size: 18),
                                        onDeleted: () {
                                          setState(() {
                                            _measurementSourceProfileId = null;
                                            _measurementSourceProfileLabel = '';
                                            _measurementSnapshotItems = [];
                                          });
                                        },
                                      ),
                                    ),
                                  ),
                                const SizedBox(height: 12),
                              ],
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.only(bottom: 12),
                            child: LinearProgressIndicator(),
                          ),
                          error: (_, _) => const SizedBox.shrink(),
                        ),
                      TextField(
                        controller: _measurementsController,
                        minLines: 2,
                        maxLines: 6,
                        decoration: InputDecoration(
                          labelText: l10n.ordersComposerMeasurementsLabel,
                          hintText: l10n.ordersComposerMeasurementsHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                    ],
                  ),
                ),
              ),
              ExpansionPanelRadio(
                value: 2,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  final subtitle = _styleController.text.trim().isEmpty
                      ? l10n.ordersComposerStyleRequired
                      : _styleController.text.trim();
                  return ListTile(
                    title: Text(l10n.ordersComposerStyleTitle),
                    subtitle: Text(subtitle),
                    trailing: _styleController.text.trim().isEmpty
                        ? const Icon(Icons.warning_amber_outlined)
                        : const Icon(Icons.check_circle_outline),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: TextField(
                    controller: _styleController,
                    decoration: InputDecoration(
                      labelText: l10n.ordersComposerStyleLabel,
                      hintText: l10n.ordersComposerStyleHint,
                      border: const OutlineInputBorder(),
                    ),
                    onChanged: (_) => setState(() {}),
                  ),
                ),
              ),
              ExpansionPanelRadio(
                value: 3,
                canTapOnHeader: true,
                headerBuilder: (context, isExpanded) {
                  final subtitle = total <= 0
                      ? l10n.ordersComposerPaymentRequired
                      : l10n.ordersComposerPaymentSummary(
                          _money(l10n, total),
                          _money(l10n, paid),
                          _money(l10n, remaining),
                        );
                  final ok = total > 0 && paid >= 0 && paid <= total;
                  return ListTile(
                    title: Text(l10n.ordersComposerPaymentTitle),
                    subtitle: Text(subtitle),
                    trailing: ok ? const Icon(Icons.check_circle_outline) : const Icon(Icons.warning_amber_outlined),
                  );
                },
                body: Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                  child: Column(
                    children: [
                      TextField(
                        controller: _totalController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.ordersComposerTotalLabel,
                          hintText: l10n.ordersComposerTotalHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
                      ),
                      const SizedBox(height: 12),
                      TextField(
                        controller: _paidController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          labelText: l10n.ordersComposerPaidLabel,
                          hintText: l10n.ordersComposerPaidHint,
                          border: const OutlineInputBorder(),
                        ),
                        onChanged: (_) => setState(() {}),
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
                              _summaryRow(l10n.paymentRemaining, _money(l10n, remaining)),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        leading: const Icon(Icons.event_outlined),
                        title: Text(l10n.ordersComposerDeliveryDateTitle),
                        subtitle: Text(deliveryLabel),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => _pickDeliveryDate(context),
                      ),
                    ],
                  ),
                ),
              ),
            ],
            expansionCallback: (i, isExpanded) {
              setState(() => _expanded = i);
            },
          ),
          const SizedBox(height: 16),
          if (_selectedCustomerId != null)
            ordersAsync.when(
              data: (orders) {
                final recent = orders
                    .where((o) => o.customerInternalId == _selectedCustomerId)
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
                              _money(l10n, o.remainingAmountMinor),
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
            ),
        ],
      ),
      bottomNavigationBar: SafeArea(
        minimum: const EdgeInsets.all(16),
        child: FilledButton.icon(
          onPressed: _canSave ? () => _save(context, l10n) : null,
          icon: const Icon(Icons.check),
          label: Text(l10n.ordersComposerSaveCta),
        ),
      ),
    );
  }
}

class _CustomerPicker extends StatefulWidget {
  const _CustomerPicker({
    required this.customers,
    required this.selectedId,
    required this.onSelected,
    required this.onAddNew,
    required this.l10n,
  });

  final List<CustomerSummary> customers;
  final String? selectedId;
  final ValueChanged<CustomerSummary> onSelected;
  final VoidCallback onAddNew;
  final AppLocalizations l10n;

  @override
  State<_CustomerPicker> createState() => _CustomerPickerState();
}

class _CustomerPickerState extends State<_CustomerPicker> {
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final q = _search.text.trim().toLowerCase();
    final list = widget.customers.where((c) {
      if (q.isEmpty) return true;
      final phone = (c.phone ?? '').toLowerCase();
      return c.name.toLowerCase().contains(q) || phone.contains(q);
    }).toList()
      ..sort((a, b) => a.name.compareTo(b.name));

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        TextField(
          controller: _search,
          decoration: InputDecoration(
            prefixIcon: const Icon(Icons.search),
            hintText: widget.l10n.customersSearchHint,
            border: const OutlineInputBorder(),
          ),
          onChanged: (_) => setState(() {}),
        ),
        const SizedBox(height: 12),
        OutlinedButton.icon(
          onPressed: widget.onAddNew,
          icon: const Icon(Icons.person_add_alt_1),
          label: Text(widget.l10n.customersAddCta),
        ),
        const SizedBox(height: 12),
        if (list.isEmpty)
          Text(widget.l10n.customersFilteredEmpty)
        else
          ...list.map(
            (c) => ListTile(
              leading: widget.selectedId == c.internalId
                  ? const Icon(Icons.check_circle)
                  : const Icon(Icons.radio_button_unchecked),
              title: Text(c.name),
              subtitle: Text(c.phone ?? widget.l10n.customersPhoneMissing),
              onTap: () => widget.onSelected(c),
            ),
          ),
      ],
    );
  }
}

