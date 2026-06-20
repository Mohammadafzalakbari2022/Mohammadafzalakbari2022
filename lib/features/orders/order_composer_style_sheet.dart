import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/core/widgets/pride_optional_field.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/entities/garment_type.dart';
import '../../data/local/style/style_catalog_garment_helpers.dart';
import '../../data/local/style/style_order_selection.dart';
import '../../data/local/style/style_part_section_label.dart';
import 'order_composer_item_card.dart';
import '../../data/local/style_figure_config_summary.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/local/style_name_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../catalog/catalog_tile_image.dart';
import 'order_composer_catalog_picker.dart';
import 'order_composer_shape_config_draft.dart';
import 'order_composer_shape_select_tile.dart';
import 'order_composer_reference.dart';
import '../../data/local/order_item_summary.dart';
import '../../data/local/order_summary.dart';

class OrderComposerStyleResult {
  const OrderComposerStyleResult({
    required this.mainStyleName,
    this.styleNameInternalId,
    required this.selection,
    required this.summary,
    this.catalogItemInternalId,
    this.catalogDesignName = '',
    this.catalogDesignerShopName = '',
    this.catalogImagePath,
    this.catalogThumbnailPath,
  });

  final String mainStyleName;
  final String? styleNameInternalId;
  final StyleOrderSelection selection;
  final String summary;
  final String? catalogItemInternalId;
  final String catalogDesignName;
  final String catalogDesignerShopName;
  final String? catalogImagePath;
  final String? catalogThumbnailPath;

  bool get hasCatalogDesign => catalogDesignName.trim().isNotEmpty;
}

Future<OrderComposerStyleResult?> showOrderComposerStyleSheet({
  required BuildContext context,
  required WidgetRef ref,
  GarmentType? garmentType,
  String initialMainStyle = '',
  String? initialStyleNameInternalId,
  StyleOrderSelection initialSelection = const StyleOrderSelection.empty(),
  String? initialCatalogItemInternalId,
  String initialCatalogDesignName = '',
  String initialCatalogDesignerShopName = '',
  String? initialCatalogImagePath,
  String? initialCatalogThumbnailPath,
  OrderSummary? referenceOrder,
  OrderItemSummary? referenceItem,
  VoidCallback? onUsePreviousStyle,
  VoidCallback? onUsePreviousDesign,
  String Function(AppLocalizations l10n, int minor)? moneyFormatter,
  String initialStyleSummary = '',
}) {
  return showPrideModalBottomSheet<OrderComposerStyleResult>(
    context: context,
    builder: (ctx) => OrderComposerStylePanel(
      garmentType: garmentType,
      initialMainStyle: initialMainStyle,
      initialStyleNameInternalId: initialStyleNameInternalId,
      initialSelection: initialSelection,
      initialCatalogItemInternalId: initialCatalogItemInternalId,
      initialCatalogDesignName: initialCatalogDesignName,
      initialCatalogDesignerShopName: initialCatalogDesignerShopName,
      initialCatalogImagePath: initialCatalogImagePath,
      initialCatalogThumbnailPath: initialCatalogThumbnailPath,
      referenceOrder: referenceOrder,
      referenceItem: referenceItem,
      onUsePreviousStyle: onUsePreviousStyle,
      onUsePreviousDesign: onUsePreviousDesign,
      moneyFormatter: moneyFormatter,
      initialStyleSummary: initialStyleSummary,
    ),
  );
}

/// Style + shapes panel (modal sheet or inline receipt block).
class OrderComposerStylePanel extends ConsumerStatefulWidget {
  const OrderComposerStylePanel({
    super.key,
    this.garmentType,
    required this.initialMainStyle,
    this.initialStyleNameInternalId,
    required this.initialSelection,
    this.initialCatalogItemInternalId,
    this.initialCatalogDesignName = '',
    this.initialCatalogDesignerShopName = '',
    this.initialCatalogImagePath,
    this.initialCatalogThumbnailPath,
    this.referenceOrder,
    this.referenceItem,
    this.onUsePreviousStyle,
    this.onUsePreviousDesign,
    this.moneyFormatter,
    this.initialStyleSummary = '',
    this.embedded = false,
    this.onChanged,
  });

  final GarmentType? garmentType;
  final String initialMainStyle;
  final String? initialStyleNameInternalId;
  final StyleOrderSelection initialSelection;
  final String? initialCatalogItemInternalId;
  final String initialCatalogDesignName;
  final String initialCatalogDesignerShopName;
  final String? initialCatalogImagePath;
  final String? initialCatalogThumbnailPath;
  final OrderSummary? referenceOrder;
  final OrderItemSummary? referenceItem;
  final VoidCallback? onUsePreviousStyle;
  final VoidCallback? onUsePreviousDesign;
  final String Function(AppLocalizations l10n, int minor)? moneyFormatter;
  final String initialStyleSummary;
  final bool embedded;
  final ValueChanged<OrderComposerStyleResult?>? onChanged;

  @override
  ConsumerState<OrderComposerStylePanel> createState() =>
      _OrderComposerStylePanelState();
}

class _OrderComposerStylePanelState
    extends ConsumerState<OrderComposerStylePanel> {
  late final TextEditingController _customStyleCtrl;
  late Set<String> _selectedFigureIds;
  late Map<String, ShapeConfigDraft> _drafts;
  final Map<String, TextEditingController> _noteControllers = {};

  String? _selectedStyleNameId;
  String? _catalogItemInternalId;
  String _catalogDesignName = '';
  String _catalogDesignerShopName = '';
  String? _catalogImagePath;
  String? _catalogThumbnailPath;

  @override
  void initState() {
    super.initState();
    _customStyleCtrl = TextEditingController(text: widget.initialMainStyle);
    _selectedFigureIds =
        Set<String>.from(widget.initialSelection.selectedFigureIds);
    _drafts = restoreShapeConfigDrafts(widget.initialSelection);
    for (final entry in _drafts.entries) {
      _noteControllers[entry.key] =
          TextEditingController(text: entry.value.note);
    }
    _selectedStyleNameId = widget.initialStyleNameInternalId;
    _catalogItemInternalId = widget.initialCatalogItemInternalId;
    _catalogDesignName = widget.initialCatalogDesignName;
    _catalogDesignerShopName = widget.initialCatalogDesignerShopName;
    _catalogImagePath = widget.initialCatalogImagePath;
    _catalogThumbnailPath = widget.initialCatalogThumbnailPath;
    _customStyleCtrl.addListener(_onCustomStyleEdited);
    if (widget.embedded) {
      WidgetsBinding.instance.addPostFrameCallback((_) => _emitIfEmbedded());
    }
  }

  GarmentType get _garment =>
      widget.garmentType ?? GarmentType.perahanTunban;

  void _onCustomStyleEdited() {
    final names = ref.read(styleNamesForGarmentProvider(_garment)).valueOrNull;
    if (names == null || _selectedStyleNameId == null) {
      _emitIfEmbedded();
      return;
    }
    final match = names.where((n) => n.internalId == _selectedStyleNameId);
    if (match.isEmpty) {
      _emitIfEmbedded();
      return;
    }
    if (match.first.name.trim() != _customStyleCtrl.text.trim()) {
      setState(() => _selectedStyleNameId = null);
    }
    _emitIfEmbedded();
  }

  @override
  void dispose() {
    _customStyleCtrl.removeListener(_onCustomStyleEdited);
    _customStyleCtrl.dispose();
    for (final c in _noteControllers.values) {
      c.dispose();
    }
    super.dispose();
  }

  String get _mainStyleName => _customStyleCtrl.text.trim();

  void _selectStyleName(StyleNameSummary name) {
    setState(() {
      _selectedStyleNameId = name.internalId;
      _customStyleCtrl.text = name.name;
    });
    _emitIfEmbedded();
  }

  void _toggleFigure(String id) {
    setState(() {
      if (_selectedFigureIds.contains(id)) {
        _selectedFigureIds.remove(id);
        _drafts.remove(id);
        _noteControllers.remove(id)?.dispose();
      } else {
        _selectedFigureIds.add(id);
        _drafts[id] = ShapeConfigDraft(shapeId: id);
        _noteControllers[id] = TextEditingController();
      }
    });
    _emitIfEmbedded();
  }

  void _syncNotesFromControllers() {
    for (final id in _selectedFigureIds) {
      final draft = _drafts[id];
      final ctrl = _noteControllers[id];
      if (draft != null && ctrl != null) {
        draft.note = ctrl.text;
      }
    }
  }

  void _onDraftChanged(String shapeId, ShapeConfigDraft draft) {
    setState(() => _drafts[shapeId] = draft);
    _emitIfEmbedded();
  }

  OrderComposerStyleResult? _buildResult({bool allowEmpty = false}) {
    final main = _mainStyleName;
    if (main.isEmpty && !allowEmpty) return null;

    _syncNotesFromControllers();

    final figures =
        ref.read(styleFiguresForGarmentProvider(_garment)).valueOrNull ?? [];
    final configs = ref
            .read(styleFigureConfigsForGarmentProvider(_garment))
            .valueOrNull ??
        const {};

    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: _selectedFigureIds,
      drafts: _drafts,
      allFigures: figures,
      configs: configs,
    );

    final summary = main.isEmpty
        ? ''
        : StyleOrderSelection.buildSummary(
            mainStyleName: main,
            selection: selection,
            figures: figures,
          );

    return OrderComposerStyleResult(
      mainStyleName: main,
      styleNameInternalId: _selectedStyleNameId,
      selection: selection,
      summary: summary,
      catalogItemInternalId: _catalogItemInternalId,
      catalogDesignName: _catalogDesignName,
      catalogDesignerShopName: _catalogDesignerShopName,
      catalogImagePath: _catalogImagePath,
      catalogThumbnailPath: _catalogThumbnailPath,
    );
  }

  void _emitIfEmbedded() {
    if (!widget.embedded || widget.onChanged == null) return;
    widget.onChanged!(_buildResult(allowEmpty: true));
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final result = _buildResult();
    if (result == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ordersComposerStyleRequired)),
      );
      return;
    }

    if (widget.embedded) {
      widget.onChanged?.call(result);
      return;
    }

    Navigator.pop(context, result);
  }

  Future<void> _openCatalogPicker() async {
    final picked = await showOrderComposerCatalogPicker(
      context: context,
      ref: ref,
      selectedId: _catalogItemInternalId,
    );
    if (!mounted || picked == null) return;
    setState(() {
      _catalogItemInternalId = picked.internalId;
      _catalogDesignName = picked.designName;
      _catalogDesignerShopName = picked.designerShopName;
      _catalogImagePath = picked.imagePath;
      _catalogThumbnailPath = picked.thumbnailPath;
    });
    _emitIfEmbedded();
  }

  void _clearCatalogDesign() {
    setState(() {
      _catalogItemInternalId = null;
      _catalogDesignName = '';
      _catalogDesignerShopName = '';
      _catalogImagePath = null;
      _catalogThumbnailPath = null;
    });
    _emitIfEmbedded();
  }

  List<Widget> _buildPanelChildren(AppLocalizations l10n, GarmentType garment) {
    final namesAsync = ref.watch(styleNamesForGarmentProvider(garment));
    final figuresAsync = ref.watch(styleFiguresForGarmentProvider(garment));
    final partsAsync = ref.watch(stylePartsForGarmentProvider(garment));
    final configsAsync =
        ref.watch(styleFigureConfigsForGarmentProvider(garment));
    final styleEmpty = _mainStyleName.isEmpty &&
        _selectedFigureIds.isEmpty &&
        _catalogDesignName.trim().isEmpty;

    return [
      if (widget.referenceOrder != null && widget.moneyFormatter != null)
        ComposerSheetPreviousHeader(
          title: widget.garmentType != null
              ? '${composerGarmentLabel(l10n, widget.garmentType!)} · ${l10n.ordersComposerStyleSheetTitle}'
              : l10n.ordersComposerStyleSheetTitle,
          previousSection: ComposerSheetPreviousSection(
            referenceOrder: widget.referenceOrder!,
            referenceItem: widget.referenceItem,
            kind: ComposerSheetPreviousKind.style,
            currentTextForDiff: widget.initialStyleSummary,
            currentIsMeaningfulForDiff:
                widget.initialStyleSummary.trim().isNotEmpty,
            onUsePrevious: widget.onUsePreviousStyle,
            money: widget.moneyFormatter!,
          ),
        ),
      PrideOptionalPanel(
        isEmpty: styleEmpty,
        padding: const EdgeInsets.fromLTRB(0, 4, 0, 4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              l10n.ordersComposerStyleMainTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            namesAsync.when(
              data: (names) {
                final active = names.where((n) => n.isActive).toList();
                if (active.isEmpty) return const SizedBox.shrink();
                return Wrap(
                  spacing: 8,
                  runSpacing: 4,
                  children: [
                    for (final n in active)
                      ChoiceChip(
                        label: Text(n.name),
                        selected: _selectedStyleNameId == n.internalId,
                        onSelected: (_) => _selectStyleName(n),
                      ),
                  ],
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: _customStyleCtrl,
              decoration: prideOptionalDecoration(
                context,
                base: InputDecoration(
                  labelText: l10n.ordersComposerStyleCustomLabel,
                  hintText: l10n.ordersComposerStyleCustomHint,
                  border: const OutlineInputBorder(),
                ),
                isEmpty: _mainStyleName.isEmpty,
              ),
            ),
            if (garment == GarmentType.perahanTunban) ...[
              const SizedBox(height: 16),
              Text(
                l10n.ordersComposerCatalogDesignTitle,
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const SizedBox(height: 8),
              if (_catalogDesignName.trim().isEmpty)
                Text(
                  l10n.ordersComposerCatalogDesignNone,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: Theme.of(context).colorScheme.outline,
                      ),
                )
              else
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    CatalogTileImage(
                      thumbnailPath: _catalogThumbnailPath,
                      imagePath: _catalogImagePath,
                      dimension: 72,
                      borderRadius: 10,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            _catalogDesignName,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(fontWeight: FontWeight.w600),
                          ),
                          if (_catalogDesignerShopName.trim().isNotEmpty)
                            Text(
                              _catalogDesignerShopName,
                              style: Theme.of(context).textTheme.bodySmall,
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              if (widget.referenceOrder != null &&
                  widget.garmentType == GarmentType.perahanTunban) ...[
                const SizedBox(height: 8),
                ComposerDesignPreviousReference(
                  referenceOrder: widget.referenceOrder!,
                  l10n: l10n,
                  currentDesignSummary: _catalogDesignName,
                  currentIsMeaningfulForDiff:
                      _catalogDesignName.trim().isNotEmpty,
                  onUsePrevious: widget.onUsePreviousDesign,
                ),
              ],
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 4,
                children: [
                  FilledButton.tonalIcon(
                    onPressed: _openCatalogPicker,
                    icon: const Icon(Icons.collections_outlined),
                    label: Text(l10n.ordersComposerCatalogChooseCta),
                  ),
                  if (_catalogDesignName.trim().isNotEmpty)
                    TextButton(
                      onPressed: _clearCatalogDesign,
                      child: Text(l10n.ordersComposerCatalogClearCta),
                    ),
                ],
              ),
            ],
            const SizedBox(height: 16),
            Text(
              l10n.ordersComposerStyleFiguresTitle,
              style: Theme.of(context).textTheme.titleSmall,
            ),
            const SizedBox(height: 8),
            figuresAsync.when(
              data: (figures) {
                final listFigures = figuresForOrderSelectionGrid(
                  figures,
                  _selectedFigureIds,
                );
                if (listFigures.isEmpty) {
                  if (garment == GarmentType.waistcoat) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          l10n.ordersComposerWaistcoatStyleEmptyTitle,
                          style: Theme.of(context).textTheme.titleSmall,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          l10n.ordersComposerWaistcoatStyleEmptySubtitle,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: Theme.of(context)
                                    .colorScheme
                                    .onSurfaceVariant,
                              ),
                        ),
                      ],
                    );
                  }
                  return Text(l10n.ordersComposerStyleNoFigures);
                }
                return configsAsync.when(
                  data: (configs) {
                    if (garment == GarmentType.waistcoat) {
                      final parts = partsAsync.valueOrNull ?? const [];
                      final sections = groupStyleFiguresByPart(
                        figures: listFigures,
                        parts: parts,
                      );
                      return Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          for (final section in sections) ...[
                            Padding(
                              padding: const EdgeInsets.only(bottom: 4),
                              child: Text(
                                stylePartSectionLabel(section.part.name),
                                style: Theme.of(context).textTheme.labelLarge,
                              ),
                            ),
                            _ComposerFigureGrid(
                              figures: section.figures,
                              configs: configs,
                              selectedFigureIds: _selectedFigureIds,
                              drafts: _drafts,
                              noteControllers: _noteControllers,
                              onToggleFigure: _toggleFigure,
                              onDraftChanged: _onDraftChanged,
                              l10n: l10n,
                            ),
                            const SizedBox(height: 12),
                          ],
                        ],
                      );
                    }
                    return _ComposerFigureGrid(
                      figures: listFigures,
                      configs: configs,
                      selectedFigureIds: _selectedFigureIds,
                      drafts: _drafts,
                      noteControllers: _noteControllers,
                      onToggleFigure: _toggleFigure,
                      onDraftChanged: _onDraftChanged,
                      l10n: l10n,
                    );
                  },
                  loading: () => const LinearProgressIndicator(),
                  error: (e, _) => Text('$e'),
                );
              },
              loading: () => const LinearProgressIndicator(),
              error: (e, _) => Text('$e'),
            ),
          ],
        ),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final garment = _garment;

    if (widget.embedded) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildPanelChildren(l10n, garment),
      );
    }

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: kPrideSheetInitialChildSize,
      minChildSize: kPrideSheetMinChildSize,
      maxChildSize: kPrideSheetMaxChildSize,
      builder: (context, scrollController) {
        final keyboard = MediaQuery.viewInsetsOf(context).bottom;
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
                        widget.garmentType != null
                            ? '${composerGarmentLabel(l10n, widget.garmentType!)} · ${l10n.ordersComposerStyleSheetTitle}'
                            : l10n.ordersComposerStyleSheetTitle,
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
                  padding: EdgeInsets.fromLTRB(12, 8, 12, 24 + keyboard),
                  children: _buildPanelChildren(l10n, garment),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _ComposerFigureGrid extends StatelessWidget {
  const _ComposerFigureGrid({
    required this.figures,
    required this.configs,
    required this.selectedFigureIds,
    required this.drafts,
    required this.noteControllers,
    required this.onToggleFigure,
    required this.onDraftChanged,
    required this.l10n,
  });

  final List<StyleFigureSummary> figures;
  final Map<String, StyleFigureConfigSummary> configs;
  final Set<String> selectedFigureIds;
  final Map<String, ShapeConfigDraft> drafts;
  final Map<String, TextEditingController> noteControllers;
  final void Function(String id) onToggleFigure;
  final void Function(String id, ShapeConfigDraft draft) onDraftChanged;
  final AppLocalizations l10n;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        const spacing = 8.0;
        final columns = orderComposerShapeGridColumns(constraints.maxWidth);
        final itemWidth = columns == 1
            ? constraints.maxWidth
            : (constraints.maxWidth - spacing * (columns - 1)) / columns;
        return Wrap(
          spacing: spacing,
          runSpacing: spacing,
          children: [
            for (final figure in figures)
              SizedBox(
                width: itemWidth,
                child: OrderComposerShapeSelectTile(
                  figure: figure,
                  config: configs[figure.internalId],
                  draft: drafts[figure.internalId] ??
                      ShapeConfigDraft(shapeId: figure.internalId),
                  selected: selectedFigureIds.contains(figure.internalId),
                  onToggleSelected: () => onToggleFigure(figure.internalId),
                  onDraftChanged: (draft) =>
                      onDraftChanged(figure.internalId, draft),
                  l10n: l10n,
                  noteController: noteControllers[figure.internalId],
                ),
              ),
          ],
        );
      },
    );
  }
}
