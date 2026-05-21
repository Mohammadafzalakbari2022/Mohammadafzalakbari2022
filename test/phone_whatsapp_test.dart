import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/printing/phone_whatsapp.dart';

void main() {
  group('normalizePhoneForWhatsApp', () {
    test('converts Afghan 07 prefix to 93', () {
      expect(normalizePhoneForWhatsApp('0700123456'), '93700123456');
    });

    test('strips spaces and plus', () {
      expect(normalizePhoneForWhatsApp('+93 70 012 3456'), '93700123456');
    });

    test('handles 00 international prefix', () {
      expect(normalizePhoneForWhatsApp('0093700123456'), '93700123456');
    });

    test('returns null for empty', () {
      expect(normalizePhoneForWhatsApp(''), isNull);
      expect(normalizePhoneForWhatsApp('abc'), isNull);
    });
  });
}
