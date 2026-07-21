import '../../data/local/measurement_profile_formatting.dart';
import '../../data/local/measurement_profile_line.dart';
import '../../data/local/measurement_type_summary.dart';
import '../../data/local/order_measurement_snapshot_item_input.dart';
import 'order_composer_measurements_sheet.dart';

/// Builds measurement editor output from type definitions and field values.
OrderMeasurementsEditorResult buildOrderMeasurementsEditorResult({
  required List<MeasurementTypeSummary> types,
  required Map<String, String> valuesByTypeId,
  required int unitCode,
  String? sourceMeasurementProfileId,
  String sourceMeasurementProfileLabel = '',
}) {
  var order = 0;
  final items = <OrderMeasurementSnapshotItemInput>[];
  final lines = <MeasurementProfileLine>[];
  final sorted = [...types]..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  for (final t in sorted) {
    final v = (valuesByTypeId[t.internalId] ?? '').trim();
    if (v.isEmpty) continue;
    order += 10;
    items.add(
      OrderMeasurementSnapshotItemInput(
        measurementTypeInternalId: t.internalId,
        typeName: t.name,
        value: v,
        unitCode: unitCode,
        sortOrder: order,
      ),
    );
    lines.add(
      MeasurementProfileLine(
        measurementTypeInternalId: t.internalId,
        typeName: t.name,
        value: v,
        unitCode: unitCode,
      ),
    );
  }
  return OrderMeasurementsEditorResult(
    measurementsSnapshot:
        MeasurementProfileFormatting.buildDisplayText(lines: lines, notes: ''),
    measurementSnapshotItems: items,
    sourceMeasurementProfileId: sourceMeasurementProfileId,
    sourceMeasurementProfileLabel: sourceMeasurementProfileLabel,
  );
}

bool measurementSnapshotItemsEqual(
  List<OrderMeasurementSnapshotItemInput> a,
  List<OrderMeasurementSnapshotItemInput> b,
) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (a[i].measurementTypeInternalId != b[i].measurementTypeInternalId ||
        a[i].value != b[i].value ||
        a[i].typeName != b[i].typeName) {
      return false;
    }
  }
  return true;
}

/// Normalizes structured measurement rows for persist (empty → null = skip/delete guard).
List<OrderMeasurementSnapshotItemInput>? normalizedMeasurementSnapshotItems(
  List<OrderMeasurementSnapshotItemInput>? items,
) {
  if (items == null || items.isEmpty) return null;
  return List<OrderMeasurementSnapshotItemInput>.of(items);
}
