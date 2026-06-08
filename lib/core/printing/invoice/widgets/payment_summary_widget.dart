import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../data/local/payment_summary.dart';
import '../../../../features/reports/report_money_format.dart';
import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../invoice_payment_labels.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';
import 'invoice_pdf_widgets_common.dart';

/// Payment summary card — always the last major section before footer.
pw.Widget paymentSummaryWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required int garmentTotalMinor,
  required int grandTotalMinor,
  required int paidMinor,
  required int remainingMinor,
  required List<PaymentSummary> payments,
  required pw.TextDirection textDirection,
  String Function(DateTime dateTime)? formatPaymentDate,
}) {
  final garmentTotal = reportFormatMoney(l10n, garmentTotalMinor);
  final grandTotal = reportFormatMoney(l10n, grandTotalMinor);
  final paid = reportFormatMoney(l10n, paidMinor);
  final remaining = reportFormatMoney(l10n, remainingMinor);

  final diff = grandTotalMinor - garmentTotalMinor;
  final discountMinor = diff < 0 ? -diff : 0;
  final additionalMinor = diff > 0 ? diff : 0;
  final discount = reportFormatMoney(l10n, discountMinor);
  final additional = reportFormatMoney(l10n, additionalMinor);

  return pw.Inseparable(
    child: invoiceCardShell(
      fonts: fonts,
      title: l10n.invoicePaymentSummaryTitle,
      textDirection: textDirection,
      titleBackground: InvoicePdfColors.accent,
      titleTextColor: PdfColors.white,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.stretch,
        children: [
          _moneyRow(
            fonts: fonts,
            label: l10n.invoiceGarmentTotalLabel,
            value: garmentTotal,
            textDirection: textDirection,
          ),
          if (discountMinor > 0)
            _moneyRow(
              fonts: fonts,
              label: l10n.invoiceDiscountLabel,
              value: discount,
              textDirection: textDirection,
            ),
          if (additionalMinor > 0)
            _moneyRow(
              fonts: fonts,
              label: l10n.invoiceAdditionalChargesLabel,
              value: additional,
              textDirection: textDirection,
            ),
          pw.Divider(color: InvoicePdfColors.border, height: 8),
          _moneyRow(
            fonts: fonts,
            label: l10n.invoiceGrandTotalLabel,
            value: grandTotal,
            textDirection: textDirection,
            emphasize: true,
          ),
          pw.SizedBox(height: 4),
          _moneyRow(
            fonts: fonts,
            label: l10n.receiptPaidLabel,
            value: paid,
            textDirection: textDirection,
          ),
          pw.SizedBox(height: 6),
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 8),
            decoration: pw.BoxDecoration(
              color: InvoicePdfColors.accentLight,
              borderRadius: pw.BorderRadius.circular(6),
              border: pw.Border.all(color: InvoicePdfColors.accent, width: 0.6),
            ),
            child: _moneyRow(
              fonts: fonts,
              label: l10n.invoiceRemainingBalanceLabel,
              value: remaining,
              textDirection: textDirection,
              emphasize: true,
              valueFontSize: InvoicePdfLayout.paymentRemainingFontSize,
            ),
          ),
          if (payments.isNotEmpty) ...[
            pw.SizedBox(height: 8),
            pdfMixedTextWidget(
              text: pdfSanitizeLabel(l10n.receiptPaymentsHeader),
              style: pw.TextStyle(
                font: fonts.bold,
                fontSize: InvoicePdfLayout.bodyFontSize,
                color: InvoicePdfColors.accent,
              ),
              documentDirection: textDirection,
            ),
            pw.SizedBox(height: 4),
            for (var i = 0; i < payments.length; i++) ...[
              if (i > 0) pw.SizedBox(height: 4),
              _paymentLedgerRow(
                fonts: fonts,
                l10n: l10n,
                payment: payments[i],
                formatPaymentDate: formatPaymentDate,
                textDirection: textDirection,
              ),
            ],
          ],
        ],
      ),
    ),
  );
}

pw.Widget _moneyRow({
  required InvoicePdfFontSet fonts,
  required String label,
  required String value,
  required pw.TextDirection textDirection,
  bool emphasize = false,
  double valueFontSize = InvoicePdfLayout.bodyFontSize,
}) {
  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: 4),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          child: pdfMixedTextWidget(
            text: pdfSanitizeLabel(label),
            style: pw.TextStyle(
              font: emphasize ? fonts.bold : fonts.regular,
              fontSize: InvoicePdfLayout.bodyFontSize,
            ),
            documentDirection: textDirection,
          ),
        ),
        pdfMoneyWidget(
          formattedMoney: value,
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: valueFontSize,
            color: emphasize ? InvoicePdfColors.accent : PdfColors.black,
          ),
          documentDirection: textDirection,
        ),
      ],
    ),
  );
}

pw.Widget _paymentLedgerRow({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required PaymentSummary payment,
  String Function(DateTime dateTime)? formatPaymentDate,
  required pw.TextDirection textDirection,
}) {
  final method = formatInvoicePaymentMethod(l10n, payment.method);
  final amount = reportFormatMoney(l10n, payment.amountMinor);
  final dateText = formatPaymentDate?.call(payment.createdAt) ??
      _fallbackPaymentDate(payment.createdAt);

  return pw.Container(
    padding: const pw.EdgeInsets.symmetric(horizontal: 6, vertical: 4),
    decoration: pw.BoxDecoration(
      color: PdfColors.white,
      borderRadius: pw.BorderRadius.circular(4),
      border: pw.Border.all(color: InvoicePdfColors.border, width: 0.4),
    ),
    child: pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Expanded(
          flex: 3,
          child: pdfMixedTextWidget(
            text: pdfSanitizeLabel(method),
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: InvoicePdfLayout.smallFontSize,
            ),
            documentDirection: textDirection,
          ),
        ),
        pw.Expanded(
          flex: 2,
          child: pdfMixedTextWidget(
            text: '${pdfSanitizeLabel(l10n.invoicePaymentDateLabel)}: $dateText',
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: InvoicePdfLayout.smallFontSize,
            ),
            documentDirection: pw.TextDirection.ltr,
          ),
        ),
        pdfMoneyWidget(
          formattedMoney: amount,
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: InvoicePdfLayout.smallFontSize,
          ),
          documentDirection: textDirection,
        ),
      ],
    ),
  );
}

String _fallbackPaymentDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
