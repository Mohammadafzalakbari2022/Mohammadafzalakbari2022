import '../../data/local/order_style_snapshot_view.dart';
import '../../data/local/order_summary.dart';

import '../../data/local/payment_summary.dart';

import '../../data/local/style/order_shape_format_labels.dart';
import '../../data/local/style/order_shape_selection_formatter.dart';

import '../../features/reports/report_money_format.dart';

import '../../features/settings/shop_profile.dart';

import '../../l10n/app_localizations.dart';

import 'receipt_branding.dart';



void _writeShareHeader(StringBuffer buf, ReceiptBranding branding, AppLocalizations l10n) {

  final rule = l10n.receiptShareSectionRule;

  buf.writeln(rule);

  buf.writeln(centerReceiptShareLine(branding.shopDisplayName));

  final phone = branding.shopPhoneLine;

  if (phone != null && phone.isNotEmpty) {

    buf.writeln(centerReceiptShareLine(phone));

  }

  for (final line in branding.addressLines) {

    final t = line.trim();

    if (t.isNotEmpty) {

      buf.writeln(centerReceiptShareLine(t));

    }

  }

  buf.writeln(rule);

}



void _writeShareFooter(StringBuffer buf, ReceiptBranding branding, AppLocalizations l10n) {

  buf.writeln(l10n.receiptShareSectionRule);

  for (final line in branding.addressLines) {

    final t = line.trim();

    if (t.isNotEmpty) {

      buf.writeln(centerReceiptShareLine(t));

    }

  }

  for (final line in branding.thankYouLines) {

    final t = line.trim();

    if (t.isNotEmpty) {

      buf.writeln(centerReceiptShareLine(t));

    }

  }

  buf.writeln(l10n.receiptShareSectionRule);

}



/// Plain-text invoice for sharing (WhatsApp, SMS, email body, etc.).

String buildOrderInvoiceShareText({

  required AppLocalizations l10n,

  required ShopProfile? shop,

  required OrderSummary order,

  required List<PaymentSummary> payments,

  required String deliveryDateText,

  required String statusText,

  OrderStyleSnapshotView? styleSnap,

}) {

  const wrapChars = 32;

  final branding = ReceiptBranding.fromShop(

    shop: shop,

    l10n: l10n,

    wrapChars: wrapChars,

  );



  final buf = StringBuffer();

  _writeShareHeader(buf, branding, l10n);

  buf.writeln(l10n.ordersNumberPrefix(order.displayOrderNo));

  buf.writeln('${l10n.receiptCustomerLabel}: ${order.customerName}');

  final cPhone = order.customerPhone?.trim();

  if (cPhone != null && cPhone.isNotEmpty) {

    buf.writeln('${l10n.receiptPhoneLabel}: $cPhone');

  }

  buf.writeln('${l10n.receiptDeliveryLabel}: $deliveryDateText');

  buf.writeln('${l10n.receiptStatusLabel}: $statusText');

  final m = order.measurementsSnapshot.trim();

  if (m.isNotEmpty) {

    buf.writeln('${l10n.receiptMeasurementsLabel}: $m');

  }

  final styleDisplay = formatOrderShapeSelectionDisplay(
    snapshot: styleSnap,
    styleName: order.styleName,
    styleSelectionJson: order.styleSelectionJson,
    styleSummary: order.styleSummary,
    labels: orderShapeFormatLabels(l10n),
  );
  final styleText = styleDisplay.detailedText.trim().isNotEmpty
      ? styleDisplay.detailedText.trim()
      : styleDisplay.summaryFallbackText.trim();

  if (styleText.isNotEmpty) {

    buf.writeln('${l10n.receiptStyleLabel}:');

    buf.writeln(styleText);

  }

  if (order.hasCustomerFabric) {

    buf.writeln(l10n.receiptFabricLabel);

    if (order.fabricNameSnapshot.trim().isNotEmpty) {

      buf.writeln(

        '${l10n.receiptFabricNameLabel}: ${order.fabricNameSnapshot.trim()}',

      );

    }

    if (order.fabricColorSnapshot.trim().isNotEmpty) {

      buf.writeln(

        '${l10n.receiptFabricColorLabel}: ${order.fabricColorSnapshot.trim()}',

      );

    }

    if (order.fabricIdSnapshot.trim().isNotEmpty) {

      buf.writeln(

        '${l10n.receiptFabricIdLabel}: ${order.fabricIdSnapshot.trim()}',

      );

    }

  }

  final catalogDesign = order.catalogDesignNameSnapshot.trim();

  if (catalogDesign.isNotEmpty) {

    buf.writeln('${l10n.receiptCatalogDesignLabel}: $catalogDesign');

    final designer = order.catalogDesignerShopNameSnapshot.trim();

    if (designer.isNotEmpty) {

      buf.writeln('${l10n.invoiceCatalogDesignerLabel}: $designer');

    }

  }

  final internal = order.internalNotes.trim();

  if (internal.isNotEmpty) {

    buf.writeln('${l10n.receiptInternalNotesHeader}:');

    buf.writeln(internal);

  }

  buf.writeln(l10n.receiptShareDivider);

  final total = reportFormatMoney(l10n, order.totalAmountMinor);

  final paid = reportFormatMoney(l10n, order.paidAmountMinor);

  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);

  buf.writeln('${l10n.receiptTotalLabel}: $total');

  buf.writeln('${l10n.receiptPaidLabel}: $paid');

  buf.writeln('${l10n.receiptBalanceLabel}: $balance');

  buf.writeln(l10n.receiptPaymentsHeader);

  for (final p in payments) {

    final amt = reportFormatMoney(l10n, p.amountMinor);

    buf.writeln('${p.method}  $amt');

  }

  _writeShareFooter(buf, branding, l10n);

  return buf.toString();

}


