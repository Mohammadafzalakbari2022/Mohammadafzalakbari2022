import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'invoice_pdf_font.dart';

/// Left-to-Right Isolate (U+2066) — retained for non-PDF / legacy string tests only.
const String kPdfLri = '\u2066';

/// Pop Directional Isolate (U+2069) — retained for non-PDF / legacy string tests only.
const String kPdfPdi = '\u2069';

/// Inch measurements, Latin IDs, phones — used by [pdfSplitMixedTextSegments] tests/helpers.
final RegExp _latinDigitRun = RegExp(
  r'[0-9][0-9\s./×xX\-]*|'
  r'[A-Za-z][A-Za-z0-9_\-\./+#@]*|'
  r'[+\d][+\d\s\-().]*',
);

/// One visual run inside mixed PDF text with an explicit direction (no U+2066/U+2069).
class PdfTextSegment {
  const PdfTextSegment(this.text, this.direction);

  final String text;
  final pw.TextDirection direction;
}

/// Wraps [text] in a single LTR isolate string (legacy; avoid in PDF widgets).
String pdfIsolateLtr(String text) {
  if (text.isEmpty) return text;
  return '$kPdfLri$text$kPdfPdi';
}

/// Legacy string helper — returns plain [text] without embedding isolates.
///
/// PDF rendering must use [pdfMixedTextWidget] with explicit [pw.TextDirection]
/// per segment instead of embedding U+2066/U+2069 (the PDF font engine draws them).
String pdfProtectMixedText(String text) => text;

bool pdfHasArabicScript(String text) {
  return RegExp(r'[\u0600-\u06FF\u0750-\u077F\u08A0-\u08FF]').hasMatch(text);
}

/// True when [value] contains ASCII letters or digits (render LTR in RTL documents).
bool pdfValueShouldRenderLtr(String value) {
  return RegExp(r'[A-Za-z0-9]').hasMatch(value);
}

/// Chooses [pw.TextDirection] for a PDF string in a localized document.
pw.TextDirection pdfResolveTextDirection({
  required String text,
  required pw.TextDirection documentDirection,
  pw.TextDirection? override,
}) {
  if (override != null) return override;
  if (text.isEmpty) return documentDirection;
  if (!pdfHasArabicScript(text) && pdfValueShouldRenderLtr(text)) {
    return pw.TextDirection.ltr;
  }
  return documentDirection;
}

pw.TextAlign? pdfResolveTextAlign({
  required pw.TextDirection direction,
  pw.TextAlign? textAlign,
}) {
  if (textAlign != null) return textAlign;
  return direction == pw.TextDirection.rtl
      ? pw.TextAlign.right
      : pw.TextAlign.left;
}

/// Splits [text] into RTL/LTR runs (debug/tests only — widgets use full-string bidi).
List<PdfTextSegment> pdfSplitMixedTextSegments(
  String text, {
  pw.TextDirection defaultDirection = pw.TextDirection.rtl,
}) {
  if (text.isEmpty) return const [];

  if (!pdfHasArabicScript(text) && pdfValueShouldRenderLtr(text)) {
    return [PdfTextSegment(text, pw.TextDirection.ltr)];
  }

  final segments = <PdfTextSegment>[];
  var lastEnd = 0;
  for (final match in _latinDigitRun.allMatches(text)) {
    if (match.start > lastEnd) {
      final chunk = text.substring(lastEnd, match.start);
      if (chunk.isNotEmpty) {
        segments.add(PdfTextSegment(chunk, defaultDirection));
      }
    }
    final latin = match.group(0)!;
    if (latin.isNotEmpty) {
      segments.add(PdfTextSegment(latin, pw.TextDirection.ltr));
    }
    lastEnd = match.end;
  }
  final tail = text.substring(lastEnd);
  if (tail.isNotEmpty) {
    segments.add(PdfTextSegment(tail, defaultDirection));
  }
  if (segments.isEmpty) {
    segments.add(PdfTextSegment(text, defaultDirection));
  }
  return segments;
}

/// PDF text with correct RTL/LTR direction for Dari, Pashto, and embedded Latin.
///
/// Uses one [pw.Text] per run so the pdf package bidi/arabic shaper processes the
/// full logical string — splitting into [pw.Wrap] children scrambles mixed lines.
pw.Widget pdfMixedTextWidget({
  required String text,
  required pw.TextStyle style,
  pw.TextDirection documentDirection = pw.TextDirection.rtl,
  pw.TextDirection? textDirection,
  pw.TextAlign? textAlign,
  int? maxLines,
}) {
  if (text.isEmpty) return pw.SizedBox();

  final direction = pdfResolveTextDirection(
    text: text,
    documentDirection: documentDirection,
    override: textDirection,
  );

  return pw.Text(
    text,
    style: style,
    textDirection: direction,
    textAlign: pdfResolveTextAlign(direction: direction, textAlign: textAlign),
    maxLines: maxLines,
  );
}

/// Renders localized money (e.g. `500 افغانی`) with correct RTL ordering.
pw.Widget pdfMoneyWidget({
  required String formattedMoney,
  required pw.TextStyle style,
  pw.TextDirection documentDirection = pw.TextDirection.rtl,
  pw.TextAlign? textAlign,
}) {
  final trimmed = formattedMoney.trim();
  if (trimmed.isEmpty) return pw.SizedBox();

  final direction = pdfResolveTextDirection(
    text: trimmed,
    documentDirection: documentDirection,
  );

  return pw.Text(
    trimmed,
    style: style,
    textDirection: direction,
    textAlign: pdfResolveTextAlign(direction: direction, textAlign: textAlign),
  );
}

/// Compact label/value row — fixed label width avoids huge gaps on full-width rows.
pw.Widget pdfCompactLabelValue({
  required InvoicePdfFontSet fonts,
  required String label,
  required String value,
  required pw.TextDirection documentDirection,
  double labelWidth = 72,
  double labelFontSize = 8,
  double valueFontSize = 9,
  PdfColor labelColor = PdfColors.grey700,
  pw.Font? valueFont,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.SizedBox(
        width: labelWidth,
        child: pw.Text(
          label,
          style: pw.TextStyle(
            font: fonts.regular,
            fontSize: labelFontSize,
            color: labelColor,
          ),
          textDirection: documentDirection,
          textAlign: pdfResolveTextAlign(direction: documentDirection),
          maxLines: 3,
        ),
      ),
      pw.Expanded(
        child: pdfMixedTextWidget(
          text: value,
          style: pw.TextStyle(
            font: valueFont ?? fonts.regular,
            fontSize: valueFontSize,
          ),
          documentDirection: documentDirection,
        ),
      ),
    ],
  );
}

/// Label + value row with correct direction per segment (RTL labels, LTR Latin values).
pw.Widget pdfMixedLabelValue({
  required InvoicePdfFontSet fonts,
  required String label,
  required String value,
  required pw.TextDirection documentDirection,
  double labelFontSize = 8.5,
  double valueFontSize = 9.5,
  PdfColor labelColor = PdfColors.grey700,
  pw.Font? valueFont,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      pw.Text(
        '$label: ',
        style: pw.TextStyle(
          font: fonts.regular,
          fontSize: labelFontSize,
          color: labelColor,
        ),
        textDirection: documentDirection,
        textAlign: pdfResolveTextAlign(direction: documentDirection),
      ),
      pw.Expanded(
        child: pdfMixedTextWidget(
          text: value,
          style: pw.TextStyle(
            font: valueFont ?? fonts.regular,
            fontSize: valueFontSize,
          ),
          documentDirection: documentDirection,
        ),
      ),
    ],
  );
}

/// Icon + label + value row for shop/customer meta lines in invoices.
pw.Widget pdfMixedIconTextRow({
  required InvoicePdfFontSet fonts,
  required pw.Widget icon,
  required String label,
  required String value,
  required pw.TextDirection documentDirection,
}) {
  return pw.Row(
    crossAxisAlignment: pw.CrossAxisAlignment.start,
    children: [
      icon,
      pw.SizedBox(width: 6),
      pw.Expanded(
        child: pdfCompactLabelValue(
          fonts: fonts,
          label: label,
          value: value,
          documentDirection: documentDirection,
          labelFontSize: 8,
          valueFontSize: 9.5,
        ),
      ),
    ],
  );
}
