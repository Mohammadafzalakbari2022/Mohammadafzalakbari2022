import '../../data/local/measurement_unit_codes.dart';
import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../l10n/app_localizations.dart';

/// Measurement body for PDF — localized units, no Latin `cm` / `in`.
String? formatInvoiceMeasurementsBody({
  required AppLocalizations l10n,
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
}) {
  final cmUnit = _pdfUnitSuffix(l10n, MeasurementUnitCodes.cm);
  final inUnit = _pdfUnitSuffix(l10n, MeasurementUnitCodes.inch);

  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    final lines = items
        .where((it) => it.value.trim().isNotEmpty)
        .map(
          (it) =>
              '${it.typeName}: ${it.value.trim()}'
              '${_pdfUnitSuffix(l10n, it.unitCode)}',
        )
        .toList();
    if (lines.isEmpty) return null;
    return lines.join('\n');
  }

  final snap = order.measurementsSnapshot.trim();
  if (snap.isEmpty) return null;
  return _localizeSnapshotUnits(snap, cmUnit: cmUnit, inUnit: inUnit);
}

String _pdfUnitSuffix(AppLocalizations l10n, int unitCode) {
  if (unitCode == MeasurementUnitCodes.inch) {
    return ' ${l10n.measurementUnitInch}';
  }
  return ' ${l10n.measurementUnitCm}';
}

String _localizeSnapshotUnits(
  String text, {
  required String cmUnit,
  required String inUnit,
}) {
  var out = text;
  out = out.replaceAllMapped(
    RegExp(r'(\d)\s*cm\b', caseSensitive: false),
    (m) => '${m[1]}$cmUnit',
  );
  out = out.replaceAllMapped(
    RegExp(r'(\d)\s*in\b', caseSensitive: false),
    (m) => '${m[1]}$inUnit',
  );
  return out;
}
