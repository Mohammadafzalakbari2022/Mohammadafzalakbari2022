import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/fabric/generate_fabric_id.dart';
import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/core/widgets/pride_money_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:uuid/uuid.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/dev_shop_constants.dart';
import '../../data/local/cloth_stock_models.dart';
import '../../data/local/fabric_preset_summary.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../settings/cloth/cloth_sync_helpers.dart';
import 'order_composer_fabric_sheet.dart';
import 'order_composer_reference.dart';

/// Inline cloth fields for the receipt composer (no modal).
class OrderComposerFabricPanel extends ConsumerStatefulWidget {
  const OrderComposerFabricPanel({
    super.key,
    required this.l10n,
    required this.initialName,
    required this.initialColor,
    required this.initialFabricId,
    this.initialNamePresetId,
    this.initialColorPresetId,
    this.initialClothMeters = '',
    this.initialClothPriceMinor = 0,
    this.initialClothSourceIndex = 0,
    this.initialClothStockSkuInternalId,
    this.initialClothSaleCostMinor = 0,
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
  final String initialClothMeters;
  final int initialClothPriceMinor;
  final int initialClothSourceIndex;
  final String? initialClothStockSkuInternalId;
  final int initialClothSaleCostMinor;
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
  late final TextEditingController _metersCtrl;
  late final TextEditingController _priceCtrl;
  late final TextEditingController _cogsCtrl;
  String? _namePresetId;
  String? _colorPresetId;
  String _fabricId = '';
  int _clothSourceIndex = 0;
  String? _selectedSkuId;
  bool _shortStock = false;

  bool get _isShopStock => _clothSourceIndex == 1;

  @override
  void initState() {
    super.initState();
    _nameCtrl = TextEditingController(text: widget.initialName);
    _colorCtrl = TextEditingController(text: widget.initialColor);
    _metersCtrl = TextEditingController(text: widget.initialClothMeters);
    _priceCtrl = TextEditingController(
      text: widget.initialClothPriceMinor > 0
          ? widget.initialClothPriceMinor.toString()
          : '',
    );
    _cogsCtrl = TextEditingController(
      text: widget.initialClothSaleCostMinor > 0
          ? widget.initialClothSaleCostMinor.toString()
          : '',
    );
    _namePresetId = widget.initialNamePresetId;
    _colorPresetId = widget.initialColorPresetId;
    _fabricId = widget.initialFabricId;
    _clothSourceIndex = widget.initialClothSourceIndex;
    _selectedSkuId = widget.initialClothStockSkuInternalId;
    for (final c in [_nameCtrl, _colorCtrl, _metersCtrl, _priceCtrl, _cogsCtrl]) {
      c.addListener(_emitChange);
    }
    WidgetsBinding.instance.addPostFrameCallback((_) => _checkShortStock());
  }

  @override
  void dispose() {
    for (final c in [_nameCtrl, _colorCtrl, _metersCtrl, _priceCtrl, _cogsCtrl]) {
      c.removeListener(_emitChange);
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _checkShortStock() async {
    if (!_isShopStock || _selectedSkuId == null) {
      if (_shortStock) setState(() => _shortStock = false);
      return;
    }
    final qtyMilli = parseMetersToMilli(_metersCtrl.text);
    if (qtyMilli <= 0) {
      if (_shortStock) setState(() => _shortStock = false);
      return;
    }
    final service = await ref.read(clothStockServiceProvider.future);
    final short = await service.wouldBeShortStock(
      skuInternalId: _selectedSkuId!,
      qtyMilli: qtyMilli,
    );
    if (mounted && short != _shortStock) {
      setState(() => _shortStock = short);
    }
  }

  void _emitChange() {
    _checkShortStock();
    widget.onChanged(_buildResult());
  }

  OrderComposerFabricResult? _buildResult() {
    final name = _nameCtrl.text.trim();
    final color = _colorCtrl.text.trim();
    final meters = _metersCtrl.text.trim();
    final priceMinor = tryParseMoneyAmount(_priceCtrl.text) ?? 0;
    final cogsMinor = tryParseMoneyAmount(_cogsCtrl.text) ?? 0;
    if (name.isEmpty &&
        color.isEmpty &&
        meters.isEmpty &&
        priceMinor <= 0 &&
        !_isShopStock) {
      return null;
    }
    var id = _fabricId.trim();
    if (id.isEmpty && (name.isNotEmpty || color.isNotEmpty)) {
      id = generateFabricId();
      _fabricId = id;
    }
    return OrderComposerFabricResult(
      fabricName: name,
      fabricColor: color,
      fabricId: id,
      fabricNamePresetInternalId: _namePresetId,
      fabricColorPresetInternalId: _colorPresetId,
      clothMeters: meters,
      clothPriceAmountMinor: priceMinor,
      clothSourceIndex: _clothSourceIndex,
      clothStockSkuInternalId: _isShopStock ? _selectedSkuId : null,
      clothSaleCostAmountMinor: _isShopStock ? cogsMinor : 0,
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

  void _setSource(int index) {
    setState(() {
      _clothSourceIndex = index;
      if (!_isShopStock) {
        _selectedSkuId = null;
        _cogsCtrl.clear();
      }
    });
    _emitChange();
  }

  void _selectSku(ClothStockSkuSummary sku) {
    setState(() {
      _selectedSkuId = sku.internalId;
      if (_nameCtrl.text.trim().isEmpty) _nameCtrl.text = sku.name;
      if (_colorCtrl.text.trim().isEmpty && sku.color.trim().isNotEmpty) {
        _colorCtrl.text = sku.color;
      }
    });
    _emitChange();
  }

  Future<void> _createSkuInline() async {
    final shopId = effectiveShopIdFromAuth(ref.read(authSessionProvider).shopId);
    final codeCtrl = TextEditingController();
    final nameCtrl = TextEditingController(text: _nameCtrl.text.trim());
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(widget.l10n.clothStockSkuCreateTitle),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeCtrl,
              decoration: InputDecoration(
                labelText: widget.l10n.clothStockSkuCodeLabel,
                border: const OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: nameCtrl,
              decoration: InputDecoration(
                labelText: widget.l10n.clothStockSkuNameLabel,
                border: const OutlineInputBorder(),
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(widget.l10n.ordersComposerPaymentCancelCta),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(widget.l10n.saveCta),
          ),
        ],
      ),
    );
    final code = codeCtrl.text.trim();
    final name = nameCtrl.text.trim();
    codeCtrl.dispose();
    nameCtrl.dispose();
    if (ok != true || name.isEmpty) return;
    final id = const Uuid().v4();
    final repo = await ref.read(clothStockRepositoryProvider.future);
    await repo.upsertSku(
      shopId: shopId,
      internalId: id,
      skuCode: code.isEmpty ? id.substring(0, 8) : code,
      name: name,
      color: _colorCtrl.text.trim(),
      fabricNamePresetInternalId: _namePresetId,
      fabricColorPresetInternalId: _colorPresetId,
    );
    enqueueClothSkuUpsert(
      ref,
      internalId: id,
      skuCode: code.isEmpty ? id.substring(0, 8) : code,
      name: name,
      color: _colorCtrl.text.trim(),
      fabricNamePresetInternalId: _namePresetId,
      fabricColorPresetInternalId: _colorPresetId,
    );
    if (!mounted) return;
    setState(() {
      _clothSourceIndex = 1;
      _selectedSkuId = id;
      _nameCtrl.text = name;
    });
    _emitChange();
  }

  void _clear() {
    setState(() {
      _namePresetId = null;
      _colorPresetId = null;
      _fabricId = '';
      _clothSourceIndex = 0;
      _selectedSkuId = null;
      _shortStock = false;
      _nameCtrl.clear();
      _colorCtrl.clear();
      _metersCtrl.clear();
      _priceCtrl.clear();
      _cogsCtrl.clear();
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
    final skusAsync = ref.watch(clothStockSkusStreamProvider);

    return Column(
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
        SegmentedButton<int>(
          segments: [
            ButtonSegment(
              value: 0,
              label: Text(widget.l10n.clothSourceCustomerSupplied),
            ),
            ButtonSegment(
              value: 1,
              label: Text(widget.l10n.clothSourceShopStock),
            ),
          ],
          selected: {_clothSourceIndex},
          onSelectionChanged: (s) => _setSource(s.first),
        ),
        if (_isShopStock) ...[
          const SizedBox(height: 10),
          skusAsync.when(
            data: (skus) {
              if (skus.isEmpty) {
                return OutlinedButton.icon(
                  onPressed: _createSkuInline,
                  icon: const Icon(Icons.add),
                  label: Text(widget.l10n.clothStockSkuCreateCta),
                );
              }
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  DropdownButtonFormField<String>(
                    value: _selectedSkuId,
                    decoration: InputDecoration(
                      labelText: widget.l10n.clothStockSkuLabel,
                      border: const OutlineInputBorder(),
                      isDense: true,
                    ),
                    hint: Text(widget.l10n.clothStockSkuHint),
                    items: [
                      for (final sku in skus)
                        DropdownMenuItem(
                          value: sku.internalId,
                          child: Text(
                            '${sku.name} (${formatMilliMeters(sku.qtyOnHandMilli)} m)',
                          ),
                        ),
                    ],
                    onChanged: (id) {
                      if (id == null) return;
                      final sku = skus.firstWhere((s) => s.internalId == id);
                      _selectSku(sku);
                    },
                  ),
                  Align(
                    alignment: AlignmentDirectional.centerStart,
                    child: TextButton.icon(
                      onPressed: _createSkuInline,
                      icon: const Icon(Icons.add, size: 18),
                      label: Text(widget.l10n.clothStockSkuCreateCta),
                    ),
                  ),
                ],
              );
            },
            loading: () => const LinearProgressIndicator(),
            error: (e, _) => Text('$e'),
          ),
        ],
        const SizedBox(height: 10),
        _presetChips(
          async: namesAsync,
          selectedId: _namePresetId,
          onSelect: _selectName,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _nameCtrl,
          onChanged: (_) {
            _onNameEdited();
            setState(() {});
          },
          decoration: InputDecoration(
            labelText: widget.l10n.ordersComposerFabricNameLabel,
            hintText: widget.l10n.ordersComposerFabricNameHint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        _presetChips(
          async: colorsAsync,
          selectedId: _colorPresetId,
          onSelect: _selectColor,
        ),
        const SizedBox(height: 6),
        TextField(
          controller: _colorCtrl,
          onChanged: (_) {
            _onColorEdited();
            setState(() {});
          },
          decoration: InputDecoration(
            labelText: widget.l10n.ordersComposerFabricColorLabel,
            hintText: widget.l10n.ordersComposerFabricColorHint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        const SizedBox(height: 10),
        TextField(
          controller: _metersCtrl,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            labelText: widget.l10n.ordersComposerClothMetersLabel,
            hintText: widget.l10n.ordersComposerClothMetersHint,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
        ),
        if (_shortStock) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.warning_amber_rounded,
                size: 18,
                color: Theme.of(context).colorScheme.error,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  widget.l10n.clothStockShortWarning,
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.error,
                      ),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 10),
        PrideMoneyField(
          controller: _priceCtrl,
          labelText: widget.l10n.ordersComposerClothPriceLabel,
        ),
        if (_isShopStock) ...[
          const SizedBox(height: 10),
          PrideMoneyField(
            controller: _cogsCtrl,
            labelText: widget.l10n.clothSaleCostLabel,
          ),
        ],
        const SizedBox(height: 8),
        Align(
          alignment: AlignmentDirectional.centerStart,
          child: TextButton(
            onPressed: _clear,
            child: Text(widget.l10n.ordersComposerFabricClearCta),
          ),
        ),
      ],
    );
  }
}
