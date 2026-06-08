import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/pride_modal_bottom_sheet.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/catalog_item_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../catalog/catalog_tile_image.dart';

enum CatalogSort { newest, oldest, nameAsc, nameDesc }

List<CatalogItemSummary> applyCatalogSort(
  List<CatalogItemSummary> items,
  CatalogSort sort,
) {
  final list = [...items];
  switch (sort) {
    case CatalogSort.newest:
      list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    case CatalogSort.oldest:
      list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
    case CatalogSort.nameAsc:
      list.sort((a, b) => a.designName.compareTo(b.designName));
    case CatalogSort.nameDesc:
      list.sort((a, b) => b.designName.compareTo(a.designName));
  }
  return list;
}

class CatalogPickResult {
  const CatalogPickResult({
    required this.internalId,
    required this.designName,
    required this.designerShopName,
    this.imagePath,
    this.thumbnailPath,
  });

  final String internalId;
  final String designName;
  final String designerShopName;
  final String? imagePath;
  final String? thumbnailPath;
}

Future<CatalogPickResult?> showOrderComposerCatalogPicker({
  required BuildContext context,
  required WidgetRef ref,
  String? selectedId,
}) {
  return showPrideModalBottomSheet<CatalogPickResult>(
    context: context,
    builder: (ctx) => _OrderComposerCatalogPickerSheet(
      selectedId: selectedId,
    ),
  );
}

class _OrderComposerCatalogPickerSheet extends ConsumerStatefulWidget {
  const _OrderComposerCatalogPickerSheet({this.selectedId});

  final String? selectedId;

  @override
  ConsumerState<_OrderComposerCatalogPickerSheet> createState() =>
      _OrderComposerCatalogPickerSheetState();
}

class _OrderComposerCatalogPickerSheetState
    extends ConsumerState<_OrderComposerCatalogPickerSheet> {
  final _searchController = TextEditingController();
  CatalogSort _sort = CatalogSort.newest;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  List<CatalogItemSummary> _filter(List<CatalogItemSummary> items) {
    final q = _searchController.text.trim().toLowerCase();
    var list = items;
    if (q.isNotEmpty) {
      list = list
          .where(
            (c) =>
                c.designName.toLowerCase().contains(q) ||
                c.designerShopName.toLowerCase().contains(q),
          )
          .toList();
    }
    return applyCatalogSort(list, _sort);
  }

  int _crossAxisCount(double width) {
    if (width >= 700) return 4;
    if (width >= 500) return 3;
    return 2;
  }

  void _pick(CatalogItemSummary item) {
    Navigator.pop(
      context,
      CatalogPickResult(
        internalId: item.internalId,
        designName: item.designName,
        designerShopName: item.designerShopName,
        imagePath: item.imagePath,
        thumbnailPath: item.thumbnailPath,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final itemsAsync = ref.watch(myCatalogStreamProvider);
    final width = MediaQuery.sizeOf(context).width;

    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: kPrideSheetInitialChildSize,
      minChildSize: kPrideSheetMinChildSize,
      maxChildSize: kPrideSheetMaxChildSize,
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
                        l10n.ordersComposerCatalogPickerTitle,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.fromLTRB(12, 0, 12, 8),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => setState(() {}),
                  decoration: InputDecoration(
                    hintText: l10n.catalogSearchHint,
                    prefixIcon: const Icon(Icons.search),
                    isDense: true,
                    border: const OutlineInputBorder(),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12),
                child: Row(
                  children: [
                    Text(
                      l10n.catalogSortSectionTitle,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: DropdownButton<CatalogSort>(
                        isExpanded: true,
                        value: _sort,
                        items: [
                          DropdownMenuItem(
                            value: CatalogSort.newest,
                            child: Text(l10n.catalogSortNewest),
                          ),
                          DropdownMenuItem(
                            value: CatalogSort.oldest,
                            child: Text(l10n.catalogSortOldest),
                          ),
                          DropdownMenuItem(
                            value: CatalogSort.nameAsc,
                            child: Text(l10n.catalogSortNameAsc),
                          ),
                          DropdownMenuItem(
                            value: CatalogSort.nameDesc,
                            child: Text(l10n.catalogSortNameDesc),
                          ),
                        ],
                        onChanged: (v) {
                          if (v == null) return;
                          setState(() => _sort = v);
                        },
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: itemsAsync.when(
                  data: (items) {
                    final filtered = _filter(items);
                    if (filtered.isEmpty) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Text(
                            l10n.ordersComposerCatalogPickerEmpty,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      );
                    }
                    return GridView.builder(
                      controller: scrollController,
                      padding: const EdgeInsets.all(12),
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: _crossAxisCount(width),
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10,
                        childAspectRatio: 0.72,
                      ),
                      itemCount: filtered.length,
                      itemBuilder: (context, index) {
                        final item = filtered[index];
                        final selected = item.internalId == widget.selectedId;
                        return Material(
                          color: selected
                              ? Theme.of(context)
                                  .colorScheme
                                  .primaryContainer
                                  .withValues(alpha: 0.5)
                              : Theme.of(context).colorScheme.surface,
                          borderRadius: BorderRadius.circular(12),
                          clipBehavior: Clip.antiAlias,
                          child: InkWell(
                            onTap: () => _pick(item),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.stretch,
                              children: [
                                Expanded(
                                  child: CatalogTileImage(
                                    thumbnailPath: item.thumbnailPath,
                                    imagePath: item.imagePath,
                                    borderRadius: 0,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8),
                                  child: Text(
                                    item.designName,
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelLarge
                                        ?.copyWith(fontWeight: FontWeight.w600),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                  loading: () =>
                      const Center(child: CircularProgressIndicator()),
                  error: (e, _) => Center(child: Text('$e')),
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
