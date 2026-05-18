import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bundled fonts for RTL invoice PDFs (Dari, Pashto, English).
///
/// Uses [Vazirmatn] (static TTF) — reliable with `pdf` 3.11+ and avoids
/// Noto Naskh compound-glyph null crashes on some devices.
class InvoicePdfFonts {
  InvoicePdfFonts._();

  static const _regularAsset = 'assets/fonts/Vazirmatn-Regular.ttf';
  static const _boldAsset = 'assets/fonts/Vazirmatn-Bold.ttf';

  static pw.Font? _regular;
  static pw.Font? _bold;

  /// Loads regular + bold; throws if assets are missing (caller may retry).
  static Future<InvoicePdfFontSet> load() async {
    if (_regular != null && _bold != null) {
      return InvoicePdfFontSet(regular: _regular!, bold: _bold!);
    }
    final regularData = await rootBundle.load(_regularAsset);
    final boldData = await rootBundle.load(_boldAsset);
    _regular = pw.Font.ttf(regularData);
    _bold = pw.Font.ttf(boldData);
    return InvoicePdfFontSet(regular: _regular!, bold: _bold!);
  }

  static pw.ThemeData themeFor(InvoicePdfFontSet fonts) {
    return pw.ThemeData.withFont(
      base: fonts.regular,
      bold: fonts.bold,
    );
  }
}

class InvoicePdfFontSet {
  const InvoicePdfFontSet({required this.regular, required this.bold});

  final pw.Font regular;
  final pw.Font bold;
}
