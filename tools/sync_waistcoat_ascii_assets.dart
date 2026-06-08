// One-shot: copy bundled waistcoat PNGs to ASCII filenames (wc_01.png … wc_47.png).
// Run from repo root: dart run tools/sync_waistcoat_ascii_assets.dart
import 'dart:io';

import 'package:pride_v3/data/local/style/style_catalog_waistcoat_bundled.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';

void main() {
  final root = Directory.current;
  if (!File('${root.path}/pubspec.yaml').existsSync()) {
    stderr.writeln('Run from Pride-v3 repo root.');
    exit(1);
  }

  var copied = 0;
  for (final template in bundledWaistcoatFigureTemplates) {
    final src = File(
      '${root.path}/assets/style_figures_waistcoat/${template.sourceRelativePath}',
    );
    final dst = File(
      '${root.path}/${StyleFigureImageRef.waistcoatBundledAssetPath(template.shapeNumber)}',
    );
    if (!src.existsSync()) {
      stderr.writeln('Missing source: ${src.path}');
      exit(1);
    }
    dst.writeAsBytesSync(src.readAsBytesSync());
    copied++;
  }
  stdout.writeln('Copied $copied waistcoat assets to wc_XX.png');
}
