import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/feedback/app_feedback.dart';
import 'package:pride_v3/core/printing/invoice_share_text.dart';
import 'package:pride_v3/data/local/order_summary.dart';
import 'package:pride_v3/data/local/payment_summary.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

/// Share plain-text invoice (used from order detail and composer).
Future<void> shareOrderInvoiceText({
  required BuildContext context,
  required WidgetRef ref,
  required AppLocalizations l10n,
  required OrderSummary order,
  required List<PaymentSummary> payments,
  required String deliveryDateText,
  required String statusText,
}) async {
  final shop = ref.read(shopProfileProvider).valueOrNull;
  final text = buildOrderInvoiceShareText(
    l10n: l10n,
    shop: shop,
    order: order,
    payments: payments,
    deliveryDateText: deliveryDateText,
    statusText: statusText,
  );
  try {
    await Share.share(
      text,
      subject: l10n.orderShareInvoiceSubject(order.displayOrderNo),
    );
  } catch (e) {
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
