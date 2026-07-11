import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/formatting/display_order_no_format.dart';
import 'package:pride_v3/core/printing/invoice/order_invoice_loader.dart';
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/core/printing/invoice_pdf_temp_file.dart';
import 'package:pride_v3/core/printing/invoice_pdf_validation.dart';
import 'package:pride_v3/core/printing/invoice_share_contact.dart';
import 'package:pride_v3/core/printing/phone_whatsapp.dart';
import 'package:pride_v3/core/printing/share_invoice_pdf.dart';
import 'package:pride_v3/core/printing/whatsapp_invoice_share.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// When WhatsApp is not possible, ask whether to use the generic share sheet.
Future<bool> _confirmShareWithoutWhatsapp(
  BuildContext context,
  AppLocalizations l10n, {
  required String body,
}) async {
  final choice = await showDialog<bool>(
    context: context,
    builder: (ctx) => AlertDialog(
      title: Text(l10n.orderShareWhatsappNoPhoneTitle),
      content: Text(body),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(ctx).pop(false),
          child: Text(l10n.orderShareWhatsappNoPhoneCancel),
        ),
        FilledButton(
          onPressed: () => Navigator.of(ctx).pop(true),
          child: Text(l10n.orderShareWhatsappNoPhoneShareOther),
        ),
      ],
    ),
  );
  return choice ?? false;
}

/// Share order invoice as PDF; saves customer contact and opens WhatsApp when possible.
Future<void> shareOrderInvoice({
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

    final pdfBytes = await loadOrderInvoicePdfBytesFromRef(
      ref: ref,
      request: request,
    );

    if (!isValidPdfBytes(pdfBytes)) {
      throw InvoicePdfGenerationException('Invalid or empty PDF bytes');
    }

    final rawPhone = order.customerPhone?.trim();
    final whatsappPhone =
        rawPhone != null ? normalizePhoneForWhatsApp(rawPhone) : null;
    final contactPhone = whatsappPhone ?? rawPhone;

    bool? contactSaved;
    var contactPermissionDenied = false;
    if (!kIsWeb && contactPhone != null && contactPhone.isNotEmpty) {
      try {
        if (await FlutterContacts.requestPermission()) {
          contactSaved = await saveCustomerContactForInvoiceShare(
            name: order.customerName,
            phone: contactPhone,
            skipPermissionRequest: true,
          );
        } else {
          contactPermissionDenied = true;
        }
      } on Object {
        // Contact save is optional; do not block PDF share.
      }
    }

    final displayNo = formatDisplayOrderNo(order.displayOrderNo);
    final filename = 'invoice_${order.displayOrderNo}.pdf';

    closeLoadingDialog();

    final path = await writeInvoicePdfToTempFile(
      bytes: pdfBytes,
      filename: filename,
    );

    final subject = l10n.orderShareInvoiceSubject(displayNo);
    final caption = l10n.orderShareInvoiceWhatsappCaption(
      displayNo,
      order.customerName,
    );

    var shared = false;
    var usedGenericShare = false;
    if (!kIsWeb &&
        path != null &&
        rawPhone != null &&
        rawPhone.isNotEmpty) {
      if (whatsappPhone == null) {
        if (!context.mounted) return;
        final proceed = await _confirmShareWithoutWhatsapp(
          context,
          l10n,
          body: l10n.orderShareWhatsappPhoneInvalid,
        );
        if (!proceed || !context.mounted) return;
        await shareInvoicePdfBytes(
          pdfBytes: pdfBytes,
          filename: filename,
          subject: subject,
          text: caption,
        );
        usedGenericShare = true;
      } else {
        if (contactSaved == true) {
          await Future<void>.delayed(const Duration(milliseconds: 300));
        }
        shared = await shareInvoicePdfToWhatsApp(
          filePath: path,
          phoneDigits: whatsappPhone,
          caption: caption,
        );
      }
    }

    if (!shared && !usedGenericShare) {
      if (rawPhone == null || rawPhone.isEmpty) {
        if (!context.mounted) return;
        final proceed = await _confirmShareWithoutWhatsapp(
          context,
          l10n,
          body: l10n.orderShareWhatsappNoPhoneBody,
        );
        if (!proceed || !context.mounted) return;
      }
      await shareInvoicePdfBytes(
        pdfBytes: pdfBytes,
        filename: filename,
        subject: subject,
        text: caption,
      );
      usedGenericShare = true;
    }

    if (!context.mounted) return;

    if (contactSaved == true) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.success,
        message: l10n.orderShareContactSaved(order.customerName),
      );
    } else if (contactPermissionDenied) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.info,
        message: l10n.orderShareContactPermissionDenied,
      );
    }

    if (shared && context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.success,
        message: l10n.orderShareWhatsappOpened,
      );
    } else if (usedGenericShare && context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.info,
        message: l10n.orderShareInvoiceSharedSheet,
      );
    }
  } catch (e, st) {
    closeLoadingDialog();
    if (context.mounted) {
      final message = e is InvoicePdfGenerationException
          ? l10n.orderShareInvoicePdfGenerateFail
          : l10n.orderShareInvoiceFail(e.toString());
      if (e is InvoicePdfGenerationException) {
        debugPrint('Invoice share PDF failure: ${e.cause}\n${e.stackTrace}');
      } else {
        debugPrint('Invoice share failure: $e\n$st');
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
