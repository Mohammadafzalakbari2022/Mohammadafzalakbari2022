import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/seed_data.dart';
import '../../data/local/style/style_figure_display_name.dart';
import '../../data/local/style/style_figure_image_ref.dart';
import '../../data/local/style_figure_summary.dart';
import '../../data/providers/local_data_providers.dart';
import '../../licensing/license_providers.dart';
import 'style/style_figure_image.dart';
import 'style/style_figure_pick_image.dart';
import 'style/style_sync_helpers.dart';

class SettingsStyleFiguresScreen extends ConsumerWidget {
  const SettingsStyleFiguresScreen({super.key});

  Future<String> _defaultPartId(WidgetRef ref) async {
    final parts = ref.read(stylePartsStreamProvider).valueOrNull;
    if (parts != null) {
      final active = parts.where((p) => p.isActive);
      if (active.isNotEmpty) return active.first.internalId;
    }
    return DevSeedIds.stylePartSleeve;
  }

  Future<void> _addFigure(BuildContext context, WidgetRef ref) async {
    final l10n = AppLocalizations.of(context)!;
    if (kIsWeb) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsStyleFigureWebOnlyBody)),
      );
      return;
    }

    final imageRef = await pickStyleFigureImageRef(context);
    if (imageRef == null || !context.mounted) return;

    final partId = await _defaultPartId(ref);
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    final id = await repo.createStyleFigure(
      shopId: ref.read(effectiveShopIdProvider),
      partInternalId: partId,
      name: '',
      imageRef: imageRef,
    );
    enqueueStyleFigureUpsert(
      ref,
      internalId: id,
      partInternalId: partId,
      name: '',
      imageRef: imageRef,
      isActive: true,
    );
  }

  int _crossAxisCount(double width) {
    if (width >= 700) return 4;
    if (width >= 500) return 3;
    return 2;
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final figuresAsync = ref.watch(styleAllFiguresStreamProvider);
    final canEdit = !ref.watch(licenseEditingBlockedProvider);
    final width = MediaQuery.sizeOf(context).width;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: Text(l10n.settingsStyleFiguresTitle),
      ),
      floatingActionButton: canEdit && !kIsWeb
          ? FloatingActionButton.extended(
              onPressed: () => _addFigure(context, ref),
              icon: const Icon(Icons.add_photo_alternate_outlined),
              label: Text(l10n.settingsStyleFigureAddCta),
            )
          : null,
      body: figuresAsync.when(
        data: (figures) {
          final sorted = List<StyleFigureSummary>.from(figures)
            ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
          if (sorted.isEmpty) {
            return Center(child: Text(l10n.settingsStyleFiguresEmpty));
          }
          return GridView.builder(
            padding: const EdgeInsets.fromLTRB(8, 8, 8, 88),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: _crossAxisCount(width),
              mainAxisSpacing: 8,
              crossAxisSpacing: 8,
              childAspectRatio: 0.78,
            ),
            itemCount: sorted.length,
            itemBuilder: (context, index) {
              return _FigureTile(
                figure: sorted[index],
                canEdit: canEdit,
                l10n: l10n,
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('$e')),
      ),
    );
  }
}

class _FigureTile extends ConsumerWidget {
  const _FigureTile({
    required this.figure,
    required this.canEdit,
    required this.l10n,
  });

  final StyleFigureSummary figure;
  final bool canEdit;
  final AppLocalizations l10n;

  Future<void> _deleteCustomFigure(
    BuildContext context,
    WidgetRef ref,
  ) async {
    if (StyleFigureImageRef.isBundledAssetRef(figure.imageRef)) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(l10n.settingsStyleFigureBundledDeleteBlocked)),
      );
      return;
    }
    final ok = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(l10n.settingsStyleFigureDeleteTitle),
        content: Text(l10n.settingsStyleFigureDeleteBody),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: Text(MaterialLocalizations.of(ctx).cancelButtonLabel),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(ctx, true),
            child: Text(l10n.deleteCta),
          ),
        ],
      ),
    );
    if (ok != true || !context.mounted) return;
    enqueueStyleFigureDelete(ref, internalId: figure.internalId);
    final repo = await ref.read(styleCatalogRepositoryProvider.future);
    await repo.softDeleteStyleFigure(figure.internalId);
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final displayName = resolveStyleFigureSummaryDisplayName(figure);
    final isBundled = StyleFigureImageRef.isBundledAssetRef(figure.imageRef);

    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: figure.isActive
              ? Theme.of(context).colorScheme.outlineVariant
              : Theme.of(context).colorScheme.outline,
        ),
      ),
      child: InkWell(
        onTap: () => context.push(
          '/app/settings/style/figures/${figure.internalId}',
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Stack(
                fit: StackFit.expand,
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8),
                    child: StyleFigureImage(
                      imageRef: figure.imageRef,
                      fit: BoxFit.contain,
                      expand: true,
                    ),
                  ),
                  if (!figure.isActive)
                    Positioned(
                      top: 4,
                      left: 4,
                      child: DecoratedBox(
                        decoration: BoxDecoration(
                          color: Colors.black54,
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 6,
                            vertical: 2,
                          ),
                          child: Text(
                            l10n.settingsStyleInactiveLabel,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 11,
                            ),
                          ),
                        ),
                      ),
                    ),
                  if (canEdit && !isBundled)
                    Positioned(
                      top: 2,
                      right: 2,
                      child: Material(
                        color: Colors.black54,
                        shape: const CircleBorder(),
                        clipBehavior: Clip.antiAlias,
                        child: InkWell(
                          onTap: () => _deleteCustomFigure(context, ref),
                          child: const Padding(
                            padding: EdgeInsets.all(4),
                            child: Icon(
                              Icons.close,
                              size: 18,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    displayName,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.labelLarge,
                  ),
                  Text(
                    l10n.settingsStyleFigureTapToConfigure,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context).colorScheme.onSurfaceVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
