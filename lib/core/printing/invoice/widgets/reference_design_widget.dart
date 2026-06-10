import 'package:pdf/widgets.dart' as pw;

import '../../../../l10n/app_localizations.dart';
import '../../invoice_pdf_font.dart';
import '../../pdf_bidi_text.dart';
import '../invoice_document_model.dart';
import '../invoice_pdf_constants.dart';
import '../invoice_pdf_text_sanitize.dart';

/// Large catalog reference design image (not shape thumbnails).
pw.Widget referenceDesignWidget({
  required InvoicePdfFontSet fonts,
  required AppLocalizations l10n,
  required InvoiceDocumentReferenceDesign design,
  required pw.ImageProvider? imageProvider,
  required pw.TextDirection textDirection,
}) {
  if (!design.hasContent) return pw.SizedBox();

  final captionParts = <String>[];
  if (design.designName.isNotEmpty) captionParts.add(design.designName);
  if (design.designerShopName.isNotEmpty) {
    captionParts.add(
      '${l10n.invoiceCatalogDesignerLabel}: ${design.designerShopName}',
    );
  }

  return pw.Padding(
    padding: const pw.EdgeInsets.only(bottom: InvoicePdfLayout.subsectionGap),
    child: pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.stretch,
      children: [
        pdfMixedTextWidget(
          text: pdfSanitizeLabel(l10n.invoiceReferenceDesignLabel),
          style: pw.TextStyle(
            font: fonts.bold,
            fontSize: InvoicePdfLayout.bodyFontSize,
            color: InvoicePdfColors.accent,
          ),
          documentDirection: textDirection,
        ),
        pw.SizedBox(height: InvoicePdfLayout.subsectionGap),
        if (imageProvider != null)
          pw.Container(
            decoration: pw.BoxDecoration(
              color: InvoicePdfColors.surface,
              borderRadius:
                  pw.BorderRadius.circular(InvoicePdfLayout.cardRadius),
              border: pw.Border.all(
                color: InvoicePdfColors.border,
                width: 0.5,
              ),
            ),
            padding: const pw.EdgeInsets.all(InvoicePdfLayout.cardBodyPadding),
            child: pw.SizedBox(
              height: InvoicePdfLayout.catalogDisplayHeightPt,
              width: double.infinity,
              child: pw.Image(imageProvider, fit: pw.BoxFit.contain),
            ),
          ),
        if (captionParts.isNotEmpty) ...[
          pw.SizedBox(height: InvoicePdfLayout.subsectionGap),
          pdfMixedTextWidget(
            text: pdfSanitizeLabel(captionParts.join(' · ')),
            style: pw.TextStyle(
              font: fonts.regular,
              fontSize: InvoicePdfLayout.smallFontSize,
            ),
            documentDirection: textDirection,
          ),
        ],
      ],
    ),
  );
}
