import '../../data/local/measurement_unit_codes.dart';
import '../../data/local/order_measurement_snapshot_view.dart';
import '../../data/local/order_summary.dart';
import '../../l10n/app_localizations.dart';

/// One measurement row for compact PDF tables.
class InvoiceMeasurementRow {
  const InvoiceMeasurementRow({required this.label, required this.value});

  final String label;
  final String value;
}

/// Structured measurement rows for PDF — localized units, no Latin `cm` / `in`.
List<InvoiceMeasurementRow> invoiceMeasurementRows({
  required AppLocalizations l10n,
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
}) {
  final cmUnit = _pdfUnitSuffix(l10n, MeasurementUnitCodes.cm);
  final inUnit = _pdfUnitSuffix(l10n, MeasurementUnitCodes.inch);

  final items = measurementSnap?.items ?? [];
  if (items.isNotEmpty) {
    final rows = items
        .where((it) => it.value.trim().isNotEmpty)
        .map(
          (it) => InvoiceMeasurementRow(
            label: it.typeName,
            value:
                '${it.value.trim()}${_pdfUnitSuffix(l10n, it.unitCode)}',
          ),
        )
        .toList();
    if (rows.isNotEmpty) return rows;
  }

  final snap = order.measurementsSnapshot.trim();
  if (snap.isEmpty) return const [];

  final localized = _localizeSnapshotUnits(snap, cmUnit: cmUnit, inUnit: inUnit);
  return localized
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .map((line) {
        final colon = line.indexOf(':');
        if (colon <= 0) {
          return InvoiceMeasurementRow(label: line, value: '');
        }
        return InvoiceMeasurementRow(
          label: line.substring(0, colon).trim(),
          value: line.substring(colon + 1).trim(),
        );
      })
      .toList();
}

/// Measurement body for legacy text fallback (share text, etc.).
String? formatInvoiceMeasurementsBody({
  required AppLocalizations l10n,
  required OrderSummary order,
  OrderMeasurementSnapshotView? measurementSnap,
}) {
  final rows = invoiceMeasurementRows(
    l10n: l10n,
    order: order,
    measurementSnap: measurementSnap,
  );
  if (rows.isEmpty) return null;
  return rows
      .map((r) => r.value.isEmpty ? r.label : '${r.label}: ${r.value}')
      .join('\n');
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
