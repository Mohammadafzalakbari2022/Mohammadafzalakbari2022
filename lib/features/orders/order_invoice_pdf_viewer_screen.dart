import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';

import '../../core/printing/invoice_pdf_validation.dart';

/// In-app PDF viewer (rasterized pages) with optional share from the app bar.
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
  final VoidCallback onShare;
  final String invalidPdfMessage;

  @override
  State<OrderInvoicePdfViewerScreen> createState() =>
      _OrderInvoicePdfViewerScreenState();
}

class _OrderInvoicePdfViewerScreenState
    extends State<OrderInvoicePdfViewerScreen> {
  final _pageImages = <MemoryImage>[];
  var _loading = true;
  Object? _error;

  @override
  void initState() {
    super.initState();
    _loadPages();
  }

  Future<void> _loadPages() async {
    try {
      final info = await Printing.info();
      if (!info.canRaster) {
        if (mounted) {
          setState(() {
            _loading = false;
            _error = StateError('pdf_raster_unavailable');
          });
        }
        return;
      }

      final bytes = Uint8List.fromList(widget.pdfBytes);
      await for (final page in Printing.raster(
        bytes,
        pages: null,
        dpi: PdfPageFormat.inch * 1.5,
      )) {
        if (!mounted) return;
        final png = await page.toPng();
        if (!mounted) return;
        setState(() {
          _pageImages.add(MemoryImage(png));
        });
      }

      if (!mounted) return;
      if (_pageImages.isEmpty) {
        setState(() {
          _loading = false;
          _error = StateError('pdf_raster_empty');
        });
        return;
      }

      setState(() {
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
            onPressed: widget.onShare,
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

    if (_error != null) {
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
                onPressed: widget.onShare,
                icon: const Icon(Icons.share_outlined),
                label: Text(widget.shareLabel),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      itemCount: _pageImages.length,
      itemBuilder: (context, index) {
        return Padding(
          padding: const EdgeInsets.symmetric(vertical: 6),
          child: DecoratedBox(
            decoration: const BoxDecoration(
              color: Colors.white,
              boxShadow: [
                BoxShadow(offset: Offset(0, 2), blurRadius: 4),
              ],
            ),
            child: Image(
              image: _pageImages[index],
              fit: BoxFit.contain,
            ),
          ),
        );
      },
    );
  }
}
