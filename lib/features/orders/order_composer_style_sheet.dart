import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/style/style_order_selection.dart';
import '../../data/local/style_name_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../catalog/catalog_tile_image.dart';
import 'order_composer_catalog_picker.dart';
import 'order_composer_shape_config_draft.dart';
import 'order_composer_shape_select_tile.dart';

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
  String initialMainStyle = '',
  String? initialStyleNameInternalId,
  StyleOrderSelection initialSelection = const StyleOrderSelection.empty(),
  String? initialCatalogItemInternalId,
  String initialCatalogDesignName = '',
  String initialCatalogDesignerShopName = '',
  String? initialCatalogImagePath,
  String? initialCatalogThumbnailPath,
}) {
  return showPrideModalBottomSheet<OrderComposerStyleResult>(
    context: context,
    builder: (ctx) => _OrderComposerStyleSheet(
      initialMainStyle: initialMainStyle,
      initialStyleNameInternalId: initialStyleNameInternalId,
      initialSelection: initialSelection,
      initialCatalogItemInternalId: initialCatalogItemInternalId,
      initialCatalogDesignName: initialCatalogDesignName,
      initialCatalogDesignerShopName: initialCatalogDesignerShopName,
      initialCatalogImagePath: initialCatalogImagePath,
      initialCatalogThumbnailPath: initialCatalogThumbnailPath,
    ),
  );
}

class _OrderComposerStyleSheet extends ConsumerStatefulWidget {
  const _OrderComposerStyleSheet({
    required this.initialMainStyle,
    this.initialStyleNameInternalId,
    required this.initialSelection,
    this.initialCatalogItemInternalId,
    this.initialCatalogDesignName = '',
    this.initialCatalogDesignerShopName = '',
    this.initialCatalogImagePath,
    this.initialCatalogThumbnailPath,
  });

  final String initialMainStyle;
  final String? initialStyleNameInternalId;
  final StyleOrderSelection initialSelection;
  final String? initialCatalogItemInternalId;
  final String initialCatalogDesignName;
  final String initialCatalogDesignerShopName;
  final String? initialCatalogImagePath;
  final String? initialCatalogThumbnailPath;

  @override
  ConsumerState<_OrderComposerStyleSheet> createState() =>
      _OrderComposerStyleSheetState();
}

class _OrderComposerStyleSheetState
    extends ConsumerState<_OrderComposerStyleSheet> {
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
  }

  void _onCustomStyleEdited() {
    final names = ref.read(styleNamesStreamProvider).valueOrNull;
    if (names == null || _selectedStyleNameId == null) return;
    final match = names.where((n) => n.internalId == _selectedStyleNameId);
    if (match.isEmpty) return;
    if (match.first.name.trim() != _customStyleCtrl.text.trim()) {
      setState(() => _selectedStyleNameId = null);
    }
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
  }

  void _save() {
    final l10n = AppLocalizations.of(context)!;
    final main = _mainStyleName;
    if (main.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.ordersComposerStyleRequired)),
      );
      return;
    }

    _syncNotesFromControllers();

    final figures = ref.read(styleAllFiguresStreamProvider).valueOrNull ?? [];
    final configs =
        ref.read(styleAllFigureConfigsProvider).valueOrNull ?? const {};

    final selection = buildStyleOrderSelectionFromDrafts(
      selectedFigureIds: _selectedFigureIds,
      drafts: _drafts,
      allFigures: figures,
      configs: configs,
    );

    final summary = StyleOrderSelection.buildSummary(
      mainStyleName: main,
      selection: selection,
      figures: figures,
    );

    Navigator.pop(
      context,
      OrderComposerStyleResult(
        mainStyleName: main,
        styleNameInternalId: _selectedStyleNameId,
        selection: selection,
        summary: summary,
        catalogItemInternalId: _catalogItemInternalId,
        catalogDesignName: _catalogDesignName,
        catalogDesignerShopName: _catalogDesignerShopName,
        catalogImagePath: _catalogImagePath,
        catalogThumbnailPath: _catalogThumbnailPath,
      ),
    );
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
  }

  void _clearCatalogDesign() {
    setState(() {
      _catalogItemInternalId = null;
      _catalogDesignName = '';
      _catalogDesignerShopName = '';
      _catalogImagePath = null;
      _catalogThumbnailPath = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final namesAsync = ref.watch(styleNamesStreamProvider);
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);
    final configsAsync = ref.watch(styleAllFigureConfigsProvider);

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
                        l10n.ordersComposerStyleSheetTitle,
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
                      decoration: InputDecoration(
                        labelText: l10n.ordersComposerStyleCustomLabel,
                        hintText: l10n.ordersComposerStyleCustomHint,
                        border: const OutlineInputBorder(),
                        isDense: true,
                      ),
                    ),
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
                                    style:
                                        Theme.of(context).textTheme.bodySmall,
                                  ),
                              ],
                            ),
                          ),
                        ],
                      ),
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
                          return Text(l10n.ordersComposerStyleNoFigures);
                        }
                        return configsAsync.when(
                          data: (configs) => LayoutBuilder(
                            builder: (context, constraints) {
                              const spacing = 8.0;
                              final columns = orderComposerShapeGridColumns(
                                constraints.maxWidth,
                              );
                              final itemWidth = columns == 1
                                  ? constraints.maxWidth
                                  : (constraints.maxWidth -
                                          spacing * (columns - 1)) /
                                      columns;
                              return Wrap(
                                spacing: spacing,
                                runSpacing: spacing,
                                children: [
                                  for (final figure in listFigures)
                                    SizedBox(
                                      width: itemWidth,
                                      child: OrderComposerShapeSelectTile(
                                        figure: figure,
                                        config: configs[figure.internalId],
                                        draft: _drafts[figure.internalId] ??
                                            ShapeConfigDraft(
                                              shapeId: figure.internalId,
                                            ),
                                        selected: _selectedFigureIds
                                            .contains(figure.internalId),
                                        onToggleSelected: () =>
                                            _toggleFigure(figure.internalId),
                                        onDraftChanged: (draft) =>
                                            _onDraftChanged(
                                              figure.internalId,
                                              draft,
                                            ),
                                        l10n: l10n,
                                        noteController:
                                            _noteControllers[figure.internalId],
                                      ),
                                    ),
                                ],
                              );
                            },
                          ),
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
            ],
          ),
        );
      },
    );
  }
}
