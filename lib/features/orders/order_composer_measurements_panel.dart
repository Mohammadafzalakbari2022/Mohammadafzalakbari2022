import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/pride_numeric_text_field.dart';
import 'package:pride_v3/core/widgets/pride_optional_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/measurement_profile_line.dart';
import '../../data/local/measurement_profile_summary.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../settings/settings_providers.dart';
import 'order_composer_measurements_sheet.dart';
import 'order_composer_reference.dart';

/// Inline measurements grid for the receipt composer (no modal).
class OrderComposerMeasurementsPanel extends ConsumerStatefulWidget {
  const OrderComposerMeasurementsPanel({
    super.key,
    required this.l10n,
    required this.shopId,
    required this.customerId,
    required this.initialSnapshotText,
    required this.initialItems,
    required this.initialProfileId,
    required this.initialProfileLabel,
    required this.profiles,
    required this.onChanged,
    this.referenceOrder,
    this.referenceItem,
    this.onUsePreviousMeasurements,
    this.moneyFormatter,
  });

  final AppLocalizations l10n;
  final String shopId;
  final String? customerId;
  final String initialSnapshotText;
  final List<OrderMeasurementSnapshotItemInput> initialItems;
  final String? initialProfileId;
  final String initialProfileLabel;
  final List<MeasurementProfileSummary> profiles;
  final ValueChanged<OrderMeasurementsEditorResult> onChanged;
  final OrderSummary? referenceOrder;
  final OrderItemSummary? referenceItem;
  final VoidCallback? onUsePreviousMeasurements;
  final String Function(AppLocalizations l10n, int minor)? moneyFormatter;

  @override
  ConsumerState<OrderComposerMeasurementsPanel> createState() =>
      _OrderComposerMeasurementsPanelState();
}

class _OrderComposerMeasurementsPanelState
    extends ConsumerState<OrderComposerMeasurementsPanel> {
  late Map<String, TextEditingController> _byTypeId;
  String? _profileId;
  String _profileLabel = '';

  @override
  void initState() {
    super.initState();
    _profileId = widget.initialProfileId;
    _profileLabel = widget.initialProfileLabel;
    _byTypeId = {};
    for (final it in widget.initialItems) {
      final c = TextEditingController(text: it.value);
      c.addListener(_emitChange);
      _byTypeId[it.measurementTypeInternalId] = c;
    }
  }

  @override
  void didUpdateWidget(OrderComposerMeasurementsPanel oldWidget) {
    super.didUpdateWidget(oldWidget);
    // Re-seed only on external draft changes (profile load, use-previous).
    // Parent no longer setState's on each keystroke, but guard anyway.
    final externalReseed =
        oldWidget.initialProfileId != widget.initialProfileId ||
            oldWidget.initialSnapshotText != widget.initialSnapshotText;
    if (!externalReseed) return;
    _reseedFromInitialItems();
  }

  void _reseedFromInitialItems() {
    for (final c in _byTypeId.values) {
      c.dispose();
    }
    _byTypeId = {};
    for (final it in widget.initialItems) {
      final c = TextEditingController(text: it.value);
      c.addListener(_emitChange);
      _byTypeId[it.measurementTypeInternalId] = c;
    }
    _profileId = widget.initialProfileId;
    _profileLabel = widget.initialProfileLabel;
  }

  @override
  void dispose() {
    for (final c in _byTypeId.values) {
      c.dispose();
    }
    super.dispose();
  }

  TextEditingController _controllerFor(String typeId) {
    return _byTypeId.putIfAbsent(typeId, () {
      final c = TextEditingController();
      c.addListener(_emitChange);
      return c;
    });
  }

  void _emitChange() {
    final types =
        ref.read(measurementTypesStreamProvider).valueOrNull ?? const [];
    if (types.isEmpty) return;
    widget.onChanged(_buildResult(types));
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
      final uc = ref.read(defaultMeasurementUnitProvider);
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
    final snap =
        MeasurementProfileFormatting.buildDisplayText(lines: lines, notes: '');
    return OrderMeasurementsEditorResult(
      measurementsSnapshot: snap,
      measurementSnapshotItems: items,
      sourceMeasurementProfileId: _profileId,
      sourceMeasurementProfileLabel: _profileLabel,
    );
  }

  Future<void> _pickProfile() async {
    if (widget.profiles.isEmpty) return;
    final picked = await showModalBottomSheet<MeasurementProfileSummary>(
      context: context,
      isScrollControlled: true,
      builder: (ctx) {
        return SafeArea(
          child: ListView(
            padding: const EdgeInsets.symmetric(vertical: 8),
            children: [
              ListTile(
                title: Text(widget.l10n.measurementProfilePickSheetTitle),
              ),
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
        final c = TextEditingController(text: line.value);
        c.addListener(_emitChange);
        _byTypeId[line.measurementTypeInternalId] = c;
      }
    });
    _emitChange();
  }

  @override
  Widget build(BuildContext context) {
    final typesAsync = ref.watch(measurementTypesStreamProvider);
    return typesAsync.when(
      data: (types) {
        if (types.isEmpty) {
          return const SizedBox.shrink();
        }
        final sorted = [...types]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
        final hasAnyValue = sorted.any((t) {
          final c = _byTypeId[t.internalId];
          return c != null && c.text.trim().isNotEmpty;
        });
        return PrideOptionalPanel(
          isEmpty: !hasAnyValue,
          padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (widget.referenceOrder != null && widget.moneyFormatter != null)
                ComposerSheetPreviousSection(
                  referenceOrder: widget.referenceOrder!,
                  referenceItem: widget.referenceItem,
                  kind: ComposerSheetPreviousKind.measurements,
                  currentTextForDiff: widget.initialSnapshotText,
                  currentIsMeaningfulForDiff:
                      widget.initialSnapshotText.trim().isNotEmpty,
                  onUsePrevious: widget.onUsePreviousMeasurements,
                  money: widget.moneyFormatter!,
                ),
              if (widget.profiles.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional.centerStart,
                  child: OutlinedButton.icon(
                    onPressed: _pickProfile,
                    icon: const Icon(Icons.folder_open_outlined, size: 18),
                    label: Text(widget.l10n.ordersComposerLoadProfileCta),
                  ),
                ),
              if (_profileLabel.isNotEmpty)
                Align(
                  alignment: AlignmentDirectional.centerStart,
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
                      _emitChange();
                    },
                  ),
                ),
              const SizedBox(height: 8),
              for (final t in sorted)
                _ReceiptMeasurementField(
                  label: t.name,
                  controller: _controllerFor(t.internalId),
                ),
            ],
          ),
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text(widget.l10n.genericError),
    );
  }
}

class _ReceiptMeasurementField extends StatefulWidget {
  const _ReceiptMeasurementField({
    required this.label,
    required this.controller,
  });

  final String label;
  final TextEditingController controller;

  @override
  State<_ReceiptMeasurementField> createState() =>
      _ReceiptMeasurementFieldState();
}

class _ReceiptMeasurementFieldState extends State<_ReceiptMeasurementField> {
  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_onTextChanged);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onTextChanged);
    super.dispose();
  }

  void _onTextChanged() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isEmpty = widget.controller.text.trim().isEmpty;
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Text(
              widget.label,
              style: theme.textTheme.bodyMedium,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 10),
          SizedBox(
            width: 96,
            child: PrideOptionalPanel(
              isEmpty: isEmpty,
              padding: EdgeInsets.zero,
              child: PrideNumericTextField(
                controller: widget.controller,
                maxLength: 5,
                textAlign: TextAlign.center,
                dense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
