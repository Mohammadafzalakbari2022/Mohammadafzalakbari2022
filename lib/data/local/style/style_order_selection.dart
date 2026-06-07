import 'dart:convert';

import '../measurement_unit_codes.dart';
import '../style_figure_summary.dart';
import 'style_figure_display_name.dart';

/// Frozen text option selected on an order.
class OrderShapeOptionSnapshot {
  const OrderShapeOptionSnapshot({
    required this.id,
    required this.labelSnapshot,
  });

  final String id;
  final String labelSnapshot;

  factory OrderShapeOptionSnapshot.fromJson(Map<String, dynamic> json) {
    return OrderShapeOptionSnapshot(
      id: json['id']?.toString() ?? '',
      labelSnapshot: json['label_snapshot']?.toString() ??
          json['labelSnapshot']?.toString() ??
          '',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'label_snapshot': labelSnapshot,
      };
}

/// Frozen inch-size option selected on an order.
class OrderShapeSizeSnapshot {
  const OrderShapeSizeSnapshot({
    required this.id,
    required this.valueSnapshot,
    required this.labelSnapshot,
    required this.unitSnapshot,
  });

  final String id;
  final double valueSnapshot;
  final String labelSnapshot;
  final String unitSnapshot;

  factory OrderShapeSizeSnapshot.fromJson(Map<String, dynamic> json) {
    final rawValue = json['value_snapshot'] ?? json['valueSnapshot'];
    return OrderShapeSizeSnapshot(
      id: json['id']?.toString() ?? '',
      valueSnapshot: rawValue is num
          ? rawValue.toDouble()
          : double.tryParse(rawValue?.toString() ?? '') ?? 0,
      labelSnapshot: json['label_snapshot']?.toString() ??
          json['labelSnapshot']?.toString() ??
          '',
      unitSnapshot: json['unit_snapshot']?.toString() ??
          json['unitSnapshot']?.toString() ??
          'inch',
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'value_snapshot': valueSnapshot,
        'label_snapshot': labelSnapshot,
        'unit_snapshot': unitSnapshot,
      };
}

/// Per-shape order selection with frozen snapshots (v2).
class OrderShapeSelectionItem {
  const OrderShapeSelectionItem({
    required this.shapeId,
    this.shapeNameSnapshot = '',
    this.imageRefSnapshot = '',
    this.textOptions = const [],
    this.sizeOptions = const [],
    this.noteSnapshot,
  });

  final String shapeId;
  final String shapeNameSnapshot;
  final String imageRefSnapshot;
  final List<OrderShapeOptionSnapshot> textOptions;
  final List<OrderShapeSizeSnapshot> sizeOptions;
  final String? noteSnapshot;

  factory OrderShapeSelectionItem.fromJson(Map<String, dynamic> json) {
    final textRaw = json['text_options'] ?? json['textOptions'];
    final sizeRaw = json['size_options'] ?? json['sizeOptions'];
    return OrderShapeSelectionItem(
      shapeId: json['shape_id']?.toString() ??
          json['shapeId']?.toString() ??
          '',
      shapeNameSnapshot: json['shape_name_snapshot']?.toString() ??
          json['shapeNameSnapshot']?.toString() ??
          '',
      imageRefSnapshot: json['image_ref_snapshot']?.toString() ??
          json['imageRefSnapshot']?.toString() ??
          '',
      textOptions: _parseOptionList(textRaw),
      sizeOptions: _parseSizeList(sizeRaw),
      noteSnapshot: json['note_snapshot']?.toString() ??
          json['noteSnapshot']?.toString(),
    );
  }

  static List<OrderShapeOptionSnapshot> _parseOptionList(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => OrderShapeOptionSnapshot.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.id.isNotEmpty)
        .toList(growable: false);
  }

  static List<OrderShapeSizeSnapshot> _parseSizeList(Object? raw) {
    if (raw is! List) return const [];
    return raw
        .whereType<Map>()
        .map((e) => OrderShapeSizeSnapshot.fromJson(Map<String, dynamic>.from(e)))
        .where((e) => e.id.isNotEmpty)
        .toList(growable: false);
  }

  Map<String, dynamic> toJson() => {
        'shape_id': shapeId,
        if (shapeNameSnapshot.isNotEmpty)
          'shape_name_snapshot': shapeNameSnapshot,
        if (imageRefSnapshot.isNotEmpty)
          'image_ref_snapshot': imageRefSnapshot,
        if (textOptions.isNotEmpty)
          'text_options': textOptions.map((e) => e.toJson()).toList(),
        if (sizeOptions.isNotEmpty)
          'size_options': sizeOptions.map((e) => e.toJson()).toList(),
        if (noteSnapshot != null && noteSnapshot!.trim().isNotEmpty)
          'note_snapshot': noteSnapshot!.trim(),
      };
}

/// Per-order figure picks (any combination; not grouped by garment part).
class StyleOrderSelection {
  const StyleOrderSelection(
    Set<String> selectedFigureIds, {
    List<OrderShapeSelectionItem> shapeItems = const [],
  })  : _legacySelectedFigureIds = selectedFigureIds,
        shapeItems = shapeItems;

  const StyleOrderSelection.withItems({
    required List<OrderShapeSelectionItem> shapeItems,
  })  : _legacySelectedFigureIds = null,
        shapeItems = shapeItems;

  const StyleOrderSelection.empty()
      : _legacySelectedFigureIds = const {},
        shapeItems = const [];

  final Set<String>? _legacySelectedFigureIds;
  final List<OrderShapeSelectionItem> shapeItems;

  Set<String> get selectedFigureIds {
    if (shapeItems.isNotEmpty) {
      return shapeItems
          .map((e) => e.shapeId)
          .where((id) => id.isNotEmpty)
          .toSet();
    }
    return _legacySelectedFigureIds ?? const {};
  }

  bool get isEmpty => selectedFigureIds.isEmpty;

  static const _versionKey = 'version';
  static const _itemsKey = 'items';

  static StyleOrderSelection fromJsonString(String? json) {
    if (json == null || json.trim().isEmpty) {
      return const StyleOrderSelection.empty();
    }
    try {
      final decoded = jsonDecode(json);
      if (decoded is Map) {
        final map = Map<String, dynamic>.from(decoded);
        final version = map[_versionKey];
        if (version == 2) {
          final itemsRaw = map[_itemsKey];
          if (itemsRaw is List) {
            final items = itemsRaw
                .whereType<Map>()
                .map(
                  (e) => OrderShapeSelectionItem.fromJson(
                    Map<String, dynamic>.from(e),
                  ),
                )
                .where((e) => e.shapeId.isNotEmpty)
                .toList(growable: false);
            if (items.isNotEmpty) {
              return StyleOrderSelection.withItems(shapeItems: items);
            }
          }
          return const StyleOrderSelection.empty();
        }
      }
      if (decoded is List) {
        final ids = <String>{};
        for (final e in decoded) {
          final id = e?.toString() ?? '';
          if (id.isNotEmpty) ids.add(id);
        }
        return StyleOrderSelection(ids);
      }
      if (decoded is Map) {
        final ids = <String>{};
        for (final e in decoded.entries) {
          final v = e.value?.toString() ?? '';
          if (v.isNotEmpty) ids.add(v);
        }
        return StyleOrderSelection(ids);
      }
      return const StyleOrderSelection.empty();
    } catch (_) {
      return const StyleOrderSelection.empty();
    }
  }

  String toJsonString() {
    if (shapeItems.isNotEmpty) {
      return jsonEncode({
        _versionKey: 2,
        _itemsKey: shapeItems.map((e) => e.toJson()).toList(),
      });
    }
    final list = selectedFigureIds.toList()..sort();
    return jsonEncode(list);
  }

  /// Human-readable lines for receipts and order summary.
  static String buildSummary({
    required String mainStyleName,
    required StyleOrderSelection selection,
    required List<StyleFigureSummary> figures,
  }) {
    final buf = StringBuffer();
    final style = mainStyleName.trim();
    if (style.isNotEmpty) {
      buf.writeln(style);
    }

    if (selection.shapeItems.isNotEmpty) {
      _appendShapeItemSummaries(buf, selection.shapeItems, figures);
      return buf.toString().trim();
    }

    final figureById = {for (final f in figures) f.internalId: f};
    final sortedIds = selection.selectedFigureIds.toList()
      ..sort((a, b) {
        final fa = figureById[a]?.sortOrder ?? 0;
        final fb = figureById[b]?.sortOrder ?? 0;
        return fa.compareTo(fb);
      });
    for (final figureId in sortedIds) {
      final figure = figureById[figureId];
      if (figure == null) continue;
      final label = figure.name.trim();
      if (label.isNotEmpty) {
        buf.writeln(label);
      }
    }
    return buf.toString().trim();
  }

  static void _appendShapeItemSummaries(
    StringBuffer buf,
    List<OrderShapeSelectionItem> items,
    List<StyleFigureSummary> figures,
  ) {
    final figureById = {for (final f in figures) f.internalId: f};
    final sortedItems = List<OrderShapeSelectionItem>.from(items)
      ..sort((a, b) {
        final fa = figureById[a.shapeId]?.sortOrder ?? 0;
        final fb = figureById[b.shapeId]?.sortOrder ?? 0;
        return fa.compareTo(fb);
      });

    for (final item in sortedItems) {
      final shapeLine = item.shapeNameSnapshot.trim().isNotEmpty
          ? item.shapeNameSnapshot.trim()
          : resolveStyleFigureDisplayName(
              name: figureById[item.shapeId]?.name ?? '',
              imageRef: item.imageRefSnapshot.isNotEmpty
                  ? item.imageRefSnapshot
                  : (figureById[item.shapeId]?.imageRef ?? ''),
              sortOrder: figureById[item.shapeId]?.sortOrder ?? 0,
            );
      if (shapeLine.isNotEmpty) {
        buf.writeln(shapeLine);
      }

      for (final text in item.textOptions) {
        final label = text.labelSnapshot.trim();
        if (label.isNotEmpty) {
          buf.writeln('  · $label');
        }
      }

      for (final size in item.sizeOptions) {
        final label = size.labelSnapshot.trim();
        if (label.isNotEmpty) {
          buf.writeln('  · $label');
        } else if (size.valueSnapshot > 0) {
          buf.writeln('  · ${size.valueSnapshot} ${size.unitSnapshot}');
        }
      }

      final note = item.noteSnapshot?.trim() ?? '';
      if (note.isNotEmpty) {
        buf.writeln('  · $note');
      }
    }
  }
}

/// Default unit label for inch-size snapshots.
String orderShapeSizeUnitLabel(int unitCode) {
  if (unitCode == MeasurementUnitCodes.inch) return 'inch';
  if (unitCode == MeasurementUnitCodes.cm) return 'cm';
  return 'inch';
}
