import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bundled font for RTL invoice PDFs (Dari, Pashto, English).
class InvoicePdfFonts {
  InvoicePdfFonts._();

  static pw.Font? _regular;

  static Future<pw.Font> regular() async {
    if (_regular != null) return _regular!;
    final data = await rootBundle.load(
      'assets/fonts/NotoNaskhArabic-Regular.ttf',
    );
    _regular = pw.Font.ttf(data);
    return _regular!;
  }
}
