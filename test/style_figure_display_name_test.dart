import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/style/style_figure_display_name.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
  group('resolveStyleFigureDisplayName', () {
    test('returns custom name when set', () {
      expect(
        resolveStyleFigureDisplayName(
          name: 'Classic Collar',
          imageRef: StyleFigureImageRef.bundledAssetKey(1),
          sortOrder: 10,
        ),
        'Classic Collar',
      );
    });

    test('returns Shape N for bundled asset refs', () {
      expect(
        resolveStyleFigureDisplayName(
          name: '',
          imageRef: StyleFigureImageRef.bundledAssetKey(3),
          sortOrder: 30,
        ),
        'Shape 3',
      );
    });

    test('uses sortOrder fallback when asset ref is not bundled', () {
      expect(
        resolveStyleFigureDisplayName(
          name: '',
          imageRef: 'file:style_figures/custom.png',
          sortOrder: 40,
        ),
        'Shape 4',
      );
    });

    test('summary wrapper delegates to resolver', () {
      const figure = StyleFigureSummary(
        internalId: 'id',
        shopId: 'shop',
        partInternalId: 'part',
        name: '',
        imageRef: 'asset:shape_7',
        sortOrder: 70,
        isActive: true,
      );
      expect(resolveStyleFigureSummaryDisplayName(figure), 'Shape 7');
    });
  });
}
