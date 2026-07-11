import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdfx/pdfx.dart';

import '../../core/printing/invoice_pdf_validation.dart';

/// In-app PDF viewer with pinch-zoom; share optional from the app bar.
class OrderInvoicePdfViewerScreen extends StatefulWidget {
  const OrderInvoicePdfViewerScreen({
    super.key,
    required this.pdfBytes,
    required this.title,
    required this.shareLabel,
    required this.onShare,
    required this.invalidPdfMessage,
  });

  final List<int> pdfBytes;
  final String title;
  final String shareLabel;
  final Future<void> Function() onShare;
  final String invalidPdfMessage;

  @override
  State<OrderInvoicePdfViewerScreen> createState() =>
      _OrderInvoicePdfViewerScreenState();
}

class _OrderInvoicePdfViewerScreenState
    extends State<OrderInvoicePdfViewerScreen> {
  PdfController? _controller;
  var _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _openDocument();
  }

  Future<void> _openDocument() async {
    try {
      final bytes = Uint8List.fromList(widget.pdfBytes);
      if (!mounted) return;
      setState(() {
        _controller = PdfController(
          document: PdfDocument.openData(bytes),
        );
        _loading = false;
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _loading = false;
        _error = e;
      });
    }
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _share() async {
    try {
      await widget.onShare();
    } on Object catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString())),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!isValidPdfBytes(widget.pdfBytes)) {
      return Scaffold(
        appBar: AppBar(title: Text(widget.title)),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              widget.invalidPdfMessage,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        actions: [
          IconButton(
            icon: const Icon(Icons.share_outlined),
            tooltip: widget.shareLabel,
            onPressed: _share,
          ),
        ],
      ),
      body: _buildBody(context),
    );
  }

  Widget _buildBody(BuildContext context) {
    if (_loading) {
      return const Center(child: CircularProgressIndicator());
    }

    final controller = _controller;
    if (_error != null || controller == null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(
                widget.invalidPdfMessage,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: _share,
                icon: const Icon(Icons.share_outlined),
                label: Text(widget.shareLabel),
              ),
            ],
          ),
        ),
      );
    }

    return PdfView(
      controller: controller,
      scrollDirection: Axis.vertical,
      backgroundDecoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
      ),
    );
  }
}
