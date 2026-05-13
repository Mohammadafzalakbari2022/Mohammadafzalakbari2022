import 'measurement_profile_line.dart';
import 'measurement_unit_codes.dart';

class MeasurementProfileFormatting {
  static String unitSuffix(int code) =>
      code == MeasurementUnitCodes.inch ? ' in' : ' cm';

  /// Text copied into orders and shown in pickers (snapshot-friendly).
  static String buildDisplayText({
    required List<MeasurementProfileLine> lines,
    required String notes,
  }) {
    final lineParts = lines
        .where((l) => l.value.trim().isNotEmpty)
        .map(
          (l) =>
              '${l.typeName}: ${l.value.trim()}${unitSuffix(l.unitCode)}',
        )
        .toList();
    if (lineParts.isEmpty) {
      return notes.trim();
    }
    final buf = StringBuffer()..writeAll(lineParts, '\n');
    if (notes.trim().isNotEmpty) {
      buf
        ..writeln()
        ..write(notes.trim());
    }
    return buf.toString();
  }
}
