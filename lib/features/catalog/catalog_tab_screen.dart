import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/catalog_item_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'catalog_sharing_provider.dart';
import 'catalog_tile_image.dart';

class CatalogTabScreen extends ConsumerStatefulWidget {
  const CatalogTabScreen({super.key});

  @override
  ConsumerState<CatalogTabScreen> createState() => _CatalogTabScreenState();
}

enum _CatalogSegment { myDesigns, sharedDesigns }

enum _CatalogSort { newest, oldest, nameAsc, nameDesc }

class _CatalogTabScreenState extends ConsumerState<CatalogTabScreen> {
  _CatalogSegment _segment = _CatalogSegment.myDesigns;
  bool _grid = true;
  _CatalogSort _sort = _CatalogSort.newest;
  final _search = TextEditingController();

  @override
  void dispose() {
    _search.dispose();
    super.dispose();
  }

  List<CatalogItemSummary> _applySearch(List<CatalogItemSummary> items) {
    final q = _search.text.trim().toLowerCase();
    if (q.isEmpty) return items;
    return items
        .where((i) =>
            i.designName.toLowerCase().contains(q) ||
            i.designerShopName.toLowerCase().contains(q))
        .toList();
  }

  List<CatalogItemSummary> _applySort(List<CatalogItemSummary> items) {
    final list = [...items];
    switch (_sort) {
      case _CatalogSort.newest:
        list.sort((a, b) => b.createdAt.compareTo(a.createdAt));
      case _CatalogSort.oldest:
        list.sort((a, b) => a.createdAt.compareTo(b.createdAt));
      case _CatalogSort.nameAsc:
        list.sort(
          (a, b) => a.designName.toLowerCase().compareTo(b.designName.toLowerCase()),
        );
      case _CatalogSort.nameDesc:
        list.sort(
          (a, b) => b.designName.toLowerCase().compareTo(a.designName.toLowerCase()),
        );
    }
    return list;
  }

  void _openSortSheet(AppLocalizations l10n) {
    var sort = _sort;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (sheetContext) {
        return StatefulBuilder(
          builder: (context, setModal) {
            return SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Text(
                      l10n.catalogSortSheetTitle,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const SizedBox(height: 16),
                    Text(
                      l10n.catalogSortSectionTitle,
                      style: Theme.of(context).textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    ListTile(
                      title: Text(l10n.catalogSortNewest),
                      trailing: sort == _CatalogSort.newest
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(() => sort = _CatalogSort.newest),
                    ),
                    ListTile(
                      title: Text(l10n.catalogSortOldest),
                      trailing: sort == _CatalogSort.oldest
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(() => sort = _CatalogSort.oldest),
                    ),
                    ListTile(
                      title: Text(l10n.catalogSortNameAsc),
                      trailing: sort == _CatalogSort.nameAsc
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(() => sort = _CatalogSort.nameAsc),
                    ),
                    ListTile(
                      title: Text(l10n.catalogSortNameDesc),
                      trailing: sort == _CatalogSort.nameDesc
                          ? const Icon(Icons.check)
                          : null,
                      onTap: () => setModal(() => sort = _CatalogSort.nameDesc),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      children: [
                        TextButton(
                          onPressed: () {
                            setModal(() => sort = _CatalogSort.newest);
                          },
                          child: Text(l10n.catalogResetSort),
                        ),
                        const Spacer(),
                        FilledButton(
                          onPressed: () {
                            setState(() => _sort = sort);
                            Navigator.of(sheetContext).pop();
                          },
                          child: Text(l10n.catalogApplySort),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final asyncMy = ref.watch(myCatalogStreamProvider);
    final asyncShared = ref.watch(sharedCatalogStreamProvider);

    final sharedEnabled = ref.watch(catalogSharingEnabledProvider);
    final showShared = _segment == _CatalogSegment.sharedDesigns;
    final catalogAsync = showShared ? asyncShared : asyncMy;
    final emptyMessage =
        showShared ? l10n.catalogSharedDirectoryEmpty : l10n.catalogEmptyMyDesigns;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: Row(
            children: [
              Expanded(
                child: SegmentedButton<_CatalogSegment>(
                  segments: [
                    ButtonSegment(
                      value: _CatalogSegment.myDesigns,
                      label: Text(l10n.catalogMyDesigns),
                    ),
                    ButtonSegment(
                      value: _CatalogSegment.sharedDesigns,
                      label: Text(l10n.catalogSharedDesigns),
                      enabled: sharedEnabled,
                    ),
                  ],
                  selected: {_segment},
                  onSelectionChanged: (s) {
                    setState(() => _segment = s.first);
                  },
                ),
              ),
              const SizedBox(width: 8),
              IconButton(
                onPressed: () => _openSortSheet(l10n),
                icon: const Icon(Icons.filter_list),
                tooltip: l10n.catalogSortTooltip,
              ),
              IconButton(
                onPressed: () => setState(() => _grid = !_grid),
                icon: Icon(_grid ? Icons.view_list : Icons.grid_view),
                tooltip: _grid ? l10n.catalogListView : l10n.catalogGridView,
              ),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: SearchBar(
            hintText: l10n.catalogSearchHint,
            controller: _search,
            leading: const Icon(Icons.search),
            trailing: [
              if (_search.text.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.clear),
                  onPressed: () => setState(() => _search.clear()),
                ),
            ],
            onChanged: (_) => setState(() {}),
          ),
        ),
        Padding(
          padding: const EdgeInsets.fromLTRB(12, 8, 12, 0),
          child: SwitchListTile.adaptive(
            contentPadding: EdgeInsets.zero,
            title: Text(l10n.catalogSharingToggleTitle),
            subtitle: Text(l10n.catalogSharingToggleSubtitle),
            value: sharedEnabled,
            onChanged: (v) {
              ref.read(catalogSharingEnabledProvider.notifier).state = v;
              if (!v && _segment == _CatalogSegment.sharedDesigns) {
                setState(() => _segment = _CatalogSegment.myDesigns);
              }
            },
          ),
        ),
        Expanded(
          child: catalogAsync.when(
            data: (items) {
              final filtered = _applySort(_applySearch(items));
              if (filtered.isEmpty) {
                return Center(
                  child: Padding(
                    padding: const EdgeInsets.all(24),
                    child: Text(
                      emptyMessage,
                      textAlign: TextAlign.center,
                    ),
                  ),
                );
              }
              if (_grid) {
                return GridView.builder(
                  padding: const EdgeInsets.all(12),
                  gridDelegate:
                      const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 0.95,
                  ),
                  itemCount: filtered.length,
                  itemBuilder: (context, i) {
                    final it = filtered[i];
                    return InkWell(
                      onTap: () => context.push('/app/catalog/${it.internalId}'),
                      child: Card(
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Expanded(
                                child: CatalogTileImage(
                                  thumbnailPath: it.thumbnailPath,
                                  imagePath: it.imagePath,
                                  borderRadius: 12,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                it.designName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall,
                              ),
                              Text(
                                it.designerShopName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                              Text(
                                AppCalendarFormat.mediumDate(
                                  l10n,
                                  calendar,
                                  it.createdAt,
                                  locale,
                                ),
                                style:
                                    Theme.of(context).textTheme.bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                );
              }
              return ListView.separated(
                padding: const EdgeInsets.symmetric(vertical: 8),
                itemCount: filtered.length,
                separatorBuilder: (context, index) =>
                    const Divider(height: 1),
                itemBuilder: (context, i) {
                  final it = filtered[i];
                  return ListTile(
                    leading: CatalogTileImage(
                      thumbnailPath: it.thumbnailPath,
                      imagePath: it.imagePath,
                      borderRadius: 8,
                      dimension: 56,
                    ),
                    title: Text(it.designName),
                    subtitle: Text(
                      '${it.designerShopName} · ${AppCalendarFormat.mediumDate(l10n, calendar, it.createdAt, locale)}',
                    ),
                    trailing: (showShared || it.isSharedPublic)
                        ? const Icon(Icons.public)
                        : null,
                    onTap: () =>
                        context.push('/app/catalog/${it.internalId}'),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (e, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text('$e', textAlign: TextAlign.center),
              ),
            ),
          ),
        ),
        if (!showShared)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
            child: FilledButton.icon(
              onPressed: kIsWeb ? null : () => context.push('/app/catalog/new'),
              icon: const Icon(Icons.add),
              label: Text(l10n.catalogAddDesignCta),
            ),
          ),
      ],
    );
  }
}

