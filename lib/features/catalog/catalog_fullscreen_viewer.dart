import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/catalog/catalog_image_ref.dart';
import '../../data/local/catalog_item_summary.dart';

/// Full-screen catalog gallery with pinch/double-tap zoom and swipe navigation.
class CatalogFullscreenViewer extends StatefulWidget {
  const CatalogFullscreenViewer({
    super.key,
    required this.items,
    required this.initialIndex,
  });

  final List<CatalogItemSummary> items;
  final int initialIndex;

  static Future<void> openGallery(
    BuildContext context, {
    required List<CatalogItemSummary> items,
    required int initialIndex,
  }) {
    if (items.isEmpty) return Future.value();
    final index = initialIndex.clamp(0, items.length - 1);
    return Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        fullscreenDialog: true,
        builder: (_) => CatalogFullscreenViewer(
          items: items,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  State<CatalogFullscreenViewer> createState() =>
      _CatalogFullscreenViewerState();
}

class _CatalogFullscreenViewerState extends State<CatalogFullscreenViewer> {
  late final PageController _pageController;
  late int _currentIndex;
  bool _pageScrollEnabled = true;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex.clamp(0, widget.items.length - 1);
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _onPageChanged(int index) {
    setState(() => _currentIndex = index);
  }

  void _onZoomChanged(bool zoomedIn) {
    if (_pageScrollEnabled == !zoomedIn) return;
    setState(() => _pageScrollEnabled = !zoomedIn);
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final item = widget.items[_currentIndex];

    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black87,
        foregroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.close),
          tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Text(
          item.designName,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        actions: [
          if (widget.items.length > 1)
            Center(
              child: Padding(
                padding: const EdgeInsetsDirectional.only(end: 8),
                child: Text(
                  '${_currentIndex + 1}/${widget.items.length}',
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Colors.white70,
                      ),
                ),
              ),
            ),
          IconButton(
            tooltip: l10n.catalogViewerManageA11y,
            icon: const Icon(Icons.tune_outlined),
            onPressed: () {
              Navigator.of(context).pop();
              context.push('/app/catalog/${item.internalId}');
            },
          ),
        ],
      ),
      body: PageView.builder(
        controller: _pageController,
        physics: _pageScrollEnabled
            ? const PageScrollPhysics()
            : const NeverScrollableScrollPhysics(),
        onPageChanged: _onPageChanged,
        itemCount: widget.items.length,
        itemBuilder: (context, index) {
          final pageItem = widget.items[index];
          return _CatalogZoomPage(
            key: ValueKey(pageItem.internalId),
            imagePath: pageItem.imagePath,
            thumbnailPath: pageItem.thumbnailPath,
            onZoomChanged: _onZoomChanged,
          );
        },
      ),
    );
  }
}

class _CatalogZoomPage extends StatefulWidget {
  const _CatalogZoomPage({
    super.key,
    required this.imagePath,
    required this.thumbnailPath,
    required this.onZoomChanged,
  });

  final String? imagePath;
  final String? thumbnailPath;
  final ValueChanged<bool> onZoomChanged;

  @override
  State<_CatalogZoomPage> createState() => _CatalogZoomPageState();
}

class _CatalogZoomPageState extends State<_CatalogZoomPage> {
  final _transformController = TransformationController();
  static const double _doubleTapScale = 2.5;

  @override
  void initState() {
    super.initState();
    _transformController.addListener(_handleTransformChanged);
  }

  @override
  void dispose() {
    _transformController.removeListener(_handleTransformChanged);
    _transformController.dispose();
    super.dispose();
  }

  void _handleTransformChanged() {
    final zoomed = _transformController.value.getMaxScaleOnAxis() > 1.01;
    widget.onZoomChanged(zoomed);
  }

  void _handleDoubleTap(TapDownDetails details) {
    final matrix = _transformController.value;
    if (matrix.getMaxScaleOnAxis() > 1.01) {
      _transformController.value = Matrix4.identity();
      return;
    }

    final offset = details.localPosition;
    final dx = -offset.dx * (_doubleTapScale - 1);
    final dy = -offset.dy * (_doubleTapScale - 1);
    _transformController.value = Matrix4.identity()
      ..translate(dx, dy)
      ..scale(_doubleTapScale);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onDoubleTapDown: _handleDoubleTap,
      child: InteractiveViewer(
        transformationController: _transformController,
        minScale: 0.5,
        maxScale: 5,
        child: Center(
          child: _CatalogFullscreenImage(
            imagePath: widget.imagePath,
            thumbnailPath: widget.thumbnailPath,
          ),
        ),
      ),
    );
  }
}

class _CatalogFullscreenImage extends StatelessWidget {
  const _CatalogFullscreenImage({
    required this.imagePath,
    required this.thumbnailPath,
  });

  final String? imagePath;
  final String? thumbnailPath;

  @override
  Widget build(BuildContext context) {
    final path = (imagePath != null && imagePath!.isNotEmpty)
        ? imagePath
        : thumbnailPath;

    if (path == null || path.isEmpty) {
      return const Icon(Icons.image_outlined, size: 72, color: Colors.white38);
    }

    if (isCatalogAssetImageRef(path)) {
      final assetPath = catalogBundleAssetPath(path);
      if (assetPath != null) {
        return Image.asset(
          'assets/catalog_seed/$assetPath',
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

    if (kIsWeb) {
      return const Icon(Icons.image_outlined, size: 72, color: Colors.white38);
    }

    final file = File(path);
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
