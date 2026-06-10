import 'package:flutter_test/flutter_test.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:pride_v3/core/printing/pdf_bidi_text.dart';

void main() {
  group('pdfResolveTextDirection', () {
    test('uses RTL for pure Dari text', () {
      expect(
        pdfResolveTextDirection(
          text: 'مشتری: احمد',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.rtl,
      );
    });

    test('uses RTL for pure Pashto text', () {
      expect(
        pdfResolveTextDirection(
          text: 'پیرودونکی: احمد',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.rtl,
      );
    });

    test('uses LTR for pure Latin order numbers', () {
      expect(
        pdfResolveTextDirection(
          text: '00000042',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.ltr,
      );
    });

    test('uses RTL for mixed Dari and Latin', () {
      expect(
        pdfResolveTextDirection(
          text: 'شکل: Shape1',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.rtl,
      );
    });

    test('uses RTL for localized order number label', () {
      expect(
        pdfResolveTextDirection(
          text: 'شناسه سفارش: 00042',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.rtl,
      );
    });

    test('uses RTL for localized customer number label', () {
      expect(
        pdfResolveTextDirection(
          text: 'شناسه مشتری: 00007',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.rtl,
      );
    });

    test('uses LTR for inch measurements without Arabic script', () {
      expect(
        pdfResolveTextDirection(
          text: '5 X 5 1/2',
          documentDirection: pw.TextDirection.rtl,
        ),
        pw.TextDirection.ltr,
      );
    });
  });

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

    test('keeps inch measurements in one LTR segment', () {
      const measurement = '5 X 5 1/2';
      final segments = pdfSplitMixedTextSegments(measurement);
      expect(segments, hasLength(1));
      expect(segments.first.text, measurement);
      expect(segments.first.direction, pw.TextDirection.ltr);
    });

    test('keeps mixed Dari label with inch measurement readable', () {
      const input = 'اندازه: 5 X 5 1/2';
      final segments = pdfSplitMixedTextSegments(input);
      final measurement = segments.firstWhere(
        (s) => s.text.contains('5 X 5 1/2'),
        orElse: () => throw StateError('measurement segment missing'),
      );
      expect(measurement.direction, pw.TextDirection.ltr);
      expect(measurement.text, '5 X 5 1/2');
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
    test('builds widget for Dari currency suffix', () {
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

  group('pdfHasArabicScript', () {
    test('detects Dari and Pashto script', () {
      expect(pdfHasArabicScript('احمد'), isTrue);
      expect(pdfHasArabicScript('پیرودونکی'), isTrue);
      expect(pdfHasArabicScript('Khayat'), isFalse);
    });
  });
}
