import 'package:isar/isar.dart';

import '../entities/order_style_snapshot_entity.dart';
import '../entities/order_style_snapshot_figure_entity.dart';
import '../entities/style_figure_entity.dart';
import '../order_style_snapshot_figure_input.dart';
import '../style_figure_summary.dart';
import 'order_style_snapshot_persist.dart';

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
    if (h.orderItemInternalId.trim().isNotEmpty) continue;
    await isar.orderStyleSnapshotFigureEntitys
        .filter()
        .snapshotInternalIdEqualTo(h.internalId)
        .deleteAll();
    await isar.orderStyleSnapshotEntitys.delete(h.id);
  }
}

Future<void> deleteOrderStyleSnapshotsForOrderItem(
  Isar isar,
  String orderItemInternalId,
) async {
  final headers = await isar.orderStyleSnapshotEntitys
      .filter()
      .orderItemInternalIdEqualTo(orderItemInternalId)
      .findAll();
  for (final h in headers) {
    await isar.orderStyleSnapshotFigureEntitys
        .filter()
        .snapshotInternalIdEqualTo(h.internalId)
        .deleteAll();
  }
  await isar.orderStyleSnapshotEntitys
      .filter()
      .orderItemInternalIdEqualTo(orderItemInternalId)
      .deleteAll();
}

/// Deletes existing rows then inserts a fresh header + figure rows for the order.
Future<void> persistOrderStyleSnapshotInTxn({
  required Isar isar,
  required String shopId,
  required String orderInternalId,
  String? orderItemInternalId,
  required String styleName,
  String? styleNameInternalId,
  required String styleSelectionJson,
  required List<StyleFigureSummary> allFigures,
  required String Function() newSnapshotInternalId,
}) async {
  final itemId = orderItemInternalId?.trim() ?? '';
  if (itemId.isNotEmpty) {
    await deleteOrderStyleSnapshotsForOrderItem(isar, itemId);
  } else {
    await deleteOrderStyleSnapshotsForOrder(isar, orderInternalId);
  }

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
    ..orderItemInternalId = itemId
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
        ..textOptionsSnapshotJson = input.textOptionsSnapshotJson
        ..sizeOptionsSnapshotJson = input.sizeOptionsSnapshotJson
        ..noteSnapshot = input.noteSnapshot
        ..sortOrder = input.sortOrder,
    );
  }
  await isar.orderStyleSnapshotFigureEntitys.putAll(rows);
}
