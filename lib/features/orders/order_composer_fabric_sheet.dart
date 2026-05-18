import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/fabric/generate_fabric_id.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/fabric_preset_summary.dart';
import '../../data/providers/local_data_providers.dart';

class OrderComposerFabricResult {
  const OrderComposerFabricResult({
    required this.fabricName,
    required this.fabricColor,
    required this.fabricId,
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
  });

  final String fabricName;
  final String fabricColor;
  final String fabricId;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;

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
}) {
  return showModalBottomSheet<OrderComposerFabricResult?>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _OrderComposerFabricSheet(
      initialName: initialName,
      initialColor: initialColor,
      initialFabricId: initialFabricId,
      initialNamePresetId: initialNamePresetId,
      initialColorPresetId: initialColorPresetId,
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
  });

  final String initialName;
  final String initialColor;
  final String initialFabricId;
  final String? initialNamePresetId;
  final String? initialColorPresetId;

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
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.55,
      minChildSize: 0.4,
      maxChildSize: 0.9,
      builder: (context, scrollController) {
        return Material(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.fromLTRB(8, 8, 8, keyboard),
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
                    FilledButton(
                      onPressed: _save,
                      child: Text(l10n.saveCta),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: scrollController,
                  padding: EdgeInsets.fromLTRB(16, 8, 16, 24 + keyboard),
                  children: [
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
                                  style:
                                      Theme.of(context).textTheme.titleSmall,
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
                    const SizedBox(height: 16),
                    Align(
                      alignment: AlignmentDirectional.centerStart,
                      child: TextButton(
                        onPressed: _clear,
                        child: Text(l10n.ordersComposerFabricClearCta),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
