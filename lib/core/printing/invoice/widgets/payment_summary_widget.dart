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
            pw.SizedBox(height: 6),
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
            _paymentLedgerTable(
              fonts: fonts,
              l10n: l10n,
              payments: payments,
              formatPaymentDate: formatPaymentDate,
              textDirection: textDirection,
            ),
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

pw.Widget _paymentLedgerTable({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required List<PaymentSummary> payments,
  String Function(DateTime dateTime)? formatPaymentDate,
  required pw.TextDirection textDirection,
}) {
  final pad = InvoicePdfLayout.paymentTableCellPadding;
  return pw.Table(
    border: pw.TableBorder.all(color: InvoicePdfColors.border, width: 0.4),
    defaultVerticalAlignment: pw.TableCellVerticalAlignment.middle,
    columnWidths: {
      0: const pw.FlexColumnWidth(2.2),
      1: const pw.FlexColumnWidth(2),
      2: const pw.FlexColumnWidth(1.5),
    },
    children: [
      pw.TableRow(
        decoration: pw.BoxDecoration(color: InvoicePdfColors.surfaceAlt),
        children: [
          _paymentTableCell(
            fonts: fonts,
            text: l10n.invoicePaymentDateLabel,
            textDirection: textDirection,
            bold: true,
            pad: pad,
          ),
          _paymentTableCell(
            fonts: fonts,
            text: l10n.invoicePaymentMethodLabel,
            textDirection: textDirection,
            bold: true,
            pad: pad,
          ),
          _paymentTableCell(
            fonts: fonts,
            text: l10n.paymentAmountLabel,
            textDirection: textDirection,
            bold: true,
            pad: pad,
            alignEnd: true,
          ),
        ],
      ),
      for (final payment in payments)
        pw.TableRow(
          children: [
            _paymentTableCell(
              fonts: fonts,
              text: formatPaymentDate?.call(payment.createdAt) ??
                  _fallbackPaymentDate(payment.createdAt),
              textDirection: pw.TextDirection.ltr,
              pad: pad,
            ),
            _paymentTableCell(
              fonts: fonts,
              text: formatInvoicePaymentMethod(l10n, payment.method),
              textDirection: textDirection,
              pad: pad,
            ),
            _paymentTableCell(
              fonts: fonts,
              text: reportFormatMoney(l10n, payment.amountMinor),
              textDirection: textDirection,
              pad: pad,
              alignEnd: true,
              money: true,
            ),
          ],
        ),
    ],
  );
}

pw.Widget _paymentTableCell({
  required InvoicePdfFontSet fonts,
  required String text,
  required pw.TextDirection textDirection,
  required double pad,
  bool bold = false,
  bool alignEnd = false,
  bool money = false,
}) {
  final child = money
      ? pdfMoneyWidget(
          formattedMoney: pdfSanitizeLabel(text),
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: InvoicePdfLayout.smallFontSize,
          ),
          documentDirection: textDirection,
        )
      : pdfMixedTextWidget(
          text: pdfSanitizeLabel(text),
          style: pw.TextStyle(
            font: bold ? fonts.bold : fonts.regular,
            fontSize: InvoicePdfLayout.smallFontSize,
          ),
          documentDirection: textDirection,
        );

  return pw.Padding(
    padding: pw.EdgeInsets.all(pad),
    child: alignEnd
        ? pw.Align(alignment: pw.Alignment.centerRight, child: child)
        : child,
  );
}

String _fallbackPaymentDate(DateTime dt) {
  final y = dt.year.toString().padLeft(4, '0');
  final m = dt.month.toString().padLeft(2, '0');
  final d = dt.day.toString().padLeft(2, '0');
  return '$y-$m-$d';
}
