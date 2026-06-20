import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/orders/order_composer_shape_select_tile.dart';

void main() {
  group('orderComposerShapeGridColumns', () {
    test('uses two columns on very narrow screens', () {
      expect(orderComposerShapeGridColumns(320), 2);
    });

    test('uses three columns on normal mobile width', () {
      expect(orderComposerShapeGridColumns(360), 3);
      expect(orderComposerShapeGridColumns(400), 3);
    });

    test('uses four columns on wider phones', () {
      expect(orderComposerShapeGridColumns(520), 4);
      expect(orderComposerShapeGridColumns(600), 4);
    });

    test('uses five columns on tablet width', () {
      expect(orderComposerShapeGridColumns(720), 5);
      expect(orderComposerShapeGridColumns(900), 5);
    });
  });
}
