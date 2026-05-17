import 'package:flutter/foundation.dart';

import 'package:flutter/material.dart';

import 'package:flutter_riverpod/flutter_riverpod.dart';



import '../../data/local/order_summary.dart';

import '../../data/local/payment_summary.dart';

import '../../data/local/style/order_style_figures_resolver.dart';

import '../../data/providers/local_data_providers.dart';

import '../../features/reports/report_money_format.dart';

import '../../features/settings/shop_profile_provider.dart';

import '../../l10n/app_localizations.dart';

import '../persistence/shared_preferences_provider.dart';

import 'receipt_branding.dart';

import 'receipt_line_wrap.dart';

import 'shop_logo_raster.dart';

import 'style_figure_raster.dart';

import 'thermal_printer_prefs.dart';

import 'thermal_printer_socket.dart';

import 'thermal_receipt_escpos.dart';



Future<void> printThermalOrderReceipt({

  required BuildContext context,

  required WidgetRef ref,

  required AppLocalizations l10n,

  required OrderSummary order,

  required List<PaymentSummary> payments,

  required String deliveryDateText,

  required String statusText,

}) async {

  if (kIsWeb) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text(l10n.settingsPrinterWebUnavailable)),

    );

    return;

  }



  final prefs = ref.read(sharedPreferencesProvider);

  final host = ThermalPrinterPrefs.readHost(prefs);

  if (host.isEmpty) {

    ScaffoldMessenger.of(context).showSnackBar(

      SnackBar(content: Text(l10n.orderPrintReceiptNeedPrinter)),

    );

    return;

  }



  final port = ThermalPrinterPrefs.readPort(prefs);

  final paperMm = ThermalPrinterPrefs.readPaperMm(prefs);

  final paper = paperSizeFromMm(paperMm);

  final wrapChars = receiptWrapCharsForPaperMm(paperMm);



  final shop = ref.read(shopProfileProvider).valueOrNull;

  final branding = ReceiptBranding.fromShop(

    shop: shop,

    l10n: l10n,

    wrapChars: wrapChars,

  );



  final total = reportFormatMoney(l10n, order.totalAmountMinor);

  final paid = reportFormatMoney(l10n, order.paidAmountMinor);

  final balance = reportFormatMoney(l10n, order.remainingAmountMinor);



  final paymentRows = <String>[];

  for (final p in payments) {

    final amt = reportFormatMoney(l10n, p.amountMinor);

    paymentRows.add('${p.method}  $amt');

  }



  final phone = order.customerPhone?.trim();



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

    final headerLogo = await loadReceiptHeaderLogoRaster(

      userLogoRelativePath: shop?.logoRelativePath,

      maxWidthPx: paper.width,

    );

    final allFigures =
        ref.read(styleAllFiguresStreamProvider).valueOrNull ?? const [];
    final selectedFigures = resolveOrderStyleFigures(
      styleSelectionJson: order.styleSelectionJson,
      allFigures: allFigures,
    );
    final figureThumbWidth = (paper.width * 0.42).round().clamp(80, paper.width);
    final receiptFigures = <ReceiptStyleFigure>[];
    for (final figure in selectedFigures) {
      final image = await loadStyleFigureRaster(
        imageRef: figure.imageRef,
        maxWidthPx: figureThumbWidth,
      );
      receiptFigures.add(
        ReceiptStyleFigure(image: image, name: figure.name),
      );
    }

    final content = OrderReceiptEscPosContent(

      headerLogo: headerLogo,

      shopLine: branding.shopDisplayName,

      shopPhoneLine: branding.shopPhoneLine,

      shopAddressLines: branding.addressLines,

      orderLine: l10n.ordersNumberPrefix(order.displayOrderNo),

      customerLine: '${l10n.receiptCustomerLabel}: ${order.customerName}',

      phoneLine: (phone != null && phone.isNotEmpty)

          ? '${l10n.receiptPhoneLabel}: $phone'

          : null,

      deliveryLine: '${l10n.receiptDeliveryLabel}: $deliveryDateText',

      statusLine: '${l10n.receiptStatusLabel}: $statusText',

      measurementsLine: order.measurementsSnapshot.trim().isEmpty

          ? null

          : '${l10n.receiptMeasurementsLabel}: ${order.measurementsSnapshot.trim()}',

      styleLine: order.styleSummary.trim().isEmpty

          ? (order.styleName.trim().isEmpty

              ? null

              : '${l10n.receiptStyleLabel}: ${order.styleName.trim()}')

          : '${l10n.receiptStyleLabel}:\n${order.styleSummary.trim()}',

      catalogDesignLine: order.catalogDesignNameSnapshot.trim().isEmpty

          ? null

          : '${l10n.receiptCatalogDesignLabel}: ${order.catalogDesignNameSnapshot.trim()}',

      fabricLine: order.hasCustomerFabric

          ? _thermalFabricLine(l10n, order)

          : null,

      styleFigures: receiptFigures,

      internalNotesLine: order.internalNotes.trim().isEmpty

          ? null

          : '${l10n.receiptInternalNotesHeader}:\n${order.internalNotes.trim()}',

      totalLine: '${l10n.receiptTotalLabel}: $total',

      paidLine: '${l10n.receiptPaidLabel}: $paid',

      balanceLine: '${l10n.receiptBalanceLabel}: $balance',

      paymentHeader: l10n.receiptPaymentsHeader,

      paymentRows: paymentRows,

      footerAddressLines: branding.addressLines,

      footerThankYouLines: branding.thankYouLines,

    );



    final bytes = await buildThermalOrderReceipt(paper: paper, c: content);

    await sendThermalReceiptBytes(host: host, port: port, bytes: bytes);

    if (context.mounted) {

      Navigator.of(context, rootNavigator: true).pop();

    }

    if (context.mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(l10n.orderPrintReceiptOk)),

      );

    }

  } catch (e) {

    if (context.mounted) {

      Navigator.of(context, rootNavigator: true).pop();

    }

    if (context.mounted) {

      ScaffoldMessenger.of(context).showSnackBar(

        SnackBar(content: Text(l10n.orderPrintReceiptFail(e.toString()))),

      );

    }

  }

}

String _thermalFabricLine(AppLocalizations l10n, OrderSummary order) {
  final parts = <String>[];
  final name = order.fabricNameSnapshot.trim();
  final color = order.fabricColorSnapshot.trim();
  final id = order.fabricIdSnapshot.trim();
  if (name.isNotEmpty) {
    parts.add('${l10n.receiptFabricNameLabel}: $name');
  }
  if (color.isNotEmpty) {
    parts.add('${l10n.receiptFabricColorLabel}: $color');
  }
  if (id.isNotEmpty) {
    parts.add('${l10n.receiptFabricIdLabel}: $id');
  }
  return '${l10n.receiptFabricLabel}:\n${parts.join('\n')}';
}


