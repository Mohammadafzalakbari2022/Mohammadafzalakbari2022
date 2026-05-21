import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_contacts/flutter_contacts.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/printing/invoice_pdf.dart';
import 'package:pride_v3/core/printing/invoice_pdf_images.dart';
import 'package:pride_v3/core/printing/invoice_pdf_promo_assets.dart';
import 'package:pride_v3/core/printing/invoice_share_contact.dart';
import 'package:pride_v3/core/printing/phone_whatsapp.dart';
import 'package:pride_v3/core/printing/whatsapp_invoice_share.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/data/providers/local_data_providers.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

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
    final shop = ref.read(shopProfileProvider).valueOrNull;
    final locale = Localizations.localeOf(context);
    final isRtl = locale.languageCode == 'fa' || locale.languageCode == 'ps';
    final textDirection =
        isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;

    final styleSnap =
        ref.read(orderStyleSnapshotProvider(order.internalId)).valueOrNull;
    final designRail = await loadInvoicePdfDesignRail(
      order: order,
      styleSnap: styleSnap,
    );
    final promoAssets = await loadInvoicePdfPromoAssets();

    final pdfBytes = await buildOrderInvoicePdf(
      l10n: l10n,
      shop: shop,
      order: order,
      payments: payments,
      deliveryDateText: deliveryDateText,
      statusText: statusText,
      textDirection: textDirection,
      designRail: designRail,
      promoAssets: promoAssets,
    );

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

    final filename = 'invoice_${order.displayOrderNo}.pdf';

    closeLoadingDialog();

    var path = '';
    if (!kIsWeb) {
      final dir = await getTemporaryDirectory();
      path = '${dir.path}/$filename';
      await File(path).writeAsBytes(pdfBytes, flush: true);
    }

    final subject = l10n.orderShareInvoiceSubject(order.displayOrderNo);
    final caption = l10n.orderShareInvoiceWhatsappCaption(
      order.displayOrderNo,
      order.customerName,
    );

    var shared = false;
    if (!kIsWeb && rawPhone != null && rawPhone.isNotEmpty) {
      if (whatsappPhone == null) {
        if (context.mounted) {
          showAppFeedback(
            context,
            ref,
            kind: AppFeedbackKind.info,
            message: l10n.orderShareWhatsappPhoneInvalid,
          );
        }
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

    if (!shared) {
      if (kIsWeb) {
        await Share.shareXFiles(
          [
            XFile.fromData(
              pdfBytes,
              mimeType: 'application/pdf',
              name: filename,
            ),
          ],
          subject: subject,
        );
      } else {
        await Share.shareXFiles(
          [
            XFile.fromData(
              pdfBytes,
              mimeType: 'application/pdf',
              name: filename,
            ),
          ],
          subject: subject,
          text: caption,
        );
      }
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
    } else if (!shared && context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.info,
        message: l10n.orderShareInvoiceSharedSheet,
      );
    }
  } catch (e) {
    closeLoadingDialog();
    if (context.mounted) {
      showAppFeedback(
        context,
        ref,
        kind: AppFeedbackKind.error,
        message: l10n.orderShareInvoiceFail(e.toString()),
      );
    }
  }
}
