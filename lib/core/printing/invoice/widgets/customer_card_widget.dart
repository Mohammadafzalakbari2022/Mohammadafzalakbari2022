import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';
import 'invoice_pdf_widgets_common.dart';

/// Customer card immediately below the banner.
pw.Widget customerCardWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required String customerName,
  required String phone,
  required String? customerIdLabel,
  required pw.TextDirection textDirection,
}) {
  return invoiceCardShell(
    fonts: fonts,
    title: l10n.receiptCustomerLabel,
    textDirection: textDirection,
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        if (customerIdLabel != null && customerIdLabel.isNotEmpty) ...[
          pw.Container(
            padding: const pw.EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: pw.BoxDecoration(
              color: InvoicePdfColors.customerIdBadge,
              borderRadius: pw.BorderRadius.circular(6),
            ),
            child: pdfMixedTextWidget(
              text: pdfSanitizeLabel(customerIdLabel),
              style: pw.TextStyle(
                font: fonts.bold,
                fontSize: InvoicePdfLayout.customerIdBadgeFontSize,
                color: PdfColors.white,
              ),
              documentDirection: pw.TextDirection.ltr,
            ),
          ),
          pw.SizedBox(height: 8),
        ],
        pdfMixedTextWidget(
          text: pdfSanitizeLabel(customerName),
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: 11,
            color: PdfColors.black,
          ),
          documentDirection: textDirection,
        ),
        if (phone.trim().isNotEmpty) ...[
          pw.SizedBox(height: 4),
          invoiceLabelValueRow(
            fonts: fonts,
            label: l10n.receiptPhoneLabel,
            value: phone.trim(),
            textDirection: textDirection,
          ),
        ],
      ],
    ),
  );
}
