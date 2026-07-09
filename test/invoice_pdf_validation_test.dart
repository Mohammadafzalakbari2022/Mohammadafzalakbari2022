import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/printing/invoice_pdf_validation.dart';

void main() {
  group('isValidPdfBytes', () {
    test('accepts PDF header', () {
      expect(isValidPdfBytes('%PDF-1.7'.codeUnits), isTrue);
    });

    test('rejects empty bytes', () {
      expect(isValidPdfBytes(const []), isFalse);
    });

    test('rejects non-PDF bytes', () {
      expect(isValidPdfBytes('hello'.codeUnits), isFalse);
    });
  });
}
