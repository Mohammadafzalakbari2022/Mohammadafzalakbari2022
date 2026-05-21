import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../auth/auth_providers.dart';
import '../../data/providers/local_data_providers.dart';

/// Full-screen catalog image with pinch-zoom.
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

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
              if (item == null) return const SizedBox.shrink();
              final isOwnShop = item.shopId == myShopId;
              return IconButton(
                tooltip: isOwnShop
                    ? l10n.catalogViewerManageA11y
                    : l10n.catalogDetailTitle,
                icon: Icon(
                  isOwnShop ? Icons.tune_outlined : Icons.info_outline,
                ),
                onPressed: () {
                  if (isOwnShop) Navigator.of(context).pop();
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

          return GestureDetector(
            onDoubleTap: _resetZoom,
            child: InteractiveViewer(
              transformationController: _transformController,
              minScale: 0.5,
              maxScale: 5,
              child: Center(
                child: _FullscreenImage(path: item.imagePath),
              ),
            ),
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
