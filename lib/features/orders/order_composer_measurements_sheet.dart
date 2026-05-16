import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/measurement_profile_line.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/measurement_unit_codes.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/providers/local_data_providers.dart';

/// Result of the full measurements editor (order hub).
class OrderMeasurementsEditorResult {
  const OrderMeasurementsEditorResult({
    required this.measurementsSnapshot,
    required this.measurementSnapshotItems,
    this.sourceMeasurementProfileId,
    required this.sourceMeasurementProfileLabel,
  });

  final String measurementsSnapshot;
  final List<OrderMeasurementSnapshotItemInput> measurementSnapshotItems;
  final String? sourceMeasurementProfileId;
  final String sourceMeasurementProfileLabel;
}

Future<OrderMeasurementsEditorResult?> showOrderMeasurementsEditorSheet({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required String shopId,
  required String? customerId,
  required String initialSnapshotText,
  required List<OrderMeasurementSnapshotItemInput> initialItems,
  required String? initialProfileId,
  required String initialProfileLabel,
  required List<MeasurementProfileSummary> profiles,
}) {
  return showModalBottomSheet<OrderMeasurementsEditorResult>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (ctx) {
      return _OrderMeasurementsEditorBody(
        l10n: l10n,
        shopId: shopId,
        customerId: customerId,
        initialSnapshotText: initialSnapshotText,
        initialItems: initialItems,
        initialProfileId: initialProfileId,
        initialProfileLabel: initialProfileLabel,
        profiles: profiles,
      );
    },
  );
}

class _OrderMeasurementsEditorBody extends ConsumerStatefulWidget {
  const _OrderMeasurementsEditorBody({
    required this.l10n,
    required this.shopId,
    required this.customerId,
    required this.initialSnapshotText,
    required this.initialItems,
    required this.initialProfileId,
    required this.initialProfileLabel,
    required this.profiles,
  });

  final AppLocalizations l10n;
  final String shopId;
  final String? customerId;
  final String initialSnapshotText;
  final List<OrderMeasurementSnapshotItemInput> initialItems;
  final String? initialProfileId;
  final String initialProfileLabel;
  final List<MeasurementProfileSummary> profiles;

  @override
  ConsumerState<_OrderMeasurementsEditorBody> createState() =>
      _OrderMeasurementsEditorBodyState();
}

class _OrderMeasurementsEditorBodyState
    extends ConsumerState<_OrderMeasurementsEditorBody> {
  late Map<String, TextEditingController> _byTypeId;
  String? _profileId;
  String _profileLabel = '';

  @override
  void initState() {
    super.initState();
    _byTypeId = {};
    _profileId = widget.initialProfileId;
    _profileLabel = widget.initialProfileLabel;
    for (final it in widget.initialItems) {
      _byTypeId[it.measurementTypeInternalId] = TextEditingController(text: it.value);
    }
  }

  @override
  void dispose() {
    for (final c in _byTypeId.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String typeId) {
    return _byTypeId.putIfAbsent(typeId, () => TextEditingController());
  }

  Future<void> _pickProfile() async {
    if (widget.profiles.isEmpty) return;
    final picked = await showModalBottomSheet<MeasurementProfileSummary>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(title: Text(widget.l10n.measurementProfilePickSheetTitle)),
              const Divider(height: 1),
              for (final p in widget.profiles)
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
    setState(() {
      _profileId = picked.internalId;
      _profileLabel = picked.label;
      for (final c in _byTypeId.values) {
        c.dispose();
      }
      _byTypeId = {};
      for (final line in picked.lines) {
        _byTypeId[line.measurementTypeInternalId] =
            TextEditingController(text: line.value);
      }
    });
  }

  OrderMeasurementsEditorResult _buildResult(List<MeasurementTypeSummary> types) {
    var order = 0;
    final items = <OrderMeasurementSnapshotItemInput>[];
    final lines = <MeasurementProfileLine>[];
    final sorted = [...types]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    for (final t in sorted) {
      final c = _byTypeId[t.internalId];
      final raw = c?.text ?? '';
      final v = raw.trim();
      if (v.isEmpty) continue;
      order += 10;
      final uc = MeasurementUnitCodes.cm;
      items.add(
        OrderMeasurementSnapshotItemInput(
          measurementTypeInternalId: t.internalId,
          typeName: t.name,
          value: v,
          unitCode: uc,
          sortOrder: order,
        ),
      );
      lines.add(
        MeasurementProfileLine(
          measurementTypeInternalId: t.internalId,
          typeName: t.name,
          value: v,
          unitCode: uc,
        ),
      );
    }
    final snap = MeasurementProfileFormatting.buildDisplayText(lines: lines, notes: '');
    return OrderMeasurementsEditorResult(
      measurementsSnapshot: snap,
      measurementSnapshotItems: items,
      sourceMeasurementProfileId: _profileId,
      sourceMeasurementProfileLabel: _profileLabel,
    );
  }

  Future<void> _applyAndPop(List<MeasurementTypeSummary> types) async {
    final result = _buildResult(types);
    if (!mounted) return;
    Navigator.of(context).pop(result);
  }

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(measurementTypesStreamProvider);
    final pad = MediaQuery.paddingOf(context);
    return typesAsync.when(
      data: (types) {
        if (types.isEmpty) {
          return Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + pad.bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  widget.l10n.ordersComposerMeasurementsNoTypesBody,
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                FilledButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text(MaterialLocalizations.of(context).closeButtonLabel),
                ),
              ],
            ),
          );
        }
        final sorted = [...types]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.72,
          minChildSize: 0.4,
          maxChildSize: 0.92,
          builder: (ctx, scroll) {
            return Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 0, 16, 8),
                  child: Text(
                    widget.l10n.ordersComposerMeasurementsSheetTitle,
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                ),
                if (widget.profiles.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: OutlinedButton.icon(
                      onPressed: _pickProfile,
                      icon: const Icon(Icons.folder_open_outlined),
                      label: Text(widget.l10n.ordersComposerLoadProfileCta),
                    ),
                  ),
                if (_profileLabel.isNotEmpty)
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: InputChip(
                        label: Text(
                          widget.l10n.ordersComposerProfileLinked(_profileLabel),
                        ),
                        deleteIcon: const Icon(Icons.close, size: 18),
                        onDeleted: () {
                          setState(() {
                            _profileId = null;
                            _profileLabel = '';
                          });
                        },
                      ),
                    ),
                  ),
                Expanded(
                  child: ListView(
                    controller: scroll,
                    padding: EdgeInsets.fromLTRB(16, 8, 16, 8 + pad.bottom),
                    children: [
                      for (final t in sorted)
                        _CompactMeasurementValueField(
                          label: t.name,
                          controller: _controllerFor(t.internalId),
                          onChanged: (_) => setState(() {}),
                        ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + pad.bottom),
                  child: Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text(MaterialLocalizations.of(context).cancelButtonLabel),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: FilledButton(
                          onPressed: () => _applyAndPop(types),
                          child: Text(widget.l10n.saveCta),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            );
          },
        );
      },
      loading: () => const Padding(
        padding: EdgeInsets.all(32),
        child: Center(child: CircularProgressIndicator()),
      ),
      error: (e, s) => Padding(
        padding: const EdgeInsets.all(24),
        child: Text(widget.l10n.genericError),
      ),
    );
  }
}

/// Narrow numeric field for tailoring measurements (typically ≤5 digits).
class _CompactMeasurementValueField extends StatelessWidget {
  const _CompactMeasurementValueField({
    required this.label,
    required this.controller,
    this.onChanged,
  });

  final String label;
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              label,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 80,
            child: TextField(
              controller: controller,
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              maxLength: 5,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium,
              decoration: InputDecoration(
                isDense: true,
                contentPadding:
                    const EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                counterText: '',
              ),
              onChanged: onChanged,
            ),
          ),
        ],
      ),
    );
  }
}
