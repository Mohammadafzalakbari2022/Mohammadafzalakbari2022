import 'package:pdf/pdf.dart';

/// Layout and brand tokens for invoice PDF v2 (single source — no scattered magic numbers).
abstract final class InvoicePdfLayout {
  static const pageFormat = PdfPageFormat.a4;
  static const pageMarginL = 18.0;
  static const pageMarginT = 14.0;
  static const pageMarginR = 18.0;
  static const pageMarginB = 16.0;

  static const sectionGap = 10.0;
  static const cardRadius = 6.0;
  static const cardBorderWidth = 0.6;

  /// Banner height — primary header area (shop + order meta).
  static const bannerHeightPt = 96.0;

  static const logoBoxPt = 52.0;
  static const headerLogoMaxPx = 200;

  /// ~35% larger than legacy 185pt catalog display.
  static const catalogDisplayHeightPt = 250.0;

  /// ~35% larger than legacy 72pt shape thumbnails.
  static const shapeImagePt = 98.0;

  /// Measurement table rows per chunk (MultiPage can span chunks across pages).
  static const measurementRowsPerChunk = 10;

  static const shapeImageLoadPx = 196;

  static const catalogMaxWidthPx = 380;
  static const catalogMaxHeightPx = 700;

  static const maxShapesPerGarment = 24;

  static const customerIdBadgeFontSize = 11.0;
  static const sectionTitleFontSize = 10.5;
  static const bodyFontSize = 9.0;
  static const smallFontSize = 8.0;
  static const paymentGrandFontSize = 13.0;
  static const paymentRemainingFontSize = 12.0;
}

abstract final class InvoicePdfColors {
  /// Matches [kPrideCustomerIdLight] in app UI.
  static final customerIdBadge = PdfColor.fromInt(0xFF475569);

  static final accent = PdfColor.fromInt(0xFF5B3FA6);
  static final accentDark = PdfColor.fromInt(0xFF4A3288);
  static final accentMid = PdfColor.fromInt(0xFF6D28D9);
  static final accentTeal = PdfColor.fromInt(0xFF0D9488);
  static final accentLight = PdfColor.fromInt(0xFFEDE8F5);
  static final surface = PdfColor.fromInt(0xFFF7F5FB);
  static final surfaceAlt = PdfColor.fromInt(0xFFEFECF4);
  static final border = PdfColors.grey400;
  static const onBanner = PdfColors.white;
  static final bannerOverlay = PdfColor.fromInt(0x73000000);
}
