import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'invoice_pdf_font.dart';

/// Left-to-Right Isolate (U+2066) — retained for non-PDF / legacy string tests only.
const String kPdfLri = '\u2066';

/// Pop Directional Isolate (U+2069) — retained for non-PDF / legacy string tests only.
const String kPdfPdi = '\u2069';

/// Latin letters/digits and common ID/phone/money tokens that must not reverse in RTL.
final RegExp _latinDigitRun = RegExp(
  r'[A-Za-z0-9][A-Za-z0-9_\-\./+#@]*|[+\d][+\d\s\-().]*',
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

/// Splits [text] into RTL/LTR runs for PDF widgets (no isolate characters).
List<PdfTextSegment> pdfSplitMixedTextSegments(
  String text, {
  pw.TextDirection defaultDirection = pw.TextDirection.rtl,
}) {
  if (text.isEmpty) return const [];

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

/// True when [value] contains ASCII letters or digits (render LTR in RTL documents).
bool pdfValueShouldRenderLtr(String value) {
  return RegExp(r'[A-Za-z0-9]').hasMatch(value);
}

/// PDF [pw.Text] replacement that keeps Latin/digit runs LTR without U+2066/U+2069.
pw.Widget pdfMixedTextWidget({
  required String text,
  required pw.TextStyle style,
  pw.TextDirection documentDirection = pw.TextDirection.rtl,
  pw.TextAlign? textAlign,
  int? maxLines,
}) {
  final segments = pdfSplitMixedTextSegments(
    text,
    defaultDirection: documentDirection,
  );

  if (segments.length == 1) {
    return pw.Text(
      segments.first.text,
      style: style,
      textDirection: segments.first.direction,
      textAlign: textAlign,
      maxLines: maxLines,
    );
  }

  return pw.Directionality(
    textDirection: documentDirection,
    child: pw.Wrap(
      crossAxisAlignment: pw.WrapCrossAlignment.start,
      children: [
        for (final segment in segments)
          pw.Text(
            segment.text,
            style: style,
            textDirection: segment.direction,
          ),
      ],
    ),
  );
}

/// Renders localized money (e.g. `500 افغانی`) with LTR digits and RTL currency text.
pw.Widget pdfMoneyWidget({
  required String formattedMoney,
  required pw.TextStyle style,
  pw.TextDirection documentDirection = pw.TextDirection.rtl,
}) {
  final trimmed = formattedMoney.trim();
  if (trimmed.isEmpty) return pw.SizedBox();

  final match =
      RegExp(r'^([\d,.\+\-\u2212]+)\s+(.*)$', unicode: true).firstMatch(trimmed);
  if (match == null) {
    return pdfMixedTextWidget(
      text: trimmed,
      style: style,
      documentDirection: documentDirection,
    );
  }

  final digits = match.group(1)!;
  final suffix = match.group(2)!.trim();
  if (suffix.isEmpty) {
    return pw.Text(
      digits,
      style: style,
      textDirection: pw.TextDirection.ltr,
    );
  }

  return pw.Directionality(
    textDirection: documentDirection,
    child: pw.Wrap(
      spacing: 3,
      crossAxisAlignment: pw.WrapCrossAlignment.center,
      children: [
        pw.Text(
          digits,
          style: style,
          textDirection: pw.TextDirection.ltr,
        ),
        pw.Text(
          suffix,
          style: style,
          textDirection: documentDirection,
        ),
      ],
    ),
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
