import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:pride_v3/core/widgets/pride_carved_section.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/customer_summary.dart';
import '../../data/local/measurement_profile_item_input.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/measurement_unit_codes.dart';
import '../../data/local/sync_outbox_kinds.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../../shell/shell_sync_providers.dart';
import '../orders/order_list_tile.dart';
import 'customer_profile_hero_card.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key, required this.customerId});

  final String customerId;

  Future<void> _editCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    required String customerId,
    required DateTime customerCreatedAt,
    required String currentName,
    required String? currentPhone,
    required String? currentAddress,
  }) async {
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

    final nameCtrl = TextEditingController(text: currentName);
    final phoneCtrl = TextEditingController(text: currentPhone ?? '');
    final addressCtrl = TextEditingController(text: currentAddress ?? '');

    final ok = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.customerEditDialogTitle),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameCtrl,
                decoration: InputDecoration(
                  labelText: l10n.customerNameLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: phoneCtrl,
                keyboardType: TextInputType.phone,
                decoration: InputDecoration(
                  labelText: l10n.customerPhoneLabel,
                  border: const OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: addressCtrl,
                maxLines: 2,
                decoration: InputDecoration(
                  labelText: l10n.customerAddressLabel,
                  hintText: l10n.customerAddressHint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: prideDialogCancelSave(
          context: context,
          onCancel: () => Navigator.of(context).pop(false),
          onConfirm: () => Navigator.of(context).pop(true),
          saveLabel: l10n.saveCta,
        ),
      ),
    );

    if (ok != true) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      return;
    }
    final nextName = nameCtrl.text.trim();
    if (nextName.isEmpty) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      return;
    }

    final phoneText = phoneCtrl.text;
    final addressText = addressCtrl.text;
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();

    final repo = await ref.read(customerListRepositoryProvider.future);
    await repo.updateCustomer(
      internalId: customerId,
      name: nextName,
      phone: phoneText,
      address: addressText,
      notes: '',
    );

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.customerUpsert,
      entityRef: customerId,
      shopId: shopId,
      payloadJson: jsonEncode({
        'name': nextName,
        if (phoneText.trim().isNotEmpty) 'phone': phoneText.trim(),
        if (addressText.trim().isNotEmpty) 'address': addressText.trim(),
        'created_at': customerCreatedAt.toUtc().toIso8601String(),
      }),
    );

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.customerUpdated,
    );
  }

  Future<void> _deleteCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
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

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customerDeleteConfirmTitle),
        content: Text(l10n.customerDeleteConfirmBody),
        actions: prideDialogCancelDelete(
          context: ctx,
          onCancel: () => Navigator.pop(ctx, false),
          onConfirm: () => Navigator.pop(ctx, true),
          deleteLabel: l10n.deleteCta,
        ),
      ),
    );
    if (ok != true || !context.mounted) return;

    final shopId = ref.read(effectiveShopIdProvider);
    recordSyncOutboxMutation(
      ref,
      kind: SyncOutboxKinds.customerDelete,
      entityRef: customerId,
      shopId: shopId,
    );

    final repo = await ref.read(customerListRepositoryProvider.future);
    await repo.softDeleteCustomer(customerId);

    if (!context.mounted) return;
    showAppFeedback(
      context,
      ref,
      kind: AppFeedbackKind.success,
      message: l10n.customerDeleted,
      deleted: true,
    );
    context.go('/app/customers');
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);

    final asyncCustomers = ref.watch(customersListStreamProvider);
    final asyncOrders = ref.watch(ordersListStreamProvider);

    return asyncCustomers.when(
      data: (customers) {
        CustomerSummary? found;
        for (final c in customers) {
          if (c.internalId == customerId) {
            found = c;
            break;
          }
        }
        if (found == null) {
          return Scaffold(
            appBar: AppBar(
              leading: IconButton(
                icon: const Icon(Icons.close),
                onPressed: () => context.pop(),
              ),
              title: Text(l10n.customerProfileTitle),
            ),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  l10n.customerNotFound,
                  textAlign: TextAlign.center,
                ),
              ),
            ),
          );
        }

        final c = found;
        final customerName = c.name;
        final customerPhone = c.phone;
        final customerAddress = c.address;
        final ordersList = asyncOrders.asData?.value ?? const [];
        var orderCount = 0;
        var unpaidMinor = 0;
        for (final o in ordersList) {
          if (o.customerInternalId != customerId) continue;
          orderCount++;
          if (o.isUnpaid) unpaidMinor += o.remainingAmountMinor;
        }
        String formatMoney(int minor) =>
            l10n.moneyAfn(NumberFormat.decimalPattern().format(minor));

        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.close),
              onPressed: () => context.pop(),
            ),
            title: Text(customerName),
            actions: [
              IconButton(
                icon: const Icon(Icons.edit_outlined),
                tooltip: l10n.editCta,
                onPressed: () => _editCustomer(
                  context,
                  ref,
                  l10n,
                  customerId: customerId,
                  customerCreatedAt: c.createdAt,
                  currentName: customerName,
                  currentPhone: customerPhone,
                  currentAddress: customerAddress,
                ),
              ),
              PopupMenuButton<String>(
                onSelected: (value) {
                  if (value == 'delete') {
                    _deleteCustomer(context, ref, l10n);
                  }
                },
                itemBuilder: (ctx) => [
                  PopupMenuItem(
                    value: 'delete',
                    child: Text(l10n.customerDeleteMenu),
                  ),
                ],
              ),
            ],
          ),
          body: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              CustomerProfileHeroCard(
                customer: c,
                l10n: l10n,
                locale: locale,
                calendar: calendar,
                orderCount: orderCount,
                unpaidMinor: unpaidMinor,
                formatMoney: formatMoney,
              ),
              PrideCarvedSection(
                title: l10n.customerMeasurementProfilesSection,
                initiallyExpanded: false,
                child: ref
                        .watch(measurementProfilesForCustomerProvider(customerId))
                        .when(
                          data: (profiles) {
                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                if (profiles.isEmpty)
                                  Text(l10n.measurementProfilesEmpty),
                                for (final p in profiles)
                                  ListTile(
                                    contentPadding: EdgeInsets.zero,
                                    title: Text(p.label),
                                    subtitle: Text(
                                      p.displayMeasurementsText.isEmpty
                                          ? '—'
                                          : p.displayMeasurementsText,
                                      maxLines: 4,
                                      overflow: TextOverflow.ellipsis,
                                    ),
                                    trailing: IconButton(
                                      icon: const Icon(Icons.edit_outlined),
                                      onPressed: () =>
                                          _openMeasurementProfileEditor(
                                        context,
                                        ref,
                                        l10n,
                                        customerId: customerId,
                                        existing: p,
                                      ),
                                    ),
                                    onTap: () => _openMeasurementProfileEditor(
                                      context,
                                      ref,
                                      l10n,
                                      customerId: customerId,
                                      existing: p,
                                    ),
                                  ),
                                const SizedBox(height: 8),
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: FilledButton.icon(
                                    style: prideButtonStyle(
                                      context,
                                      PrideButtonVariant.add,
                                    ),
                                    onPressed: () => _openMeasurementProfileEditor(
                                      context,
                                      ref,
                                      l10n,
                                      customerId: customerId,
                                      existing: null,
                                    ),
                                    icon: const Icon(Icons.add),
                                    label: Text(l10n.measurementProfilesAddCta),
                                  ),
                                ),
                              ],
                            );
                          },
                          loading: () => const Padding(
                            padding: EdgeInsets.symmetric(vertical: 16),
                            child: Center(child: CircularProgressIndicator()),
                          ),
                          error: (e, _) => Text('$e'),
                        ),
              ),
              asyncOrders.when(
                data: (orders) {
                  final history = orders
                      .where((o) => o.customerInternalId == customerId)
                      .toList()
                    ..sort((a, b) => b.createdAt.compareTo(a.createdAt));

                  return PrideCarvedSection(
                    title: l10n.customerOrderHistoryTitle,
                    subtitle: history.isEmpty
                        ? l10n.customerNoOrders
                        : l10n.customersRowMeta(
                            history.length,
                            unpaidMinor > 0
                                ? l10n.ordersRemainingChip(
                                    formatMoney(unpaidMinor),
                                  )
                                : formatMoney(0),
                          ),
                    child: history.isEmpty
                        ? Text(l10n.customerNoOrders)
                        : Column(
                            children: [
                              for (final o in history)
                                OrderListTile(
                                  order: o,
                                  l10n: l10n,
                                  locale: locale,
                                  calendar: calendar,
                                  isSelected: false,
                                  detailed: true,
                                  formatMoney: formatMoney,
                                  onTap: () => context.push(
                                    '/app/orders/${o.internalId}',
                                  ),
                                ),
                            ],
                          ),
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(24),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => PrideCarvedSection(
                  title: l10n.customerOrderHistoryTitle,
                  child: Text('$e'),
                ),
              ),
            ],
          ),
        );
      },
      loading: () => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.customerProfileTitle),
        ),
        body: const Center(child: CircularProgressIndicator()),
      ),
      error: (e, _) => Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.close),
            onPressed: () => context.pop(),
          ),
          title: Text(l10n.customerProfileTitle),
        ),
        body: Center(child: Text('$e')),
      ),
    );
  }
}

String _measurementProfileSyncPayloadJson({
  required String customerInternalId,
  required String label,
  required String notes,
  required int unitCode,
  required List<MeasurementProfileItemInput> items,
  required DateTime createdAt,
  required DateTime updatedAt,
}) {
  return jsonEncode({
    'customer_internal_id': customerInternalId,
    'label': label,
    'notes': notes,
    'unit_code': unitCode,
    'created_at': createdAt.toUtc().toIso8601String(),
    'updated_at': updatedAt.toUtc().toIso8601String(),
    'items': [
      for (final i in items)
        if (i.value.trim().isNotEmpty)
          {
            'measurement_type_internal_id': i.measurementTypeInternalId,
            'value': i.value.trim(),
            'unit_code': i.unitCode,
          },
    ],
  });
}

Future<void> _openMeasurementProfileEditor(
  BuildContext context,
  WidgetRef ref,
  AppLocalizations l10n, {
  required String customerId,
  MeasurementProfileSummary? existing,
}) async {
  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetCtx) {
      return Consumer(
        builder: (_, ref, _) {
          final typesAsync = ref.watch(measurementTypesStreamProvider);
          return typesAsync.when(
            data: (types) => _MeasurementProfileEditorBody(
              ref: ref,
              sheetContext: sheetCtx,
              outerContext: context,
              l10n: l10n,
              customerId: customerId,
              types: types,
              existing: existing,
            ),
            loading: () => const Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: CircularProgressIndicator()),
            ),
            error: (e, _) => Padding(
              padding: const EdgeInsets.all(24),
              child: Text('$e'),
            ),
          );
        },
      );
    },
  );
}

class _MeasurementProfileEditorBody extends StatefulWidget {
  const _MeasurementProfileEditorBody({
    required this.ref,
    required this.sheetContext,
    required this.outerContext,
    required this.l10n,
    required this.customerId,
    required this.types,
    this.existing,
  });

  final WidgetRef ref;
  final BuildContext sheetContext;
  final BuildContext outerContext;
  final AppLocalizations l10n;
  final String customerId;
  final List<MeasurementTypeSummary> types;
  final MeasurementProfileSummary? existing;

  @override
  State<_MeasurementProfileEditorBody> createState() =>
      _MeasurementProfileEditorBodyState();
}

class _MeasurementProfileEditorBodyState
    extends State<_MeasurementProfileEditorBody> {
  late final TextEditingController _labelCtrl;
  late final Map<String, TextEditingController> _valueCtrls;
  late int _unit;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _labelCtrl = TextEditingController(text: existing?.label ?? '');
    _unit = existing?.unitCode ?? MeasurementUnitCodes.cm;
    _valueCtrls = {};
    for (final t in widget.types) {
      var initial = '';
      if (existing != null) {
        for (final line in existing.lines) {
          if (line.measurementTypeInternalId == t.internalId) {
            initial = line.value;
            break;
          }
        }
      }
      _valueCtrls[t.internalId] = TextEditingController(text: initial);
    }
  }

  @override
  void dispose() {
    _labelCtrl.dispose();
    for (final c in _valueCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _canSave {
    for (final c in _valueCtrls.values) {
      if (c.text.trim().isNotEmpty) return true;
    }
    return false;
  }

  List<MeasurementProfileItemInput> _collectItems() {
    return [
      for (final t in widget.types)
        MeasurementProfileItemInput(
          measurementTypeInternalId: t.internalId,
          value: _valueCtrls[t.internalId]?.text ?? '',
          unitCode: _unit,
        ),
    ];
  }

  Future<String> _saveNew({required String label}) async {
    final repo = await widget.ref.read(
      measurementProfileRepositoryProvider.future,
    );
    final shopId = widget.ref.read(effectiveShopIdProvider);
    final now = DateTime.now();
    final trimmedLabel = label.trim().isEmpty ? '—' : label.trim();
    final id = await repo.createProfile(
      shopId: shopId,
      customerInternalId: widget.customerId,
      label: trimmedLabel,
      notes: '',
      unitCode: _unit,
      items: _collectItems(),
    );
    recordSyncOutboxMutation(
      widget.ref,
      kind: SyncOutboxKinds.measurementProfileUpsert,
      entityRef: id,
      shopId: shopId,
      payloadJson: _measurementProfileSyncPayloadJson(
        customerInternalId: widget.customerId,
        label: trimmedLabel,
        notes: '',
        unitCode: _unit,
        items: _collectItems(),
        createdAt: now,
        updatedAt: now,
      ),
    );
    return id;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final existing = widget.existing;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    final sheetHeight = MediaQuery.sizeOf(context).height * 0.88;

    return StatefulBuilder(
      builder: (ctx, setModal) {
        return Padding(
          padding: EdgeInsets.only(bottom: bottomInset),
          child: SizedBox(
            height: sheetHeight,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Text(
                          existing == null
                              ? l10n.measurementProfileEditorTitleNew
                              : l10n.measurementProfileEditorTitleEdit,
                          style: Theme.of(ctx).textTheme.titleLarge,
                        ),
                        const SizedBox(height: 12),
                        TextField(
                          controller: _labelCtrl,
                          decoration: InputDecoration(
                            labelText: l10n.measurementProfileLabelField,
                            border: const OutlineInputBorder(),
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          l10n.measurementProfileUnitSection,
                          style: Theme.of(ctx).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        SegmentedButton<int>(
                          segments: [
                            ButtonSegment(
                              value: MeasurementUnitCodes.cm,
                              label: Text(l10n.measurementUnitCm),
                            ),
                            ButtonSegment(
                              value: MeasurementUnitCodes.inch,
                              label: Text(l10n.measurementUnitInch),
                            ),
                          ],
                          selected: {_unit},
                          onSelectionChanged: (s) =>
                              setModal(() => _unit = s.first),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          l10n.measurementProfileBodyField,
                          style: Theme.of(ctx).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 8),
                        for (final t in widget.types) ...[
                          TextField(
                            controller: _valueCtrls[t.internalId],
                            keyboardType:
                                const TextInputType.numberWithOptions(
                              decimal: true,
                            ),
                            decoration: InputDecoration(
                              labelText: t.name,
                              border: const OutlineInputBorder(),
                            ),
                            onChanged: (_) => setModal(() {}),
                          ),
                          const SizedBox(height: 8),
                        ],
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
                  child: existing != null
                      ? Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: !_canSave
                            ? null
                            : () async {
                                if (widget.ref.read(licenseEditingBlockedProvider)) {
                                  if (widget.outerContext.mounted) {
                                    showAppFeedback(
                                      widget.outerContext,
                                      widget.ref,
                                      kind: AppFeedbackKind.error,
                                      message: licenseWriteBlockedMessage(
                                        widget.ref.read(licenseNotifierProvider),
                                        l10n,
                                      ),
                                    );
                                  }
                                  return;
                                }
                                final repo = await widget.ref.read(
                                  measurementProfileRepositoryProvider.future,
                                );
                                final shopId = widget.ref.read(
                                  effectiveShopIdProvider,
                                );
                                final now = DateTime.now();
                                final newId = await repo.createProfile(
                                  shopId: shopId,
                                  customerInternalId: widget.customerId,
                                  label: _labelCtrl.text.trim().isEmpty
                                      ? '${existing.label} (2)'
                                      : _labelCtrl.text.trim(),
                                  notes: '',
                                  unitCode: _unit,
                                  items: _collectItems(),
                                );
                                final lbl = _labelCtrl.text.trim().isEmpty
                                    ? '${existing.label} (2)'
                                    : _labelCtrl.text.trim();
                                recordSyncOutboxMutation(
                                  widget.ref,
                                  kind:
                                      SyncOutboxKinds.measurementProfileUpsert,
                                  entityRef: newId,
                                  shopId: shopId,
                                  payloadJson:
                                      _measurementProfileSyncPayloadJson(
                                    customerInternalId: widget.customerId,
                                    label: lbl,
                                    notes: '',
                                    unitCode: _unit,
                                    items: _collectItems(),
                                    createdAt: now,
                                    updatedAt: now,
                                  ),
                                );
                                if (widget.sheetContext.mounted) {
                                  Navigator.pop(widget.sheetContext);
                                }
                                if (widget.outerContext.mounted) {
                                  showAppFeedback(
                                    widget.outerContext,
                                    widget.ref,
                                    kind: AppFeedbackKind.success,
                                    message: l10n.measurementProfileCreated,
                                  );
                                }
                              },
                        child: Text(l10n.measurementProfileSaveAsNew),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: FilledButton(
                        onPressed: !_canSave
                            ? null
                            : () async {
                                if (widget.ref.read(licenseEditingBlockedProvider)) {
                                  if (widget.outerContext.mounted) {
                                    showAppFeedback(
                                      widget.outerContext,
                                      widget.ref,
                                      kind: AppFeedbackKind.error,
                                      message: licenseWriteBlockedMessage(
                                        widget.ref.read(licenseNotifierProvider),
                                        l10n,
                                      ),
                                    );
                                  }
                                  return;
                                }
                                final repo = await widget.ref.read(
                                  measurementProfileRepositoryProvider.future,
                                );
                                await repo.updateProfile(
                                  internalId: existing.internalId,
                                  label: _labelCtrl.text,
                                  notes: '',
                                  unitCode: _unit,
                                  items: _collectItems(),
                                );
                                final shopId = widget.ref.read(
                                  effectiveShopIdProvider,
                                );
                                final now = DateTime.now();
                                recordSyncOutboxMutation(
                                  widget.ref,
                                  kind:
                                      SyncOutboxKinds.measurementProfileUpsert,
                                  entityRef: existing.internalId,
                                  shopId: shopId,
                                  payloadJson:
                                      _measurementProfileSyncPayloadJson(
                                    customerInternalId: widget.customerId,
                                    label: _labelCtrl.text.trim().isEmpty
                                        ? '—'
                                        : _labelCtrl.text.trim(),
                                    notes: '',
                                    unitCode: _unit,
                                    items: _collectItems(),
                                    createdAt: existing.createdAt,
                                    updatedAt: now,
                                  ),
                                );
                                if (widget.sheetContext.mounted) {
                                  Navigator.pop(widget.sheetContext);
                                }
                                if (widget.outerContext.mounted) {
                                  showAppFeedback(
                                    widget.outerContext,
                                    widget.ref,
                                    kind: AppFeedbackKind.success,
                                    message: l10n.measurementProfileUpdated,
                                  );
                                }
                              },
                        child: Text(l10n.saveCta),
                      ),
                    ),
                        ],
                      )
                      : FilledButton(
                  onPressed: !_canSave
                      ? null
                      : () async {
                          if (widget.ref.read(licenseEditingBlockedProvider)) {
                            if (widget.outerContext.mounted) {
                              showAppFeedback(
                                widget.outerContext,
                                widget.ref,
                                kind: AppFeedbackKind.error,
                                message: licenseWriteBlockedMessage(
                                  widget.ref.read(licenseNotifierProvider),
                                  l10n,
                                ),
                              );
                            }
                            return;
                          }
                          await _saveNew(
                            label: _labelCtrl.text.trim().isEmpty
                                ? '—'
                                : _labelCtrl.text.trim(),
                          );
                          if (widget.sheetContext.mounted) {
                            Navigator.pop(widget.sheetContext);
                          }
                          if (widget.outerContext.mounted) {
                            showAppFeedback(
                              widget.outerContext,
                              widget.ref,
                              kind: AppFeedbackKind.success,
                              message: l10n.measurementProfileCreated,
                            );
                          }
                        },
                          child: Text(l10n.measurementProfilesAddCta),
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

