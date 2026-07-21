import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:printing/printing.dart';
import 'package:webview_flutter/webview_flutter.dart';

import '../../core/printing/invoice_pdf_preview_data.dart';

/// In-app invoice preview (Android: native page images; desktop/web: WebView or PdfPreview).
class OrderInvoicePdfViewerScreen extends StatefulWidget {
  const OrderInvoicePdfViewerScreen({
    super.key,
    required this.preview,
    required this.pdfBytes,
    required this.title,
    required this.shareLabel,
    required this.onShare,
    required this.invalidPdfMessage,
  });

  final InvoicePdfPreviewData preview;
  final Uint8List pdfBytes;
  final String title;
  final String shareLabel;
  final Future<void> Function() onShare;
  final String invalidPdfMessage;

  @override
  State<OrderInvoicePdfViewerScreen> createState() =>
      _OrderInvoicePdfViewerScreenState();
}

class _OrderInvoicePdfViewerScreenState extends State<OrderInvoicePdfViewerScreen> {
  WebViewController? _webController;
  var _webLoading = true;
  Object? _webError;

  @override
  void initState() {
    super.initState();
    if (!kIsWeb && widget.preview.usesWebView) {
      _initWebView();
    } else if (!widget.preview.usesPageImages && !kIsWeb) {
      _webLoading = false;
      _webError = StateError('Invoice preview payload is empty');
    } else if (kIsWeb) {
      _webLoading = false;
    }
  }

  Future<void> _initWebView() async {
    final preview = widget.preview;
    try {
      final controller = WebViewController();
      if (!kIsWeb) {
        controller
          ..setJavaScriptMode(JavaScriptMode.unrestricted)
          ..setBackgroundColor(const Color(0xFF525659))
          ..setNavigationDelegate(
            NavigationDelegate(
              onPageFinished: (_) {
                if (!mounted) return;
                setState(() => _webLoading = false);
              },
              onWebResourceError: (details) {
                if (!mounted) return;
                setState(() {
                  _webLoading = false;
                  _webError = details.description;
                });
              },
            ),
          );
      }

      final fileUrl = preview.webFileUrl;
      if (fileUrl != null && fileUrl.isNotEmpty) {
        await controller.loadRequest(Uri.parse(fileUrl));
      } else {
        await controller.loadHtmlString(preview.webHtml!);
      }

      if (!mounted) return;
      setState(() {
        _webController = controller;
        if (kIsWeb) {
          _webLoading = false;
        }
      });
    } on Object catch (e) {
      if (!mounted) return;
      setState(() {
        _webLoading = false;
        _webError = e;
      });
    }
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
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (widget.preview.usesPageImages) {
      final pages = widget.preview.pageImages!;
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 12),
        itemCount: pages.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.fromLTRB(12, 0, 12, 16),
            child: Card(
              clipBehavior: Clip.antiAlias,
              child: InteractiveViewer(
                minScale: 0.75,
                maxScale: 4,
                child: Image.memory(
                  pages[index],
                  fit: BoxFit.contain,
                  filterQuality: FilterQuality.medium,
                ),
              ),
            ),
          );
        },
      );
    }

    if (kIsWeb) {
      return PdfPreview(
        canChangeOrientation: false,
        canChangePageFormat: false,
        canDebug: false,
        allowPrinting: false,
        allowSharing: false,
        build: (_) async => widget.pdfBytes,
      );
    }

    if (_webError != null) {
      return _errorBody();
    }

    if (_webLoading || _webController == null) {
      return const Center(child: CircularProgressIndicator());
    }

    return WebViewWidget(controller: _webController!);
  }

  Widget _errorBody() {
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
}
