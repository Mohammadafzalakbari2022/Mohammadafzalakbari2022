import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:pride_v3/l10n/app_localizations.dart';



import '../../data/local/style/style_order_selection.dart';

import '../../data/local/style_figure_summary.dart';

import '../../data/local/style_name_summary.dart';

import '../../data/providers/local_data_providers.dart';

import '../catalog/catalog_tile_image.dart';

import '../style/style_figure_image_grid.dart';

import 'order_composer_catalog_picker.dart';

import 'order_composer_shape_config_draft.dart';

import 'order_composer_shape_config_panel.dart';



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

  return showModalBottomSheet<OrderComposerStyleResult>(

    context: context,

    isScrollControlled: true,

    useSafeArea: true,

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

  String? _expandedShapeId;

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

    _expandedShapeId = _selectedFigureIds.isEmpty

        ? null

        : _firstSelectedFigureId(

            _selectedFigureIds,

            ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [],

          );

    _selectedStyleNameId = widget.initialStyleNameInternalId;

    _catalogItemInternalId = widget.initialCatalogItemInternalId;

    _catalogDesignName = widget.initialCatalogDesignName;

    _catalogDesignerShopName = widget.initialCatalogDesignerShopName;

    _catalogImagePath = widget.initialCatalogImagePath;

    _catalogThumbnailPath = widget.initialCatalogThumbnailPath;

    _customStyleCtrl.addListener(_onCustomStyleEdited);

  }



  String? _firstSelectedFigureId(
    Set<String> selectedIds,
    List<StyleFigureSummary> allFigures,
  ) {
    final sorted = allFigures
        .where((f) => selectedIds.contains(f.internalId))
        .toList()
      ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
    return sorted.isEmpty ? null : sorted.first.internalId;
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

    super.dispose();

  }



  String get _mainStyleName => _customStyleCtrl.text.trim();



  void _selectStyleName(StyleNameSummary name) {

    setState(() {

      _selectedStyleNameId = name.internalId;

      _customStyleCtrl.text = name.name;

    });

  }



  void _onFigureSelectionChanged(Set<String> ids) {

    setState(() {

      _drafts.removeWhere((key, _) => !ids.contains(key));

      _selectedFigureIds = ids;

      if (ids.isEmpty) {

        _expandedShapeId = null;

      } else if (_expandedShapeId == null || !ids.contains(_expandedShapeId)) {

        final figures =

            ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [];

        _expandedShapeId = _firstSelectedFigureId(ids, figures);

      }

    });

  }



  void _clearFigureSelection() {

    setState(() {

      _selectedFigureIds = {};

      _drafts.clear();

      _expandedShapeId = null;

    });

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



  int _crossAxisCount(double width) {

    if (width >= 700) return 4;

    if (width >= 500) return 3;

    return 2;

  }



  @override

  Widget build(BuildContext context) {

    final l10n = AppLocalizations.of(context)!;

    final namesAsync = ref.watch(styleNamesStreamProvider);

    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);

    final configsAsync = ref.watch(styleAllFigureConfigsProvider);

    final width = MediaQuery.sizeOf(context).width;



    return DraggableScrollableSheet(

      expand: false,

      initialChildSize: 0.92,

      minChildSize: 0.5,

      maxChildSize: 0.96,

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

                        final active =

                            names.where((n) => n.isActive).toList();

                        if (active.isEmpty) {

                          return const SizedBox.shrink();

                        }

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

                                if (_catalogDesignerShopName

                                    .trim()

                                    .isNotEmpty)

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

                        final gridFigures = figuresForOrderSelectionGrid(

                          figures,

                          _selectedFigureIds,

                        );

                        if (gridFigures.isEmpty) {

                          return Text(l10n.ordersComposerStyleNoFigures);

                        }

                        return Column(

                          crossAxisAlignment: CrossAxisAlignment.stretch,

                          children: [

                            StyleFigureImageGrid(

                              figures: gridFigures,

                              selectedFigureIds: _selectedFigureIds,

                              onMultiSelectionChanged: _onFigureSelectionChanged,

                              crossAxisCount: _crossAxisCount(width),

                              padding: EdgeInsets.zero,

                              showDisplayNames: true,

                            ),

                            if (_selectedFigureIds.isNotEmpty)

                              Align(

                                alignment: Alignment.centerRight,

                                child: TextButton(

                                  onPressed: _clearFigureSelection,

                                  child: Text(

                                    l10n.ordersComposerStyleClearFigures,

                                  ),

                                ),

                              ),

                          ],

                        );

                      },

                      loading: () => const LinearProgressIndicator(),

                      error: (e, _) => Text('$e'),

                    ),

                    if (_selectedFigureIds.isNotEmpty)

                      configsAsync.when(

                        data: (configs) => Padding(

                          padding: const EdgeInsets.only(top: 16),

                          child: OrderComposerShapeConfigPanel(

                            selectedFigureIds: _selectedFigureIds,

                            allFigures: figuresAsync.valueOrNull ?? const [],

                            configs: configs,

                            drafts: _drafts,

                            expandedShapeId: _expandedShapeId,

                            onExpandedShapeChanged: (id) {

                              setState(() => _expandedShapeId = id);

                            },

                            onDraftChanged: _onDraftChanged,

                          ),

                        ),

                        loading: () => const Padding(

                          padding: EdgeInsets.only(top: 16),

                          child: LinearProgressIndicator(),

                        ),

                        error: (e, _) => Padding(

                          padding: const EdgeInsets.only(top: 16),

                          child: Text('$e'),

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


