import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/widgets/pride_action_buttons.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/catalog_item_summary.dart';
import '../../data/providers/local_data_providers.dart';
import 'catalog_fullscreen_viewer.dart';
import 'catalog_shared_download.dart';
import 'catalog_sharing_provider.dart';
import 'catalog_tile_image.dart';
import 'remote_public_catalog_provider.dart';

class CatalogTabScreen extends ConsumerStatefulWidget {
  const CatalogTabScreen({super.key});

  @override
  ConsumerState<CatalogTabScreen> createState() => _CatalogTabScreenState();
}

enum _CatalogSegment { myDesigns, sharedDesigns }

enum _CatalogSort { newest, oldest, nameAsc, nameDesc }

class _CatalogTabScreenState extends ConsumerState<CatalogTabScreen> {
  _CatalogSegment _segment = _CatalogSegment.myDesigns;
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
          (a, b) =>
              a.designName.toLowerCase().compareTo(b.designName.toLowerCase()),
        );
      case _CatalogSort.nameDesc:
        list.sort(
          (a, b) =>
              b.designName.toLowerCase().compareTo(a.designName.toLowerCase()),
        );
    }
    return list;
  }

  void _openSearchDialog(AppLocalizations l10n) {
    final draft = TextEditingController(text: _search.text);
    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: Text(l10n.listToolbarSearchTooltip),
          content: TextField(
            controller: draft,
            autofocus: true,
            textInputAction: TextInputAction.search,
            decoration: InputDecoration(hintText: l10n.catalogSearchHint),
            onSubmitted: (_) {
              _search.text = draft.text;
              setState(() {});
              Navigator.of(ctx).pop();
            },
          ),
          actions: [
            if (_search.text.isNotEmpty)
              TextButton(
                onPressed: () {
                  _search.clear();
                  setState(() {});
                  Navigator.of(ctx).pop();
                },
                child: Text(l10n.ordersFilterClearAll),
              ),
            ...prideDialogCancelSave(
              context: ctx,
              onCancel: () => Navigator.of(ctx).pop(),
              onConfirm: () {
                _search.text = draft.text;
                setState(() {});
                Navigator.of(ctx).pop();
              },
              saveLabel: l10n.ordersFilterApply,
            ),
          ],
        );
      },
    );
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
                        PrideCancelButton(
                          onPressed: () {
                            setModal(() => sort = _CatalogSort.newest);
                          },
                          label: l10n.catalogResetSort,
                        ),
                        const Spacer(),
                        PrideSaveButton(
                          onPressed: () {
                            setState(() => _sort = sort);
                            Navigator.of(sheetContext).pop();
                          },
                          label: l10n.catalogApplySort,
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

  int _gridCrossAxisCount(double width) {
    if (width >= 900) return 4;
    if (width >= 600) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final asyncMy = ref.watch(myCatalogStreamProvider);
    final asyncSharedRemote = ref.watch(remotePublicCatalogProvider);
    final asyncSharedLocal = ref.watch(sharedCatalogStreamProvider);

    final sharedEnabled = ref.watch(catalogSharingEnabledProvider);
    final showShared = _segment == _CatalogSegment.sharedDesigns;
    final catalogAsync = showShared
        ? asyncSharedRemote.when(
            data: (remote) => remote.isNotEmpty
                ? AsyncValue.data(remote)
                : asyncSharedLocal,
            loading: () => asyncSharedLocal,
            error: (e, _) => asyncSharedLocal,
          )
        : asyncMy;
    final emptyMessage =
        showShared ? l10n.catalogSharedDirectoryEmpty : l10n.catalogEmptyMyDesigns;
    final hasSearch = _search.text.trim().isNotEmpty;
    final width = MediaQuery.sizeOf(context).width;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(8, 4, 8, 0),
          child: Row(
                children: [
                  _SegmentIcon(
                    tooltip: l10n.catalogMyDesigns,
                    icon: Icons.folder_outlined,
                    colorIndex: 0,
                    selected: _segment == _CatalogSegment.myDesigns,
                    onPressed: () =>
                        setState(() => _segment = _CatalogSegment.myDesigns),
                  ),
                  _SegmentIcon(
                    tooltip: l10n.catalogSharedDesigns,
                    icon: Icons.public_outlined,
                    colorIndex: 3,
                    selected: _segment == _CatalogSegment.sharedDesigns,
                    enabled: sharedEnabled,
                    onPressed: sharedEnabled
                        ? () => setState(
                              () => _segment = _CatalogSegment.sharedDesigns,
                            )
                        : null,
                  ),
                  const Spacer(),
                  Tooltip(
                    message: l10n.listToolbarSearchTooltip,
                    child: IconButton(
                      icon: Icon(
                        hasSearch ? Icons.search : Icons.search_outlined,
                        color: hasSearch
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: () => _openSearchDialog(l10n),
                    ),
                  ),
                  Tooltip(
                    message: l10n.catalogSortTooltip,
                    child: IconButton(
                      icon: Icon(
                        _sort != _CatalogSort.newest
                            ? Icons.filter_list
                            : Icons.filter_list_outlined,
                        color: _sort != _CatalogSort.newest
                            ? Theme.of(context).colorScheme.primary
                            : null,
                      ),
                      onPressed: () => _openSortSheet(l10n),
                    ),
                  ),
            ],
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
                  return GridView.builder(
                    padding: const EdgeInsets.all(4),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: _gridCrossAxisCount(width),
                      crossAxisSpacing: 4,
                      mainAxisSpacing: 4,
                      childAspectRatio: 0.75,
                    ),
                    itemCount: filtered.length,
                    itemBuilder: (context, i) {
                      final it = filtered[i];
                      final myShopId = ref.read(effectiveShopIdProvider);
                      final isRemoteShared =
                          showShared && it.shopId != myShopId;
                      return Material(
                        color: Theme.of(context).colorScheme.surface,
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: isRemoteShared
                              ? null
                              : () => CatalogFullscreenViewer.openGallery(
                                    context,
                                    items: filtered,
                                    initialIndex: i,
                                  ),
                          child: Stack(
                            fit: StackFit.expand,
                            children: [
                              CatalogTileImage(
                                thumbnailPath: it.thumbnailPath,
                                imagePath: it.imagePath,
                                borderRadius: 0,
                              ),
                              if (isRemoteShared)
                                Positioned(
                                  left: 0,
                                  right: 0,
                                  bottom: 0,
                                  child: Material(
                                    color: Theme.of(context)
                                        .colorScheme
                                        .surface
                                        .withValues(alpha: 0.92),
                                    child: Padding(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 4,
                                        vertical: 2,
                                      ),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            it.designName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .labelSmall,
                                          ),
                                          Text(
                                            it.designerShopName,
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                            style: Theme.of(context)
                                                .textTheme
                                                .bodySmall,
                                          ),
                                          const SizedBox(height: 4),
                                          FilledButton.tonalIcon(
                                            onPressed: kIsWeb
                                                ? null
                                                : () =>
                                                    downloadSharedCatalogItem(
                                                      context,
                                                      ref,
                                                      it,
                                                    ),
                                            icon: const Icon(
                                              Icons.download_outlined,
                                              size: 18,
                                            ),
                                            label: Text(
                                              l10n.catalogP2pDownload,
                                            ),
                                            style: FilledButton.styleFrom(
                                              visualDensity:
                                                  VisualDensity.compact,
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                horizontal: 8,
                                                vertical: 4,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
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
              onPressed:
                  kIsWeb ? null : () => context.push('/app/catalog/new'),
              style: prideButtonStyle(context, PrideButtonVariant.add),
              icon: const Icon(Icons.add),
              label: Text(l10n.catalogAddDesignCta),
            ),
          ),
      ],
    );
  }
}

class _SegmentIcon extends StatelessWidget {
  const _SegmentIcon({
    required this.tooltip,
    required this.icon,
    required this.colorIndex,
    required this.selected,
    required this.onPressed,
    this.enabled = true,
  });

  final String tooltip;
  final IconData icon;
  final int colorIndex;
  final bool selected;
  final bool enabled;
  final VoidCallback? onPressed;

  @override
  Widget build(BuildContext context) {
    final color = prideSettingsIconColor(colorIndex);
    return Tooltip(
      message: tooltip,
      child: IconButton(
        onPressed: enabled ? onPressed : null,
        icon: selected
            ? PrideColoredLeading(icon: icon, color: color)
            : Icon(icon, color: Theme.of(context).colorScheme.onSurfaceVariant),
      ),
    );
  }
}
