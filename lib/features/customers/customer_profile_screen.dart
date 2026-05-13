import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_summary.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/measurement_profile_item_input.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/measurement_unit_codes.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import '../orders/order_status_label.dart';

class CustomerProfileScreen extends ConsumerWidget {
  const CustomerProfileScreen({super.key, required this.customerId});

  final String customerId;

  Future<void> _editCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n, {
    required String currentName,
    required String? currentPhone,
    required String? currentAddress,
    required String? currentNotes,
  }) async {
    final license = ref.read(licenseNotifierProvider);
    if (license.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.licenseExpiredReadOnly)),
      );
      return;
    }

    final nameCtrl = TextEditingController(text: currentName);
    final phoneCtrl = TextEditingController(text: currentPhone ?? '');
    final addressCtrl = TextEditingController(text: currentAddress ?? '');
    final notesCtrl = TextEditingController(text: currentNotes ?? '');

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
              const SizedBox(height: 12),
              TextField(
                controller: notesCtrl,
                minLines: 2,
                maxLines: 4,
                decoration: InputDecoration(
                  labelText: l10n.customerNotesLabel,
                  hintText: l10n.customerNotesHint,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: Text(l10n.saveCta),
          ),
        ],
      ),
    );

    if (ok != true) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      notesCtrl.dispose();
      return;
    }
    final nextName = nameCtrl.text.trim();
    if (nextName.isEmpty) {
      nameCtrl.dispose();
      phoneCtrl.dispose();
      addressCtrl.dispose();
      notesCtrl.dispose();
      return;
    }

    final phoneText = phoneCtrl.text;
    final addressText = addressCtrl.text;
    final notesText = notesCtrl.text;
    nameCtrl.dispose();
    phoneCtrl.dispose();
    addressCtrl.dispose();
    notesCtrl.dispose();

    final repo = await ref.read(customerListRepositoryProvider.future);
    await repo.updateCustomer(
      internalId: customerId,
      name: nextName,
      phone: phoneText,
      address: addressText,
      notes: notesText,
    );

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.customerUpdated)),
    );
  }

  Future<void> _deleteCustomer(
    BuildContext context,
    WidgetRef ref,
    AppLocalizations l10n,
  ) async {
    final license = ref.read(licenseNotifierProvider);
    if (license.isExpired) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.licenseExpiredReadOnly)),
      );
      return;
    }

    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.customerDeleteConfirmTitle),
        content: Text(l10n.customerDeleteConfirmBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteCta),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;

    final repo = await ref.read(customerListRepositoryProvider.future);
    await repo.softDeleteCustomer(customerId);

    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.customerDeleted)),
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
        final customerNotes = c.notes;

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
                  currentName: customerName,
                  currentPhone: customerPhone,
                  currentAddress: customerAddress,
                  currentNotes: customerNotes,
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
              ExpansionTile(
                title: Text(l10n.customerInfoSection),
                subtitle: Text(customerPhone ?? l10n.customersPhoneMissing),
                initiallyExpanded: true,
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.person_outline),
                          title: Text(l10n.customerNameLabel),
                          subtitle: Text(customerName),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.phone_outlined),
                          title: Text(l10n.customerPhoneLabel),
                          subtitle: Text(customerPhone ?? l10n.customersPhoneMissing),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.home_outlined),
                          title: Text(l10n.customerAddressLabel),
                          subtitle: Text(
                            (customerAddress != null &&
                                    customerAddress.trim().isNotEmpty)
                                ? customerAddress.trim()
                                : l10n.customerFieldEmpty,
                          ),
                        ),
                        ListTile(
                          contentPadding: EdgeInsets.zero,
                          leading: const Icon(Icons.notes_outlined),
                          title: Text(l10n.customerNotesLabel),
                          subtitle: Text(
                            (customerNotes != null &&
                                    customerNotes.trim().isNotEmpty)
                                ? customerNotes.trim()
                                : l10n.customerFieldEmpty,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              ExpansionTile(
                title: Text(l10n.customerMeasurementProfilesSection),
                children: [
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
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
                                  child: FilledButton.tonalIcon(
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
                ],
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 12, 16, 8),
                child: Text(
                  l10n.customerTodayOrdersTitle,
                  style: Theme.of(context).textTheme.titleSmall,
                ),
              ),
              asyncOrders.when(
                data: (orders) {
                  final today = DateTime.now();
                  final start = DateTime(today.year, today.month, today.day);
                  final end = start.add(const Duration(days: 1));

                  final todays = orders
                      .where((o) =>
                          o.customerInternalId == customerId &&
                          !o.deliveryDate.isBefore(start) &&
                          o.deliveryDate.isBefore(end))
                      .toList();

                  if (todays.isEmpty) {
                    return Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Text(l10n.customerNoTodayOrders),
                    );
                  }

                  return Column(
                    children: [
                      for (final o in todays.take(10))
                        ListTile(
                          title: Text(l10n.ordersNumberPrefix(o.displayOrderNo)),
                          subtitle: Text(
                            l10n.ordersDeliveryOn(
                              AppCalendarFormat.mediumDate(
                                l10n,
                                calendar,
                                o.deliveryDate,
                                locale,
                              ),
                            ),
                          ),
                          trailing: Wrap(
                            spacing: 6,
                            alignment: WrapAlignment.end,
                            children: [
                              Chip(
                                label: Text(orderStatusLabel(o.status, l10n)),
                                visualDensity: VisualDensity.compact,
                              ),
                              if (o.isUnpaid)
                                Chip(
                                  label: Text(
                                    l10n.ordersRemainingChip(
                                      o.remainingAmountMinor.toString(),
                                    ),
                                  ),
                                  visualDensity: VisualDensity.compact,
                                ),
                            ],
                          ),
                          onTap: () => context.push('/app/orders/${o.internalId}'),
                        ),
                    ],
                  );
                },
                loading: () => const Padding(
                  padding: EdgeInsets.all(16),
                  child: Center(child: CircularProgressIndicator()),
                ),
                error: (e, _) => Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text('$e'),
                ),
              ),
              const SizedBox(height: 12),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: FilledButton.tonal(
                  onPressed: () {
                    context.go('/app/orders?customer=$customerId');
                  },
                  child: Text(l10n.customerViewAllOrders),
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
  late final TextEditingController _notesCtrl;
  late final Map<String, TextEditingController> _valueCtrls;
  late int _unit;

  @override
  void initState() {
    super.initState();
    final existing = widget.existing;
    _labelCtrl = TextEditingController(text: existing?.label ?? '');
    _notesCtrl = TextEditingController(text: existing?.notes ?? '');
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
    _notesCtrl.dispose();
    for (final c in _valueCtrls.values) {
      c.dispose();
    }
    super.dispose();
  }

  bool get _canSave {
    if (_notesCtrl.text.trim().isNotEmpty) return true;
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

  Future<void> _saveNew({required String label}) async {
    final repo = await widget.ref.read(
      measurementProfileRepositoryProvider.future,
    );
    await repo.createProfile(
      shopId: kDevShopId,
      customerInternalId: widget.customerId,
      label: label,
      notes: _notesCtrl.text.trim(),
      unitCode: _unit,
      items: _collectItems(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = widget.l10n;
    final existing = widget.existing;
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;

    return StatefulBuilder(
      builder: (ctx, setModal) {
        return SingleChildScrollView(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: bottomInset + 16,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
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
                onSelectionChanged: (s) => setModal(() => _unit = s.first),
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
                  keyboardType: const TextInputType.numberWithOptions(
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
              TextField(
                controller: _notesCtrl,
                minLines: 2,
                maxLines: 6,
                decoration: InputDecoration(
                  labelText: l10n.measurementProfileNotesField,
                  border: const OutlineInputBorder(),
                  alignLabelWithHint: true,
                ),
                onChanged: (_) => setModal(() {}),
              ),
              const SizedBox(height: 16),
              if (existing != null)
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: !_canSave
                            ? null
                            : () async {
                                final license = widget.ref.read(
                                  licenseNotifierProvider,
                                );
                                if (license.isExpired) {
                                  if (widget.outerContext.mounted) {
                                    ScaffoldMessenger.of(
                                      widget.outerContext,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.licenseExpiredReadOnly,
                                        ),
                                      ),
                                    );
                                  }
                                  return;
                                }
                                final repo = await widget.ref.read(
                                  measurementProfileRepositoryProvider.future,
                                );
                                await repo.createProfile(
                                  shopId: kDevShopId,
                                  customerInternalId: widget.customerId,
                                  label: _labelCtrl.text.trim().isEmpty
                                      ? '${existing.label} (2)'
                                      : _labelCtrl.text.trim(),
                                  notes: _notesCtrl.text.trim(),
                                  unitCode: _unit,
                                  items: _collectItems(),
                                );
                                if (widget.sheetContext.mounted) {
                                  Navigator.pop(widget.sheetContext);
                                }
                                if (widget.outerContext.mounted) {
                                  ScaffoldMessenger.of(widget.outerContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.measurementProfileCreated,
                                      ),
                                    ),
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
                                final license = widget.ref.read(
                                  licenseNotifierProvider,
                                );
                                if (license.isExpired) {
                                  if (widget.outerContext.mounted) {
                                    ScaffoldMessenger.of(
                                      widget.outerContext,
                                    ).showSnackBar(
                                      SnackBar(
                                        content: Text(
                                          l10n.licenseExpiredReadOnly,
                                        ),
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
                                  notes: _notesCtrl.text.trim(),
                                  unitCode: _unit,
                                  items: _collectItems(),
                                );
                                if (widget.sheetContext.mounted) {
                                  Navigator.pop(widget.sheetContext);
                                }
                                if (widget.outerContext.mounted) {
                                  ScaffoldMessenger.of(widget.outerContext)
                                      .showSnackBar(
                                    SnackBar(
                                      content: Text(
                                        l10n.measurementProfileUpdated,
                                      ),
                                    ),
                                  );
                                }
                              },
                        child: Text(l10n.saveCta),
                      ),
                    ),
                  ],
                )
              else
                FilledButton(
                  onPressed: !_canSave
                      ? null
                      : () async {
                          final license = widget.ref.read(
                            licenseNotifierProvider,
                          );
                          if (license.isExpired) {
                            if (widget.outerContext.mounted) {
                              ScaffoldMessenger.of(widget.outerContext)
                                  .showSnackBar(
                                SnackBar(
                                  content: Text(l10n.licenseExpiredReadOnly),
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
                            ScaffoldMessenger.of(widget.outerContext)
                                .showSnackBar(
                              SnackBar(
                                content: Text(l10n.measurementProfileCreated),
                              ),
                            );
                          }
                        },
                  child: Text(l10n.measurementProfilesAddCta),
                ),
            ],
          ),
        );
      },
    );
  }
}

