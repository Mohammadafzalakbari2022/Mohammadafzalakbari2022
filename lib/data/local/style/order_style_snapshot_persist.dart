import 'package:isar/isar.dart';

import '../entities/order_style_snapshot_entity.dart';
import '../entities/order_style_snapshot_figure_entity.dart';
import '../entities/style_figure_entity.dart';
import '../order_style_snapshot_figure_input.dart';
import '../order_style_snapshot_view.dart';
import '../style_figure_summary.dart';
import 'order_style_snapshot_builder.dart';
import 'style_order_selection.dart';

/// Prepared style snapshot rows before writing to Isar or memory storage.
class OrderStyleSnapshotPersistData {
  const OrderStyleSnapshotPersistData({
    required this.hasContent,
    required this.styleNameSnapshot,
    this.styleNameInternalIdSnapshot,
    this.figureInputs = const [],
  });

  const OrderStyleSnapshotPersistData.empty()
      : hasContent = false,
        styleNameSnapshot = '',
        styleNameInternalIdSnapshot = null,
        figureInputs = const [];

  final bool hasContent;
  final String styleNameSnapshot;
  final String? styleNameInternalIdSnapshot;
  final List<OrderStyleSnapshotFigureInput> figureInputs;
}

/// Parses [styleSelectionJson] and builds figure snapshot inputs (v1/v2 safe).
OrderStyleSnapshotPersistData prepareOrderStyleSnapshotPersistData({
  required String styleName,
  String? styleNameInternalId,
  required String styleSelectionJson,
  List<StyleFigureSummary> allFigures = const [],
}) {
  final selection = StyleOrderSelection.fromJsonString(styleSelectionJson);
  final trimmedName = styleName.trim();
  final hasContent = trimmedName.isNotEmpty || !selection.isEmpty;
  if (!hasContent) {
    return const OrderStyleSnapshotPersistData.empty();
  }

  final figureInputs = buildOrderStyleSnapshotFigureInputs(
    selection: selection,
    allFigures: allFigures,
  );

  return OrderStyleSnapshotPersistData(
    hasContent: true,
    styleNameSnapshot: trimmedName,
    styleNameInternalIdSnapshot: styleNameInternalId,
    figureInputs: figureInputs,
  );
}

/// Loads live catalog figures for v1 resolution and sort order (inside txn OK).
Future<List<StyleFigureSummary>> loadStyleFiguresForShop(
  Isar isar,
  String shopId,
) async {
  final rows = await isar.styleFigureEntitys
      .filter()
      .shopIdEqualTo(shopId)
      .and()
      .deletedAtIsNull()
      .findAll();
  final list = rows
      .map(
        (e) => StyleFigureSummary(
          internalId: e.internalId,
          shopId: e.shopId,
          partInternalId: e.partInternalId,
          name: e.name,
          imageRef: e.imageRef,
          sortOrder: e.sortOrder,
          isActive: e.isActive,
        ),
      )
      .toList()
    ..sort((a, b) => a.sortOrder.compareTo(b.sortOrder));
  return list;
}

Future<void> deleteOrderStyleSnapshotsForOrder(
  Isar isar,
  String orderInternalId,
) async {
  final headers = await isar.orderStyleSnapshotEntitys
      .filter()
      .orderInternalIdEqualTo(orderInternalId)
      .findAll();
  for (final h in headers) {
    await isar.orderStyleSnapshotFigureEntitys
        .filter()
        .snapshotInternalIdEqualTo(h.internalId)
        .deleteAll();
  }
  await isar.orderStyleSnapshotEntitys
      .filter()
      .orderInternalIdEqualTo(orderInternalId)
      .deleteAll();
}

/// Deletes existing rows then inserts a fresh header + figure rows for the order.
Future<void> persistOrderStyleSnapshotInTxn({
  required Isar isar,
  required String shopId,
  required String orderInternalId,
  required String styleName,
  String? styleNameInternalId,
  required String styleSelectionJson,
  required List<StyleFigureSummary> allFigures,
  required String Function() newSnapshotInternalId,
}) async {
  await deleteOrderStyleSnapshotsForOrder(isar, orderInternalId);

  final data = prepareOrderStyleSnapshotPersistData(
    styleName: styleName,
    styleNameInternalId: styleNameInternalId,
    styleSelectionJson: styleSelectionJson,
    allFigures: allFigures,
  );
  if (!data.hasContent) return;

  final snapId = newSnapshotInternalId();
  final created = DateTime.now();
  final header = OrderStyleSnapshotEntity()
    ..internalId = snapId
    ..orderInternalId = orderInternalId
    ..shopId = shopId
    ..styleNameSnapshot = data.styleNameSnapshot
    ..styleNameInternalIdSnapshot = data.styleNameInternalIdSnapshot
    ..createdAt = created;
  await isar.orderStyleSnapshotEntitys.putByInternalId(header);

  if (data.figureInputs.isEmpty) return;

  final rows = <OrderStyleSnapshotFigureEntity>[];
  for (final input in data.figureInputs) {
    rows.add(
      OrderStyleSnapshotFigureEntity()
        ..snapshotInternalId = snapId
        ..shopId = shopId
        ..styleFigureInternalId = input.styleFigureInternalId
        ..figureNameSnapshot = input.figureNameSnapshot
        ..imageRefSnapshot = input.imageRefSnapshot
        ..presetInternalIdSnapshot = input.presetInternalIdSnapshot
        ..presetNameSnapshot = input.presetNameSnapshot
        ..textOptionsSnapshotJson = input.textOptionsSnapshotJson
        ..sizeOptionsSnapshotJson = input.sizeOptionsSnapshotJson
        ..sortOrder = input.sortOrder,
    );
  }
  await isar.orderStyleSnapshotFigureEntitys.putAll(rows);
}

OrderStyleSnapshotView? buildOrderStyleSnapshotView({
  required String orderInternalId,
  required String styleName,
  String? styleNameInternalId,
  required String styleSelectionJson,
  required String snapshotInternalId,
  List<StyleFigureSummary> allFigures = const [],
  DateTime? createdAt,
}) {
  final data = prepareOrderStyleSnapshotPersistData(
    styleName: styleName,
    styleNameInternalId: styleNameInternalId,
    styleSelectionJson: styleSelectionJson,
    allFigures: allFigures,
  );
  if (!data.hasContent) return null;

  final figures = data.figureInputs
      .map(
        (input) => OrderStyleSnapshotFigureView(
          styleFigureInternalId: input.styleFigureInternalId,
          figureNameSnapshot: input.figureNameSnapshot,
          imageRefSnapshot: input.imageRefSnapshot,
          sortOrder: input.sortOrder,
          presetInternalIdSnapshot: input.presetInternalIdSnapshot,
          presetNameSnapshot: input.presetNameSnapshot,
          textOptions: decodeOrderShapeOptionSnapshots(
            input.textOptionsSnapshotJson,
          )
              .map(
                (opt) => OrderShapeOptionSnapshotView(
                  id: opt.id,
                  labelSnapshot: opt.labelSnapshot,
                ),
              )
              .toList(growable: false),
          sizeOptions: decodeOrderShapeSizeSnapshots(
            input.sizeOptionsSnapshotJson,
          )
              .map(
                (opt) => OrderShapeSizeSnapshotView(
                  id: opt.id,
                  valueSnapshot: opt.valueSnapshot,
                  labelSnapshot: opt.labelSnapshot,
                  unitSnapshot: opt.unitSnapshot,
                ),
              )
              .toList(growable: false),
        ),
      )
      .toList(growable: false);

  return OrderStyleSnapshotView(
    orderInternalId: orderInternalId,
    snapshotInternalId: snapshotInternalId,
    styleNameSnapshot: data.styleNameSnapshot,
    styleNameInternalIdSnapshot: data.styleNameInternalIdSnapshot,
    createdAt: createdAt ?? DateTime.now(),
    figures: figures,
  );
}
