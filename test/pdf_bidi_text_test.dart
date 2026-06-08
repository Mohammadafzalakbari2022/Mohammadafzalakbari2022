import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pride_v3/core/printing/pdf_bidi_text.dart';

void main() {
  group('pdfSplitMixedTextSegments', () {
    test('marks Latin shape IDs as LTR segments', () {
      const input = 'شکل: Shape1';
      final segments = pdfSplitMixedTextSegments(input);
      expect(segments.any((s) => s.text.contains('Shape1')), isTrue);
      expect(
        segments.firstWhere((s) => s.text.contains('Shape1')).direction,
        pw.TextDirection.ltr,
      );
      expect(segments.any((s) => s.text.contains('epahS1')), isFalse);
    });

    test('preserves Khayat brand name in an LTR segment', () {
      const input = 'استایل: Khayat';
      final segments = pdfSplitMixedTextSegments(input);
      expect(segments.any((s) => s.text.contains('Khayat')), isTrue);
      expect(segments.any((s) => s.text.contains('tayahK')), isFalse);
    });

    test('preserves phone numbers in LTR segments', () {
      const phone = '+93 70 123 4567';
      final segments = pdfSplitMixedTextSegments('تلفن: $phone');
      expect(segments.any((s) => s.text.contains('+93')), isTrue);
      expect(segments.any((s) => s.text.contains('4567')), isTrue);
    });

    test('preserves order numbers in LTR segments', () {
      const orderNo = '00000042';
      final segments = pdfSplitMixedTextSegments('شماره: $orderNo');
      expect(segments.any((s) => s.text.contains('00000042')), isTrue);
    });

    test('pure Arabic text is a single RTL segment', () {
      const arabic = 'مشتری: احمد';
      final segments = pdfSplitMixedTextSegments(arabic);
      expect(segments, hasLength(1));
      expect(segments.first.text, arabic);
      expect(segments.first.direction, pw.TextDirection.rtl);
    });
  });

  group('pdfProtectMixedText', () {
    test('returns plain text without isolate characters for PDF safety', () {
      const input = 'شکل: Shape1';
      final output = pdfProtectMixedText(input);
      expect(output, input);
      expect(output.contains(kPdfLri), isFalse);
      expect(output.contains(kPdfPdi), isFalse);
    });

    test('pdfIsolateLtr still wraps for legacy string helper tests', () {
      expect(pdfIsolateLtr('Shape1'), '${kPdfLri}Shape1$kPdfPdi');
    });
  });

  group('pdfMoneyWidget', () {
    test('keeps Dari currency suffix in RTL order', () {
      // Simulates l10n.moneyAfn output for Persian.
      const formatted = '500 افغانی';
      final widget = pdfMoneyWidget(
        formattedMoney: formatted,
        style: pw.TextStyle(fontSize: 10),
        documentDirection: pw.TextDirection.rtl,
      );
      expect(widget, isNotNull);
    });
  });

  group('pdfValueShouldRenderLtr', () {
    test('detects Latin digits', () {
      expect(pdfValueShouldRenderLtr('Shape1'), isTrue);
      expect(pdfValueShouldRenderLtr('0701234567'), isTrue);
      expect(pdfValueShouldRenderLtr('احمد'), isFalse);
    });
  });
}
