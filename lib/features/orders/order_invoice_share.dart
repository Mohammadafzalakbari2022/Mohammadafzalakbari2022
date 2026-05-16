import 'dart:io';



import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:flutter_contacts/flutter_contacts.dart';

import 'package:path_provider/path_provider.dart';

import 'package:pdf/widgets.dart' as pw;

import 'package:pride_v3/core/feedback/app_feedback.dart';

import 'package:pride_v3/core/printing/invoice_pdf.dart';

import 'package:pride_v3/core/printing/invoice_share_contact.dart';

import 'package:pride_v3/core/printing/whatsapp_invoice_share.dart';

import 'package:pride_v3/data/local/order_summary.dart';

import 'package:pride_v3/data/local/payment_summary.dart';

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



  try {

    final shop = ref.read(shopProfileProvider).valueOrNull;

    final locale = Localizations.localeOf(context);

    final isRtl = locale.languageCode == 'fa' || locale.languageCode == 'ps';

    final textDirection =

        isRtl ? pw.TextDirection.rtl : pw.TextDirection.ltr;



    final pdfBytes = await buildOrderInvoicePdf(

      l10n: l10n,

      shop: shop,

      order: order,

      payments: payments,

      deliveryDateText: deliveryDateText,

      statusText: statusText,

      textDirection: textDirection,

    );



    final phone = order.customerPhone?.trim();

    bool? contactSaved;

    var contactPermissionDenied = false;

    if (!kIsWeb && phone != null && phone.isNotEmpty) {

      if (await FlutterContacts.requestPermission()) {

        contactSaved = await saveCustomerContactForInvoiceShare(

          name: order.customerName,

          phone: phone,

          skipPermissionRequest: true,

        );

      } else {

        contactPermissionDenied = true;

      }

    }



    final filename = 'invoice_${order.displayOrderNo}.pdf';

    final dir = await getTemporaryDirectory();

    final path = '${dir.path}/$filename';

    if (!kIsWeb) {

      await File(path).writeAsBytes(pdfBytes, flush: true);

    }



    if (context.mounted) {

      Navigator.of(context, rootNavigator: true).pop();

    }



    final subject = l10n.orderShareInvoiceSubject(order.displayOrderNo);

    final caption = l10n.orderShareInvoiceWhatsappCaption(

      order.displayOrderNo,

      order.customerName,

    );



    var shared = false;

    if (!kIsWeb && phone != null && phone.isNotEmpty) {

      shared = await shareInvoicePdfToWhatsApp(

        filePath: path,

        phoneDigits: phone,

        caption: caption,

      );

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

          [XFile(path, mimeType: 'application/pdf', name: filename)],

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

    if (context.mounted) {

      Navigator.of(context, rootNavigator: true).pop();

    }

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


