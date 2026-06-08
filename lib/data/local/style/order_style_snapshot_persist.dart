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
          noteSnapshot: input.noteSnapshot,
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
