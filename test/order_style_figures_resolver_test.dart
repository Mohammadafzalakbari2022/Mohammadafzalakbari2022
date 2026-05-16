import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/style/order_style_figures_resolver.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
  test('resolveOrderStyleFigures preserves sort order', () {
    const figures = [
      StyleFigureSummary(
        internalId: 'b',
        shopId: 's',
        partInternalId: 'p',
        name: 'B',
        imageRef: 'asset:shape_2',
        sortOrder: 2,
        isActive: true,
      ),
      StyleFigureSummary(
        internalId: 'a',
        shopId: 's',
        partInternalId: 'p',
        name: 'A',
        imageRef: 'asset:shape_1',
        sortOrder: 1,
        isActive: true,
      ),
    ];

    final resolved = resolveOrderStyleFigures(
      styleSelectionJson: '["b","a"]',
      allFigures: figures,
    );

    expect(resolved.map((f) => f.internalId).toList(), ['a', 'b']);
  });
}
