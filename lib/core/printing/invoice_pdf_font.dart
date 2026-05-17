import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bundled font for RTL invoice PDFs (Dari, Pashto, English).
class InvoicePdfFonts {
  InvoicePdfFonts._();

  static pw.Font? _arabic;
  static pw.Font? _helvetica;

  static pw.Font helvetica() => _helvetica ??= pw.Font.helvetica();

  /// Primary invoice font (Noto Naskh Arabic) with Helvetica for Latin digits/labels.
  static Future<pw.Font> primary() async {
    if (_arabic != null) return _arabic!;
    try {
      final data = await rootBundle.load(
        'assets/fonts/NotoNaskhArabic-Regular.ttf',
      );
      _arabic = pw.Font.ttf(data);
      return _arabic!;
    } on Object {
      return helvetica();
    }
  }

  static pw.ThemeData themeFor(pw.Font primary) {
    final latin = helvetica();
    final fallback = primary == latin ? const <pw.Font>[] : [latin];
    return pw.ThemeData.withFont(
      base: primary,
      bold: primary,
      fontFallback: fallback,
    );
  }

}
