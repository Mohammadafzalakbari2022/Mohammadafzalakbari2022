import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/measurement_type_summary.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/data/local/order_item_input.dart';
import 'package:pride_v3/data/local/order_item_summary.dart';
import 'package:pride_v3/data/local/order_measurement_snapshot_item_input.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/features/orders/order_composer_draft.dart';
import 'package:pride_v3/features/orders/order_composer_measurements_result.dart';
import 'package:pride_v3/features/orders/order_composer_screen.dart'
    show mergeComposerEditInput;

void main() {
  test('buildOrderMeasurementsEditorResult captures all non-empty fields', () {
    final result = buildOrderMeasurementsEditorResult(
      types: const [
        MeasurementTypeSummary(
          internalId: 'mt-chest',
          name: 'Chest',
          sortOrder: 10,
          isActive: true,
        ),
        MeasurementTypeSummary(
          internalId: 'mt-sleeve',
          name: 'Sleeve',
          sortOrder: 20,
          isActive: true,
        ),
      ],
      valuesByTypeId: {
        'mt-chest': '44',
        'mt-sleeve': '62',
      },
      unitCode: MeasurementUnitCodes.cm,
    );

    expect(result.measurementSnapshotItems, hasLength(2));
    expect(result.measurementsSnapshot, contains('Chest'));
    expect(result.measurementsSnapshot, contains('44'));
    expect(result.measurementsSnapshot, contains('Sleeve'));
  });

  test('toCreateInputs passes structured measurement rows when draft has them', () {
    const item = OrderMeasurementSnapshotItemInput(
      measurementTypeInternalId: 'mt-chest',
      typeName: 'Chest',
      value: '44',
      unitCode: MeasurementUnitCodes.cm,
      sortOrder: 10,
    );
    var draft = OrderComposerDraft.initial().toggleGarment(
      GarmentType.perahanTunban,
      true,
    );
    draft = draft.updateItem(
      GarmentType.perahanTunban,
      draft.items[GarmentType.perahanTunban]!.copyWith(
        measurementsSnapshot: 'Chest: 44 cm',
        measurementSnapshotItems: const [item],
      ),
    );

    final inputs = draft.toCreateInputs(
      styleSelections: {
        GarmentType.perahanTunban: const StyleOrderSelection.empty(),
      },
    );

    expect(inputs, hasLength(1));
    expect(inputs.single.measurementSnapshotItems, hasLength(1));
    expect(inputs.single.measurementsSnapshot, contains('Chest'));
  });

  test('mergeComposerEditInput preserves snapshots when structured rows omitted', () {
    final now = DateTime.utc(2026, 1, 1);
    final existing = OrderItemSummary(
      internalId: 'item-1',
      orderInternalId: 'order-1',
      garmentType: GarmentType.perahanTunban,
      priceAmountMinor: 50000,
      sortOrder: 0,
      measurementsSnapshot: 'Chest: 44 cm',
      createdAt: now,
      updatedAt: now,
    );
    final draft = OrderItemCreateInput(
      garmentType: GarmentType.perahanTunban,
      priceAmountMinor: 50000,
      sortOrder: 0,
      measurementsSnapshot: 'Chest: 44 cm',
      measurementSnapshotItems: null,
    );

    final merged = mergeComposerEditInput(draft, existing);
    expect(merged.measurementSnapshotItems, isNull);
    expect(merged.measurementsSnapshot, contains('Chest'));
  });

  test('normalizedMeasurementSnapshotItems returns null for empty list', () {
    expect(normalizedMeasurementSnapshotItems(const []), isNull);
    expect(
      normalizedMeasurementSnapshotItems(
        const [
          OrderMeasurementSnapshotItemInput(
            measurementTypeInternalId: 'id',
            typeName: 'Chest',
            value: '40',
            unitCode: MeasurementUnitCodes.cm,
            sortOrder: 10,
          ),
        ],
      ),
      hasLength(1),
    );
  });
}
