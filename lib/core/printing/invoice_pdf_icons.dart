import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Small vector icons for PDF invoices (no Material font dependency).
class InvoicePdfIcons {
  static pw.Widget phone({double size = 11, PdfColor? color}) {
    return _iconBox(
      size: size,
      painter: (canvas, bounds, c) {
        canvas.setFillColor(c);
        canvas.drawRect(
          bounds.x * 0.28,
          bounds.y * 0.08,
          bounds.x * 0.44,
          bounds.y * 0.84,
        );
        canvas.setFillColor(PdfColors.white);
        canvas.drawEllipse(
          bounds.x * 0.5,
          bounds.y * 0.9,
          bounds.x * 0.08,
          bounds.y * 0.04,
        );
      },
      color: color ?? PdfColors.grey700,
    );
  }

  static pw.Widget location({double size = 11, PdfColor? color}) {
    return _iconBox(
      size: size,
      painter: (canvas, bounds, c) {
        canvas.setFillColor(c);
        canvas.drawEllipse(
          bounds.x * 0.5,
          bounds.y * 0.38,
          bounds.x * 0.34,
          bounds.y * 0.34,
        );
        canvas.moveTo(bounds.x * 0.5, bounds.y * 0.95);
        canvas.lineTo(bounds.x * 0.18, bounds.y * 0.52);
        canvas.lineTo(bounds.x * 0.82, bounds.y * 0.52);
        canvas.closePath();
        canvas.fillPath();
        canvas.setFillColor(PdfColors.white);
        canvas.drawEllipse(
          bounds.x * 0.5,
          bounds.y * 0.38,
          bounds.x * 0.12,
          bounds.y * 0.12,
        );
      },
      color: color ?? PdfColors.grey700,
    );
  }

  static pw.Widget person({double size = 11, PdfColor? color}) {
    return _iconBox(
      size: size,
      painter: (canvas, bounds, c) {
        canvas.setFillColor(c);
        canvas.drawEllipse(
          bounds.x * 0.5,
          bounds.y * 0.28,
          bounds.x * 0.22,
          bounds.y * 0.22,
        );
        canvas.drawEllipse(
          bounds.x * 0.5,
          bounds.y * 0.78,
          bounds.x * 0.38,
          bounds.y * 0.32,
        );
      },
      color: color ?? PdfColors.grey700,
    );
  }

  static pw.Widget _iconBox({
    required double size,
    required void Function(
      PdfGraphics canvas,
      PdfPoint bounds,
      PdfColor color,
    )
    painter,
    required PdfColor color,
  }) {
    return pw.SizedBox(
      width: size,
      height: size,
      child: pw.CustomPaint(
        size: PdfPoint(size, size),
        painter: (canvas, bounds) => painter(canvas, bounds, color),
      ),
    );
  }
}
