import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/order_item_draft.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/features/orders/order_composer_draft.dart';
import 'package:pride_v3/features/orders/order_payment_rules.dart';

void main() {
  OrderItemDraft filledItem(GarmentType type, {int price = 500000}) {
    return OrderItemDraft(
      garmentType: type,
      included: true,
      priceAmountMinor: price,
      measurementsSnapshot: 'Chest 98',
      styleName: 'Classic',
      styleSummary: 'Classic style',
    );
  }

  group('OrderComposerDraft', () {
    test('defaults to Perahan/Tunban selected', () {
      final draft = OrderComposerDraft.initial();
      expect(draft.items[GarmentType.perahanTunban]!.included, isTrue);
      expect(draft.items[GarmentType.waistcoat]!.included, isFalse);
    });

    test('can create Perahan-only draft', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban),
      );
      expect(draft.selectedGarmentTypes, [GarmentType.perahanTunban]);
      expect(draft.totalMinor(clothBlockEnabled: true), 500000);
    });

    test('can create Waistcoat-only draft', () {
      var draft = OrderComposerDraft.initial();
      draft = draft
          .toggleGarment(GarmentType.waistcoat, true)
          .toggleGarment(GarmentType.perahanTunban, false)
          .updateItem(
            GarmentType.waistcoat,
            filledItem(GarmentType.waistcoat, price: 300000),
          );
      expect(draft.selectedGarmentTypes, [GarmentType.waistcoat]);
      expect(draft.totalMinor(clothBlockEnabled: true), 300000);
    });

    test('can create both-items draft with summed total', () {
      var draft = OrderComposerDraft.initial();
      draft = draft
          .toggleGarment(GarmentType.waistcoat, true)
          .updateItem(
            GarmentType.perahanTunban,
            filledItem(GarmentType.perahanTunban, price: 400000),
          )
          .updateItem(
            GarmentType.waistcoat,
            filledItem(GarmentType.waistcoat, price: 200000),
          );
      expect(draft.selectedGarmentTypes.length, 2);
      expect(draft.totalMinor(clothBlockEnabled: true), 600000);
    });

    test('cannot deselect last garment type', () {
      final draft = OrderComposerDraft.initial();
      final next = draft.toggleGarment(GarmentType.perahanTunban, false);
      expect(next.selectedGarmentTypes, isNotEmpty);
    });

    test('cannot deselect to zero items via toggleGarment', () {
      final draft = OrderComposerDraft.initial();
      final next = draft.toggleGarment(GarmentType.perahanTunban, false);
      expect(next.hasAtLeastOneItem, isTrue);
      expect(
        next.canSave(
          customerSelected: true,
          paidMinor: 0,
          clothBlockEnabled: true,
        ),
        isFalse,
      );
    });

    test('cannot save with zero price when customer is set', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 0),
      );
      expect(
        draft.canSave(customerSelected: true, paidMinor: 0, clothBlockEnabled: true),
        isFalse,
      );
    });

    test('cannot save without customer', () {
      final draft = OrderComposerDraft.initial();
      expect(
        draft.canSave(customerSelected: false, paidMinor: 0, clothBlockEnabled: true),
        isFalse,
      );
    });

    test('cannot save with price but zero initial payment', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000),
      );
      expect(
        draft.canSave(
          customerSelected: true,
          paidMinor: 0,
          clothBlockEnabled: true,
        ),
        isFalse,
      );
    });

    test('can save with garment price and initial payment', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000),
      );
      expect(
        draft.canSave(
          customerSelected: true,
          paidMinor: 50000,
          clothBlockEnabled: true,
        ),
        isTrue,
      );
    });

    test('paid cannot exceed total', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000),
      );
      expect(
        draft.canSave(customerSelected: true, paidMinor: 200000, clothBlockEnabled: true),
        isFalse,
      );
      expect(
        OrderPaymentRules.isValidInitialPay(100000, 200000),
        isFalse,
      );
    });

    test('editing one item draft does not overwrite the other', () {
      var draft = OrderComposerDraft.initial()
          .toggleGarment(GarmentType.waistcoat, true)
          .updateItem(
            GarmentType.perahanTunban,
            filledItem(GarmentType.perahanTunban, price: 100000),
          )
          .updateItem(
            GarmentType.waistcoat,
            filledItem(GarmentType.waistcoat, price: 200000),
          );

      draft = draft.updateItem(
        GarmentType.waistcoat,
        draft.items[GarmentType.waistcoat]!.copyWith(
          measurementsSnapshot: 'Waistcoat only',
        ),
      );

      expect(
        draft.items[GarmentType.perahanTunban]!.measurementsSnapshot,
        'Chest 98',
      );
      expect(
        draft.items[GarmentType.waistcoat]!.measurementsSnapshot,
        'Waistcoat only',
      );
    });

    test('toCreateInputs returns correct count and types', () {
      var draft = OrderComposerDraft.initial()
          .toggleGarment(GarmentType.waistcoat, true)
          .updateItem(
            GarmentType.perahanTunban,
            filledItem(GarmentType.perahanTunban, price: 100000),
          )
          .updateItem(
            GarmentType.waistcoat,
            filledItem(GarmentType.waistcoat, price: 200000),
          );

      final inputs = draft.toCreateInputs(
        styleSelections: {
          GarmentType.perahanTunban: const StyleOrderSelection.empty(),
          GarmentType.waistcoat: const StyleOrderSelection.empty(),
        },
      );
      expect(inputs.length, 2);
      expect(
        inputs.map((i) => i.garmentType).toSet(),
        {GarmentType.perahanTunban, GarmentType.waistcoat},
      );
      expect(
        inputs.fold<int>(0, (s, i) => s + i.priceAmountMinor),
        300000,
      );
    });

    test('toCreateInputs strips cloth fields when includeClothFields is false', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000).copyWith(
          fabricName: 'Wool',
          fabricColor: 'Navy',
          fabricId: 'fab-1',
          fabricNamePresetInternalId: 'preset-name',
          fabricColorPresetInternalId: 'preset-color',
          clothMeters: '2.5',
          clothPriceAmountMinor: 50000,
        ),
      );

      final inputs = draft.toCreateInputs(
        styleSelections: {
          GarmentType.perahanTunban: const StyleOrderSelection.empty(),
        },
        includeClothFields: false,
      );

      expect(inputs.length, 1);
      final item = inputs.single;
      expect(item.fabricNameSnapshot, isEmpty);
      expect(item.fabricColorSnapshot, isEmpty);
      expect(item.fabricIdSnapshot, isEmpty);
      expect(item.fabricNamePresetInternalId, isNull);
      expect(item.fabricColorPresetInternalId, isNull);
      expect(item.clothMetersSnapshot, isEmpty);
      expect(item.clothPriceAmountMinor, 0);
      expect(item.priceAmountMinor, 100000);
    });

    test('showPerahanPreviousReference follows Perahan selection', () {
      var draft = OrderComposerDraft.initial();
      expect(draft.showPerahanPreviousReference, isTrue);
      draft = draft
          .toggleGarment(GarmentType.waistcoat, true)
          .toggleGarment(GarmentType.perahanTunban, false);
      expect(draft.showPerahanPreviousReference, isFalse);
    });
  });

  group('firstOrderComposerSaveValidationIssue', () {
    test('returns customerRequired when customer missing', () {
      final draft = OrderComposerDraft.initial();
      expect(
        firstOrderComposerSaveValidationIssue(
          draft: draft,
          customerSelected: false,
          paidMinor: 50000,
          clothBlockEnabled: true,
        ),
        OrderComposerSaveValidationIssue.customerRequired,
      );
    });

    test('returns initialPaymentRequired for new orders with zero payment', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000),
      );
      expect(
        firstOrderComposerSaveValidationIssue(
          draft: draft,
          customerSelected: true,
          paidMinor: 0,
          clothBlockEnabled: true,
        ),
        OrderComposerSaveValidationIssue.initialPaymentRequired,
      );
    });

    test('allows zero payment when editing existing order', () {
      var draft = OrderComposerDraft.initial();
      draft = draft.updateItem(
        GarmentType.perahanTunban,
        filledItem(GarmentType.perahanTunban, price: 100000),
      );
      expect(
        firstOrderComposerSaveValidationIssue(
          draft: draft,
          customerSelected: true,
          paidMinor: 0,
          clothBlockEnabled: true,
          requireInitialPayment: false,
        ),
        isNull,
      );
    });
  });

  group('paymentBreakdownFromDraft', () {
    test('builds one line per selected item', () {
      final draft = OrderComposerDraft.initial()
          .toggleGarment(GarmentType.waistcoat, true)
          .updateItem(
            GarmentType.perahanTunban,
            filledItem(GarmentType.perahanTunban, price: 100000),
          )
          .updateItem(
            GarmentType.waistcoat,
            filledItem(GarmentType.waistcoat, price: 50000),
          );
      final lines = paymentBreakdownFromDraft(draft);
      expect(lines.length, 2);
      expect(lines.fold<int>(0, (s, l) => s + l.amountMinor), 150000);
    });
  });
}
