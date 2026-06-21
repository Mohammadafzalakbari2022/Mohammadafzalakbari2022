import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/fabric/generate_fabric_id.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/fabric_preset_summary.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'order_composer_reference.dart';

class OrderComposerFabricResult {
  const OrderComposerFabricResult({
    required this.fabricName,
    required this.fabricColor,
    required this.fabricId,
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
    this.clothMeters = '',
    this.clothPriceAmountMinor = 0,
  });

  final String fabricName;
  final String fabricColor;
  final String fabricId;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;
  final String clothMeters;
  final int clothPriceAmountMinor;

  bool get isEmpty =>
      fabricName.trim().isEmpty &&
      fabricColor.trim().isEmpty &&
      fabricId.trim().isEmpty;
}

Future<OrderComposerFabricResult?> showOrderComposerFabricSheet({
  required BuildContext context,
  String initialName = '',
  String initialColor = '',
  String initialFabricId = '',
  String? initialNamePresetId,
  String? initialColorPresetId,
  OrderSummary? referenceOrder,
  OrderItemSummary? referenceItem,
  VoidCallback? onUsePreviousFabric,
  String Function(AppLocalizations l10n, int minor)? moneyFormatter,
  String initialFabricSummary = '',
}) {
  return showPrideModalBottomSheet<OrderComposerFabricResult?>(
    context: context,
    builder: (ctx) => _OrderComposerFabricSheet(
      initialName: initialName,
      initialColor: initialColor,
      initialFabricId: initialFabricId,
      initialNamePresetId: initialNamePresetId,
      initialColorPresetId: initialColorPresetId,
      referenceOrder: referenceOrder,
      referenceItem: referenceItem,
      onUsePreviousFabric: onUsePreviousFabric,
      moneyFormatter: moneyFormatter,
      initialFabricSummary: initialFabricSummary,
    ),
  );
}

class _OrderComposerFabricSheet extends ConsumerStatefulWidget {
  const _OrderComposerFabricSheet({
    required this.initialName,
    required this.initialColor,
    required this.initialFabricId,
    this.initialNamePresetId,
    this.initialColorPresetId,
    this.referenceOrder,
    this.referenceItem,
    this.onUsePreviousFabric,
    this.moneyFormatter,
    this.initialFabricSummary = '',
  });

  final String initialName;
  final String initialColor;
  final String initialFabricId;
  final String? initialNamePresetId;
  final String? initialColorPresetId;
  final OrderSummary? referenceOrder;
  final OrderItemSummary? referenceItem;
  final VoidCallback? onUsePreviousFabric;
  final String Function(AppLocalizations l10n, int minor)? moneyFormatter;
  final String initialFabricSummary;

  @override
  ConsumerState<_OrderComposerFabricSheet> createState() =>
      _OrderComposerFabricSheetState();
}

class _OrderComposerFabricSheetState
    extends ConsumerState<_OrderComposerFabricSheet> {
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
    _nameCtrl.addListener(_onNameEdited);
    _colorCtrl.addListener(_onColorEdited);
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

  @override
  void dispose() {
    _nameCtrl
      ..removeListener(_onNameEdited)
      ..dispose();
    _colorCtrl
      ..removeListener(_onColorEdited)
      ..dispose();
    super.dispose();
  }

  void _selectName(FabricPresetSummary preset) {
    setState(() {
      _namePresetId = preset.internalId;
      _nameCtrl.text = preset.name;
    });
  }

  void _selectColor(FabricPresetSummary preset) {
    setState(() {
      _colorPresetId = preset.internalId;
      _colorCtrl.text = preset.name;
    });
  }

  void _save() {
    final name = _nameCtrl.text.trim();
    final color = _colorCtrl.text.trim();
    if (name.isEmpty && color.isEmpty) {
      Navigator.pop(context, null);
      return;
    }
    var id = _fabricId.trim();
    if (id.isEmpty) {
      id = generateFabricId();
    }
    Navigator.pop(
      context,
      OrderComposerFabricResult(
        fabricName: name,
        fabricColor: color,
        fabricId: id,
        fabricNamePresetInternalId: _namePresetId,
        fabricColorPresetInternalId: _colorPresetId,
      ),
    );
  }

  void _clear() {
    Navigator.pop(context, null);
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
    final l10n = AppLocalizations.of(context)!;
    final namesAsync = ref.watch(fabricNamesStreamProvider);
    final colorsAsync = ref.watch(fabricColorsStreamProvider);
    final pad = MediaQuery.paddingOf(context);
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;

    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: kPrideSheetInitialChildSize,
        minChildSize: kPrideSheetMinChildSize,
        maxChildSize: kPrideSheetMaxChildSize,
        builder: (context, scrollController) {
          return Material(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.close),
                      ),
                      Expanded(
                        child: Text(
                          l10n.ordersComposerFabricSheetTitle,
                          style: Theme.of(context).textTheme.titleLarge,
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    keyboardDismissBehavior:
                        ScrollViewKeyboardDismissBehavior.onDrag,
                    padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                    children: [
                      if (widget.referenceOrder != null &&
                          widget.moneyFormatter != null)
                        ComposerSheetPreviousHeader(
                          title: l10n.ordersComposerFabricSheetTitle,
                          previousSection: ComposerSheetPreviousSection(
                            referenceOrder: widget.referenceOrder!,
                            referenceItem: widget.referenceItem,
                            kind: ComposerSheetPreviousKind.fabric,
                            currentTextForDiff: widget.initialFabricSummary,
                            currentIsMeaningfulForDiff:
                                widget.initialFabricSummary.trim().isNotEmpty,
                            onUsePrevious: widget.onUsePreviousFabric,
                            money: widget.moneyFormatter!,
                          ),
                        ),
                      Text(
                        l10n.ordersComposerFabricNameLabel,
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
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          labelText: l10n.ordersComposerFabricNameLabel,
                          hintText: l10n.ordersComposerFabricNameHint,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.ordersComposerFabricColorLabel,
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
                        scrollPadding: const EdgeInsets.only(bottom: 120),
                        decoration: InputDecoration(
                          labelText: l10n.ordersComposerFabricColorLabel,
                          hintText: l10n.ordersComposerFabricColorHint,
                          border: const OutlineInputBorder(),
                          isDense: true,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Card(
                        clipBehavior: Clip.antiAlias,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Row(
                                children: [
                                  Icon(
                                    Icons.tag_outlined,
                                    size: 20,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .onSurfaceVariant,
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    l10n.ordersComposerFabricIdLabel,
                                    style: Theme.of(context)
                                        .textTheme
                                        .titleSmall,
                                  ),
                                ],
                              ),
                              const SizedBox(height: 8),
                              Text(
                                _fabricId.trim().isEmpty
                                    ? l10n.ordersComposerFabricIdHint
                                    : _fabricId,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w700,
                                      letterSpacing: 2,
                                      color: _fabricId.trim().isEmpty
                                          ? Theme.of(context)
                                              .colorScheme
                                              .onSurfaceVariant
                                          : null,
                                    ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + pad.bottom),
                  child: Row(
                    children: [
                      TextButton(
                        onPressed: _clear,
                        child: Text(l10n.ordersComposerFabricClearCta),
                      ),
                      const Spacer(),
                      FilledButton(
                        onPressed: _save,
                        child: Text(l10n.saveCta),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
