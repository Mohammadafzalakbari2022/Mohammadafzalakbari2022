import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/feedback/app_feedback.dart';
import '../../core/printing/share_invoice_pdf.dart';
import '../../core/formatting/display_order_no_format.dart';
import '../../core/printing/invoice/order_invoice_loader.dart';
import '../../core/printing/invoice_pdf.dart';
import '../../core/printing/invoice_pdf_validation.dart';
import '../../data/local/order_summary.dart';
import '../../data/local/payment_summary.dart';
import '../../features/orders/order_invoice_preview_screen.dart';
import '../../l10n/app_localizations.dart';

/// Opens in-app invoice preview (same document data as shared PDF).
Future<void> viewOrderInvoicePdf({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
}) async {
  if (!context.mounted) return;

  showDialog<void>(
    context: context,
    barrierDismissible: false,
    builder: (ctx) => const PopScope(
      canPop: false,
      child: Center(child: CircularProgressIndicator()),
    ),
  );
  var loadingDialogOpen = true;
  void closeLoadingDialog() {
    if (!loadingDialogOpen || !context.mounted) return;
    loadingDialogOpen = false;
    Navigator.of(context, rootNavigator: true).pop();
  }

  try {
    final request = await prepareOrderInvoicePdfRequest(
      context: context,
      ref: ref,
      l10n: l10n,
      order: order,
      payments: payments,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
    );

    final document = await loadInvoiceDocumentFromRef(
      ref: ref,
      request: request,
    );

    closeLoadingDialog();

    if (!context.mounted) return;

    final displayNo = formatDisplayOrderNo(order.displayOrderNo);
    final filename = 'invoice_${order.displayOrderNo}.pdf';

    Future<void> sharePdf() async {
      final pdfBytes = await loadOrderInvoicePdfBytesFromRef(
        ref: ref,
        request: request,
      );
      if (!isValidPdfBytes(pdfBytes)) {
        throw InvoicePdfGenerationException('Invalid or empty PDF bytes');
      }
      await shareInvoicePdfBytes(
        pdfBytes: pdfBytes,
        filename: filename,
        subject: l10n.orderShareInvoiceSubject(displayNo),
      );
    }

    await Navigator.of(context).push<void>(
      MaterialPageRoute<void>(
        builder: (ctx) => OrderInvoicePreviewScreen(
          document: document,
          l10n: l10n,
          title: l10n.orderViewInvoicePdfTitle(displayNo),
          shareLabel: l10n.orderShareInvoicePdfCta,
          formatPaymentDate: request.formatPaymentDate,
          onShare: sharePdf,
        ),
      ),
    );
  } catch (e, st) {
    closeLoadingDialog();
    if (context.mounted) {
      final message = e is InvoicePdfGenerationException
          ? l10n.orderShareInvoicePdfGenerateFail
          : l10n.orderViewInvoicePdfInvalid;
      if (e is InvoicePdfGenerationException) {
        debugPrint('Invoice view PDF failure: ${e.cause}\n${e.stackTrace}');
      } else {
        debugPrint('Invoice view failure: $e\n$st');
      }
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: message,
      );
    }
  }
}
