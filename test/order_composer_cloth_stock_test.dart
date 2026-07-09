import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/order_item_draft.dart';
import 'package:pride_v3/features/orders/order_composer_draft.dart';

void main() {
  group('OrderComposerDraft cloth stock fields', () {
    test('toCreateInputs propagates shop stock fields', () {
      final draft = OrderComposerDraft.initial().updateItem(
        GarmentType.perahanTunban,
        OrderItemDraft.empty(GarmentType.perahanTunban).copyWith(
          included: true,
          priceAmountMinor: 5000,
          clothSourceIndex: 1,
          clothStockSkuInternalId: 'sku-1',
          clothSaleCostAmountMinor: 2000,
          clothPriceAmountMinor: 8000,
          clothMeters: '2.5',
        ),
      );

      final inputs = draft.toCreateInputs(
        styleSelections: const {},
        includeClothFields: true,
      );
      expect(inputs, hasLength(1));
      expect(inputs.single.clothSourceIndex, 1);
      expect(inputs.single.clothStockSkuInternalId, 'sku-1');
      expect(inputs.single.clothSaleCostAmountMinor, 2000);
      expect(inputs.single.clothMetersSnapshot, '2.5');
    });

    test('toCreateInputs strips stock fields when cloth block disabled', () {
      final draft = OrderComposerDraft.initial().updateItem(
        GarmentType.perahanTunban,
        OrderItemDraft.empty(GarmentType.perahanTunban).copyWith(
          included: true,
          priceAmountMinor: 5000,
          clothSourceIndex: 1,
          clothStockSkuInternalId: 'sku-1',
          clothSaleCostAmountMinor: 2000,
        ),
      );

      final inputs = draft.toCreateInputs(
        styleSelections: const {},
        includeClothFields: false,
      );
      expect(inputs.single.clothSourceIndex, 0);
      expect(inputs.single.clothStockSkuInternalId, isNull);
      expect(inputs.single.clothSaleCostAmountMinor, 0);
    });
  });
}
