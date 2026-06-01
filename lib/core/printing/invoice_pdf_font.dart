import 'package:flutter/services.dart';
import 'package:pdf/widgets.dart' as pw;

/// Bundled fonts for RTL invoice PDFs (Dari, Pashto, English).
///
/// Body text uses [Noto Naskh Arabic]; emphasis uses [Vazirmatn] bold.
class InvoicePdfFonts {
  InvoicePdfFonts._();

  static const _regularAsset = 'assets/fonts/NotoNaskhArabic-Regular.ttf';
  static const _boldAsset = 'assets/fonts/Vazirmatn-Bold.ttf';
  static const _latinFallbackAsset = 'assets/fonts/Vazirmatn-Regular.ttf';

  static pw.Font? _regular;
  static pw.Font? _bold;
  static pw.Font? _latinFallback;

  /// Loads regular + bold; throws if assets are missing (caller may retry).
  static Future<InvoicePdfFontSet> load() async {
    if (_regular != null && _bold != null && _latinFallback != null) {
      return InvoicePdfFontSet(
        regular: _regular!,
        bold: _bold!,
        latinFallback: _latinFallback!,
      );
    }
    final regularData = await rootBundle.load(_regularAsset);
    final boldData = await rootBundle.load(_boldAsset);
    final latinData = await rootBundle.load(_latinFallbackAsset);
    _regular = pw.Font.ttf(regularData);
    _bold = pw.Font.ttf(boldData);
    _latinFallback = pw.Font.ttf(latinData);
    return InvoicePdfFontSet(
      regular: _regular!,
      bold: _bold!,
      latinFallback: _latinFallback!,
    );
  }

  static pw.ThemeData themeFor(InvoicePdfFontSet fonts) {
    return pw.ThemeData.withFont(
      base: fonts.regular,
      bold: fonts.bold,
      fontFallback: [fonts.latinFallback],
    );
  }
}

class InvoicePdfFontSet {
  const InvoicePdfFontSet({
    required this.regular,
    required this.bold,
    required this.latinFallback,
  });

  final pw.Font regular;
  final pw.Font bold;
  final pw.Font latinFallback;
}
