// ignore_for_file: avoid_print
import 'dart:io';

import 'package:image/image.dart' as img;

/// Generates small store badge PNGs for PDF invoice footer.
void main() {
  final outDir = Directory('assets/branding');
  if (!outDir.existsSync()) outDir.createSync(recursive: true);

  _writeGooglePlay('${outDir.path}/invoice_google_play_badge.png');
  _writeAppStore('${outDir.path}/invoice_app_store_badge.png');
  print('Wrote invoice store badges under assets/branding/');
}

void _writeGooglePlay(String path) {
  final w = 72;
  final h = 20;
  final im = img.Image(width: w, height: h);
  img.fill(im, color: img.ColorRgb8(245, 245, 245));
  img.drawRect(im,
      x1: 0,
      y1: 0,
      x2: w - 1,
      y2: h - 1,
      color: img.ColorRgb8(130, 130, 130));
  // Play triangle (Google Play green)
  img.fillPolygon(im,
      vertices: [
        img.Point(10, 5),
        img.Point(10, 15),
        img.Point(22, 10),
      ],
      color: img.ColorRgb8(60, 140, 70));
  img.drawString(im, 'Google Play',
      font: img.arial14,
      x: 26,
      y: 4,
      color: img.ColorRgb8(70, 70, 70));
  File(path).writeAsBytesSync(img.encodePng(im));
}

void _writeAppStore(String path) {
  final w = 72;
  final h = 20;
  final im = img.Image(width: w, height: h);
  img.fill(im, color: img.ColorRgb8(245, 245, 245));
  img.drawRect(im,
      x1: 0,
      y1: 0,
      x2: w - 1,
      y2: h - 1,
      color: img.ColorRgb8(130, 130, 130));
  img.fillCircle(im,
      x: 12, y: 10, radius: 5, color: img.ColorRgb8(50, 50, 50));
  img.drawString(im, 'App Store',
      font: img.arial14,
      x: 22,
      y: 4,
      color: img.ColorRgb8(70, 70, 70));
  File(path).writeAsBytesSync(img.encodePng(im));
}
