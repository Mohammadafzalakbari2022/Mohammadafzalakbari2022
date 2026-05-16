import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/style/style_order_selection.dart';
import '../../data/local/style_name_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../style/style_figure_image_grid.dart';

class OrderComposerStyleResult {
  const OrderComposerStyleResult({
    required this.mainStyleName,
    this.styleNameInternalId,
    required this.selection,
    required this.summary,
  });

  final String mainStyleName;
  final String? styleNameInternalId;
  final StyleOrderSelection selection;
  final String summary;
}

Future<OrderComposerStyleResult?> showOrderComposerStyleSheet({
  required BuildContext context,
  required WidgetRef ref,
  String initialMainStyle = '',
  String? initialStyleNameInternalId,
  StyleOrderSelection initialSelection = const StyleOrderSelection.empty(),
}) {
  return showModalBottomSheet<OrderComposerStyleResult>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    builder: (ctx) => _OrderComposerStyleSheet(
      initialMainStyle: initialMainStyle,
      initialStyleNameInternalId: initialStyleNameInternalId,
      initialSelection: initialSelection,
    ),
  );
}

class _OrderComposerStyleSheet extends ConsumerStatefulWidget {
  const _OrderComposerStyleSheet({
    required this.initialMainStyle,
    this.initialStyleNameInternalId,
    required this.initialSelection,
  });

  final String initialMainStyle;
  final String? initialStyleNameInternalId;
  final StyleOrderSelection initialSelection;

  @override
  ConsumerState<_OrderComposerStyleSheet> createState() =>
      _OrderComposerStyleSheetState();
}

class _OrderComposerStyleSheetState
    extends ConsumerState<_OrderComposerStyleSheet> {
  late final TextEditingController _customStyleCtrl;
  late Set<String> _selectedFigureIds;
  String? _selectedStyleNameId;

  @override
  void initState() {
    super.initState();
    _customStyleCtrl = TextEditingController(text: widget.initialMainStyle);
    _selectedFigureIds =
        Set<String>.from(widget.initialSelection.selectedFigureIds);
    _selectedStyleNameId = widget.initialStyleNameInternalId;
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
    super.dispose();
  }

  String get _mainStyleName => _customStyleCtrl.text.trim();

  void _selectStyleName(StyleNameSummary name) {
    setState(() {
      _selectedStyleNameId = name.internalId;
      _customStyleCtrl.text = name.name;
    });
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
    final selection = StyleOrderSelection(Set.from(_selectedFigureIds));
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
      ),
    );
  }

  int _crossAxisCount(double width) {
    if (width >= 700) return 5;
    if (width >= 500) return 4;
    return 3;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final namesAsync = ref.watch(styleNamesStreamProvider);
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);
    final width = MediaQuery.sizeOf(context).width;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.92,
      minChildSize: 0.5,
      maxChildSize: 0.96,
      builder: (context, scrollController) {
        return Material(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 8, 8, 0),
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
                  padding: const EdgeInsets.fromLTRB(12, 8, 12, 24),
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
                      l10n.ordersComposerStyleFiguresTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 8),
                    figuresAsync.when(
                      data: (figures) {
                        final active = figures
                            .where((f) => f.isActive)
                            .toList(growable: false);
                        if (active.isEmpty) {
                          return Text(l10n.ordersComposerStyleNoFigures);
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            StyleFigureImageGrid(
                              figures: active,
                              selectedFigureIds: _selectedFigureIds,
                              onMultiSelectionChanged: (ids) {
                                setState(() => _selectedFigureIds = ids);
                              },
                              crossAxisCount: _crossAxisCount(width),
                              padding: EdgeInsets.zero,
                            ),
                            if (_selectedFigureIds.isNotEmpty)
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    setState(() => _selectedFigureIds = {});
                                  },
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
