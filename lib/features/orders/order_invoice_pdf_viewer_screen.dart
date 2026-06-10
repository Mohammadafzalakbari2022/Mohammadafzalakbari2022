import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

/// In-app PDF viewer with pinch/double-tap zoom (share optional from app bar).
class OrderInvoicePdfViewerScreen extends StatelessWidget {
  const OrderInvoicePdfViewerScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
    required this.shareLabel,
    required this.onShare,
  });

  final List<int> pdfBytes;
  final String title;
  final String shareLabel;
  final VoidCallback onShare;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: shareLabel,
            onPressed: onShare,
          ),
        ],
      ),
      body: PdfPreview.builder(
        build: (format) async => Uint8List.fromList(pdfBytes),
        allowPrinting: false,
        allowSharing: false,
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        useActions: false,
        dynamicLayout: false,
        pdfPreviewPageDecoration: const BoxDecoration(
          color: Colors.white,
        ),
        scrollViewDecoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
        ),
        initialPageFormat: PdfPageFormat.a4,
        pagesBuilder: (context, pages) {
          return ListView.builder(
            padding: const EdgeInsets.symmetric(vertical: 8),
            itemCount: pages.length,
            itemBuilder: (context, index) {
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
                child: _InvoicePdfZoomPage(pageData: pages[index]),
              );
            },
          );
        },
      ),
    );
  }
}

class _InvoicePdfZoomPage extends StatefulWidget {
  const _InvoicePdfZoomPage({required this.pageData});

  final PdfPreviewPageData pageData;

  @override
  State<_InvoicePdfZoomPage> createState() => _InvoicePdfZoomPageState();
}

class _InvoicePdfZoomPageState extends State<_InvoicePdfZoomPage> {
  final _transformController = TransformationController();
  static const double _doubleTapScale = 2.5;

  @override
  void dispose() {
    _transformController.dispose();
    super.dispose();
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
        maxScale: 6,
        child: DecoratedBox(
          decoration: const BoxDecoration(
            color: Colors.white,
            boxShadow: [
              BoxShadow(offset: Offset(0, 2), blurRadius: 4),
            ],
          ),
          child: AspectRatio(
            aspectRatio: widget.pageData.aspectRatio,
            child: Image(
              image: widget.pageData.image,
              fit: BoxFit.contain,
            ),
          ),
        ),
      ),
    );
  }
}
