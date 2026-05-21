import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/calendar/app_calendar_format.dart';
import 'package:pride_v3/core/calendar/date_calendar_notifier.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';

/// Full-screen catalog image with pinch-zoom; description on demand.
class CatalogFullscreenViewer extends ConsumerStatefulWidget {
  const CatalogFullscreenViewer({super.key, required this.itemId});

  final String itemId;

  static Future<void> open(BuildContext context, String itemId) {
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => CatalogFullscreenViewer(itemId: itemId),
      ),
    );
  }

  @override
  ConsumerState<CatalogFullscreenViewer> createState() =>
      _CatalogFullscreenViewerState();
}

class _CatalogFullscreenViewerState extends ConsumerState<CatalogFullscreenViewer> {
  final _transformController = TransformationController();

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
  }

  void _resetZoom() {
    _transformController.value = Matrix4.identity();
  }

  Future<void> _showDescriptionSheet(
    BuildContext context,
    AppLocalizations l10n, {
    required String designName,
    required String designerLine,
    String? notes,
  }) async {
    await showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      builder: (ctx) {
        final body = (notes != null && notes.trim().isNotEmpty)
            ? notes.trim()
            : l10n.catalogNoDescription;
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.catalogDescriptionSheetTitle,
                  style: Theme.of(ctx).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  designName,
                  style: Theme.of(ctx).textTheme.titleMedium,
                ),
                const SizedBox(height: 4),
                Text(
                  designerLine,
                  style: Theme.of(ctx).textTheme.bodySmall,
                ),
                const SizedBox(height: 16),
                Text(
                  body,
                  style: Theme.of(ctx).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final locale = Localizations.localeOf(context).toString();
    final calendar = ref.watch(dateCalendarSystemProvider);
    final myShopId = ref.watch(effectiveShopIdProvider);
    final itemAsync = ref.watch(catalogItemDetailProvider(widget.itemId));

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: itemAsync.maybeWhen(
          data: (item) => item == null
              ? null
              : Text(
                  item.designName,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
          orElse: () => null,
        ),
        actions: [
          itemAsync.maybeWhen(
            data: (item) {
              if (item == null || item.shopId != myShopId) {
                return const SizedBox.shrink();
              }
              return IconButton(
                tooltip: l10n.catalogViewerManageA11y,
                icon: const Icon(Icons.tune_outlined),
                onPressed: () {
                  Navigator.of(context).pop();
                  context.push('/app/catalog/${widget.itemId}');
                },
              );
            },
            orElse: () => const SizedBox.shrink(),
          ),
        ],
      ),
      body: itemAsync.when(
        loading: () => const Center(
          child: CircularProgressIndicator(color: Colors.white54),
        ),
        error: (e, _) => Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              '$e',
              style: const TextStyle(color: Colors.white70),
              textAlign: TextAlign.center,
            ),
          ),
        ),
        data: (item) {
          if (item == null) {
            return Center(
              child: Text(
                l10n.catalogItemNotFound,
                style: const TextStyle(color: Colors.white70),
                textAlign: TextAlign.center,
              ),
            );
          }

          final designerLine = l10n.catalogDesignerAndDate(
            item.designerShopName,
            AppCalendarFormat.mediumDate(
              l10n,
              calendar,
              item.createdAt,
              locale,
            ),
          );
          final hasNotes = item.notes != null && item.notes!.trim().isNotEmpty;

          return Column(
            children: [
              Expanded(
                child: GestureDetector(
                  onDoubleTap: _resetZoom,
                  child: InteractiveViewer(
                    transformationController: _transformController,
                    minScale: 0.5,
                    maxScale: 5,
                    child: Center(
                      child: _FullscreenImage(path: item.imagePath),
                    ),
                  ),
                ),
              ),
              Material(
                color: Colors.black87,
                child: SafeArea(
                  top: false,
                  child: Padding(
                    padding: const EdgeInsets.fromLTRB(12, 8, 12, 12),
                    child: Align(
                      alignment: Alignment.center,
                      child: FilledButton.tonal(
                        onPressed: () => _showDescriptionSheet(
                          context,
                          l10n,
                          designName: item.designName,
                          designerLine: designerLine,
                          notes: hasNotes ? item.notes : null,
                        ),
                        style: FilledButton.styleFrom(
                          visualDensity: VisualDensity.compact,
                          foregroundColor: Colors.white,
                          backgroundColor: Colors.white24,
                        ),
                        child: Text(l10n.catalogViewDescription),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class _FullscreenImage extends StatelessWidget {
  const _FullscreenImage({required this.path});

  final String? path;

  @override
  Widget build(BuildContext context) {
    if (kIsWeb || path == null || path!.isEmpty) {
      return const Icon(Icons.image_outlined, size: 72, color: Colors.white38);
    }

    final file = File(path!);
    return Image.file(
      file,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) {
        return const Icon(
          Icons.broken_image_outlined,
          size: 72,
          color: Colors.white38,
        );
      },
    );
  }
}
