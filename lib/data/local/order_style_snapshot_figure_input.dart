import 'dart:convert';

import 'style/style_order_selection.dart';

/// One selected figure to persist on order creation.
class OrderStyleSnapshotFigureInput {
  const OrderStyleSnapshotFigureInput({
    required this.styleFigureInternalId,
    required this.figureNameSnapshot,
    required this.imageRefSnapshot,
    required this.sortOrder,
    this.presetInternalIdSnapshot,
    this.presetNameSnapshot = '',
    this.textOptionsSnapshotJson = '[]',
    this.sizeOptionsSnapshotJson = '[]',
  });

  final String styleFigureInternalId;
  final String figureNameSnapshot;
  final String imageRefSnapshot;
  final int sortOrder;
  final String? presetInternalIdSnapshot;
  final String presetNameSnapshot;
  final String textOptionsSnapshotJson;
  final String sizeOptionsSnapshotJson;

  factory OrderStyleSnapshotFigureInput.fromShapeItem(
    OrderShapeSelectionItem item, {
    required int sortOrder,
  }) {
    return OrderStyleSnapshotFigureInput(
      styleFigureInternalId: item.shapeId,
      figureNameSnapshot: item.shapeNameSnapshot,
      imageRefSnapshot: item.imageRefSnapshot,
      sortOrder: sortOrder,
      presetInternalIdSnapshot: item.presetId,
      presetNameSnapshot: item.presetNameSnapshot?.trim() ?? '',
      textOptionsSnapshotJson: encodeOrderShapeOptionSnapshots(item.textOptions),
      sizeOptionsSnapshotJson: encodeOrderShapeSizeSnapshots(item.sizeOptions),
    );
  }
}

String encodeOrderShapeOptionSnapshots(List<OrderShapeOptionSnapshot> options) {
  if (options.isEmpty) return '[]';
  return jsonEncode(options.map((e) => e.toJson()).toList());
}

String encodeOrderShapeSizeSnapshots(List<OrderShapeSizeSnapshot> options) {
  if (options.isEmpty) return '[]';
  return jsonEncode(options.map((e) => e.toJson()).toList());
}

List<OrderShapeOptionSnapshot> decodeOrderShapeOptionSnapshots(String? json) {
  if (json == null || json.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => OrderShapeOptionSnapshot.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.id.isNotEmpty)
        .toList(growable: false);
  } catch (_) {
    return const [];
  }
}

List<OrderShapeSizeSnapshot> decodeOrderShapeSizeSnapshots(String? json) {
  if (json == null || json.trim().isEmpty) return const [];
  try {
    final decoded = jsonDecode(json);
    if (decoded is! List) return const [];
    return decoded
        .whereType<Map>()
        .map((e) => OrderShapeSizeSnapshot.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.id.isNotEmpty)
        .toList(growable: false);
  } catch (_) {
    return const [];
  }
}
