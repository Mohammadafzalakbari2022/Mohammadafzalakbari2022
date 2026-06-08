import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/style/style_catalog_waistcoat_bundled.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('waistcoat bundled asset refs', () {
    test('numeric imageRef resolves to ASCII asset path', () {
      final template = bundledWaistcoatFigureTemplates.first;
      expect(template.imageRef, 'asset:wc:1');
      expect(
        StyleFigureImageRef.assetPathFromRef(template.imageRef),
        'assets/style_figures_waistcoat/wc_01.png',
      );
    });

    test('all 47 bundled PNGs exist under wc_XX names', () async {
      for (final template in bundledWaistcoatFigureTemplates) {
        final path = StyleFigureImageRef.assetPathFromRef(template.imageRef)!;
        await rootBundle.load(path);
      }
    });
  });
}
