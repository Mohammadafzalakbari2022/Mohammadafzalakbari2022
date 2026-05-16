import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/local/seed_data.dart';
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
    if (width >= 700) return 5;
    if (width >= 500) return 4;
    return 3;
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
      body: figuresAsync.when(
        data: (figures) {
          final active =
              figures.where((f) => f.isActive).toList(growable: false);
          if (active.isEmpty) {
            return Center(child: Text(l10n.settingsStyleFiguresEmpty));
          }
          return Stack(
            children: [
              GridView.builder(
                padding: const EdgeInsets.fromLTRB(4, 4, 4, 72),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: _crossAxisCount(width),
                  mainAxisSpacing: 4,
                  crossAxisSpacing: 4,
                  childAspectRatio: 1,
                ),
                itemCount: active.length,
                itemBuilder: (context, index) {
                  return _FigureTile(
                    figure: active[index],
                    canEdit: canEdit,
                    l10n: l10n,
                  );
                },
              ),
              if (canEdit && !kIsWeb)
                Positioned(
                  right: 12,
                  bottom: 12,
                  child: FloatingActionButton.small(
                    heroTag: 'style_figure_add',
                    tooltip: l10n.settingsStyleFigureAddCta,
                    onPressed: () => _addFigure(context, ref),
                    child: const Icon(Icons.add_photo_alternate_outlined),
                  ),
                ),
            ],
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Material(
      color: Theme.of(context).colorScheme.surfaceContainerHighest,
      clipBehavior: Clip.antiAlias,
      child: Stack(
        fit: StackFit.expand,
        children: [
          StyleFigureImage(
            imageRef: figure.imageRef,
            fit: BoxFit.cover,
            expand: true,
          ),
          if (canEdit)
            Positioned(
              top: 2,
              right: 2,
              child: Material(
                color: Colors.black54,
                shape: const CircleBorder(),
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () async {
                    final ok = await showDialog<bool>(
                      context: context,
                      builder: (ctx) => AlertDialog(
                        title: Text(l10n.settingsStyleFigureDeleteTitle),
                        content: Text(l10n.settingsStyleFigureDeleteBody),
                        actions: [
                          TextButton(
                            onPressed: () => Navigator.pop(ctx, false),
                            child: Text(
                              MaterialLocalizations.of(ctx).cancelButtonLabel,
                            ),
                          ),
                          FilledButton(
                            onPressed: () => Navigator.pop(ctx, true),
                            child: Text(l10n.deleteCta),
                          ),
                        ],
                      ),
                    );
                    if (ok != true || !context.mounted) return;
                    enqueueStyleFigureDelete(
                      ref,
                      internalId: figure.internalId,
                    );
                    final repo =
                        await ref.read(styleCatalogRepositoryProvider.future);
                    await repo.softDeleteStyleFigure(figure.internalId);
                  },
                  child: const Padding(
                    padding: EdgeInsets.all(4),
                    child: Icon(Icons.close, size: 18, color: Colors.white),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
