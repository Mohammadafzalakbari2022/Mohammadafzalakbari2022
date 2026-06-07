import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/features/orders/order_composer_shape_select_tile.dart';

void main() {
  group('orderComposerShapeGridColumns', () {
    test('uses one column on very narrow screens', () {
      expect(orderComposerShapeGridColumns(320), 1);
    });

    test('uses two columns on normal mobile width', () {
      expect(orderComposerShapeGridColumns(360), 2);
      expect(orderComposerShapeGridColumns(400), 2);
    });

    test('uses three columns on wider screens', () {
      expect(orderComposerShapeGridColumns(700), 3);
      expect(orderComposerShapeGridColumns(900), 3);
    });
  });
}
