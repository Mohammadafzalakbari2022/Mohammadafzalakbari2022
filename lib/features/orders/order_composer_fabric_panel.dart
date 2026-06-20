import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/fabric/generate_fabric_id.dart';
import 'package:pride_v3/core/widgets/pride_optional_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/fabric_preset_summary.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_composer_reference.dart';

/// Inline fabric fields for the receipt composer (no modal).
class OrderComposerFabricPanel extends ConsumerStatefulWidget {
  const OrderComposerFabricPanel({
    super.key,
    required this.l10n,
    required this.initialName,
    required this.initialColor,
    required this.initialFabricId,
    this.initialNamePresetId,
    this.initialColorPresetId,
    required this.onChanged,
    this.referenceOrder,
    this.referenceItem,
    this.onUsePreviousFabric,
    this.moneyFormatter,
    this.initialFabricSummary = '',
  });

  final AppLocalizations l10n;
  final String initialName;
  final String initialColor;
  final String initialFabricId;
  final String? initialNamePresetId;
  final String? initialColorPresetId;
  final ValueChanged<OrderComposerFabricResult?> onChanged;
  final OrderSummary? referenceOrder;
  final OrderItemSummary? referenceItem;
  final VoidCallback? onUsePreviousFabric;
  final String Function(AppLocalizations l10n, int minor)? moneyFormatter;
  final String initialFabricSummary;

  @override
  ConsumerState<OrderComposerFabricPanel> createState() =>
      _OrderComposerFabricPanelState();
}

class _OrderComposerFabricPanelState
    extends ConsumerState<OrderComposerFabricPanel> {
  late final TextEditingController _nameCtrl;
  late final TextEditingController _colorCtrl;
  String? _namePresetId;
  String? _colorPresetId;
  String _fabricId = '';

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _colorCtrl = TextEditingController(text: widget.initialColor);
    _namePresetId = widget.initialNamePresetId;
    _colorPresetId = widget.initialColorPresetId;
    _fabricId = widget.initialFabricId;
    _nameCtrl.addListener(_emitChange);
    _colorCtrl.addListener(_emitChange);
  }

  @override
  void dispose() {
    _nameCtrl
      ..removeListener(_emitChange)
      ..dispose();
    _colorCtrl
      ..removeListener(_emitChange)
      ..dispose();
    super.dispose();
  }

  void _emitChange() {
    widget.onChanged(_buildResult());
  }

  OrderComposerFabricResult? _buildResult() {
    final name = _nameCtrl.text.trim();
    final color = _colorCtrl.text.trim();
    if (name.isEmpty && color.isEmpty) return null;
    var id = _fabricId.trim();
    if (id.isEmpty) {
      id = generateFabricId();
      _fabricId = id;
    }
    return OrderComposerFabricResult(
      fabricName: name,
      fabricColor: color,
      fabricId: id,
      fabricNamePresetInternalId: _namePresetId,
      fabricColorPresetInternalId: _colorPresetId,
    );
  }

  void _onNameEdited() {
    final names = ref.read(fabricNamesStreamProvider).valueOrNull;
    if (names == null || _namePresetId == null) return;
    final match = names.where((n) => n.internalId == _namePresetId);
    if (match.isEmpty) return;
    if (match.first.name.trim() != _nameCtrl.text.trim()) {
      setState(() => _namePresetId = null);
    }
  }

  void _onColorEdited() {
    final colors = ref.read(fabricColorsStreamProvider).valueOrNull;
    if (colors == null || _colorPresetId == null) return;
    final match = colors.where((c) => c.internalId == _colorPresetId);
    if (match.isEmpty) return;
    if (match.first.name.trim() != _colorCtrl.text.trim()) {
      setState(() => _colorPresetId = null);
    }
  }

  void _selectName(FabricPresetSummary preset) {
    setState(() {
      _namePresetId = preset.internalId;
      _nameCtrl.text = preset.name;
    });
    _emitChange();
  }

  void _selectColor(FabricPresetSummary preset) {
    setState(() {
      _colorPresetId = preset.internalId;
      _colorCtrl.text = preset.name;
    });
    _emitChange();
  }

  void _clear() {
    setState(() {
      _namePresetId = null;
      _colorPresetId = null;
      _fabricId = '';
      _nameCtrl.clear();
      _colorCtrl.clear();
    });
    widget.onChanged(null);
  }

  Widget _presetChips({
    required AsyncValue<List<FabricPresetSummary>> async,
    required String? selectedId,
    required void Function(FabricPresetSummary) onSelect,
  }) {
    return async.when(
      data: (presets) {
        final active = presets.where((p) => p.isActive).toList();
        if (active.isEmpty) return const SizedBox.shrink();
        return Wrap(
          spacing: 8,
          runSpacing: 4,
          children: [
            for (final p in active)
              ChoiceChip(
                label: Text(p.name),
                selected: selectedId == p.internalId,
                onSelected: (_) => onSelect(p),
              ),
          ],
        );
      },
      loading: () => const LinearProgressIndicator(),
      error: (e, _) => Text('$e'),
    );
  }

  @override
  Widget build(BuildContext context) {
    final namesAsync = ref.watch(fabricNamesStreamProvider);
    final colorsAsync = ref.watch(fabricColorsStreamProvider);
    final nameEmpty = _nameCtrl.text.trim().isEmpty;
    final colorEmpty = _colorCtrl.text.trim().isEmpty;
    final panelEmpty = nameEmpty && colorEmpty;

    return PrideOptionalPanel(
      isEmpty: panelEmpty,
      padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          if (widget.referenceOrder != null && widget.moneyFormatter != null)
            ComposerSheetPreviousSection(
              referenceOrder: widget.referenceOrder!,
              referenceItem: widget.referenceItem,
              kind: ComposerSheetPreviousKind.fabric,
              currentTextForDiff: widget.initialFabricSummary,
              currentIsMeaningfulForDiff:
                  widget.initialFabricSummary.trim().isNotEmpty,
              onUsePrevious: widget.onUsePreviousFabric,
              money: widget.moneyFormatter!,
            ),
          Text(
            widget.l10n.ordersComposerFabricNameLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _presetChips(
            async: namesAsync,
            selectedId: _namePresetId,
            onSelect: _selectName,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _nameCtrl,
            onChanged: (_) {
              _onNameEdited();
              setState(() {});
            },
            decoration: prideOptionalDecoration(
              context,
              base: InputDecoration(
                labelText: widget.l10n.ordersComposerFabricNameLabel,
                hintText: widget.l10n.ordersComposerFabricNameHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              isEmpty: nameEmpty,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            widget.l10n.ordersComposerFabricColorLabel,
            style: Theme.of(context).textTheme.titleSmall,
          ),
          const SizedBox(height: 8),
          _presetChips(
            async: colorsAsync,
            selectedId: _colorPresetId,
            onSelect: _selectColor,
          ),
          const SizedBox(height: 8),
          TextField(
            controller: _colorCtrl,
            onChanged: (_) {
              _onColorEdited();
              setState(() {});
            },
            decoration: prideOptionalDecoration(
              context,
              base: InputDecoration(
                labelText: widget.l10n.ordersComposerFabricColorLabel,
                hintText: widget.l10n.ordersComposerFabricColorHint,
                border: const OutlineInputBorder(),
                isDense: true,
              ),
              isEmpty: colorEmpty,
            ),
          ),
          const SizedBox(height: 8),
          Align(
            alignment: AlignmentDirectional.centerStart,
            child: TextButton(
              onPressed: _clear,
              child: Text(widget.l10n.ordersComposerFabricClearCta),
            ),
          ),
        ],
      ),
    );
  }
}
