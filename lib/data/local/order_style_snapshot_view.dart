/// Hydrated order style snapshot for UI and receipts.
class OrderStyleSnapshotView {
  const OrderStyleSnapshotView({
    required this.orderInternalId,
    required this.snapshotInternalId,
    required this.styleNameSnapshot,
    this.styleNameInternalIdSnapshot,
    required this.createdAt,
    required this.figures,
  });

  final String orderInternalId;
  final String snapshotInternalId;
  final String styleNameSnapshot;
  final String? styleNameInternalIdSnapshot;
  final DateTime createdAt;
  final List<OrderStyleSnapshotFigureView> figures;
}

class OrderStyleSnapshotFigureView {
  const OrderStyleSnapshotFigureView({
    required this.styleFigureInternalId,
    required this.figureNameSnapshot,
    required this.imageRefSnapshot,
    required this.sortOrder,
    this.presetInternalIdSnapshot,
    this.presetNameSnapshot = '',
    this.textOptions = const [],
    this.sizeOptions = const [],
  });

  final String styleFigureInternalId;
  final String figureNameSnapshot;
  final String imageRefSnapshot;
  final int sortOrder;
  final String? presetInternalIdSnapshot;
  final String presetNameSnapshot;
  final List<OrderShapeOptionSnapshotView> textOptions;
  final List<OrderShapeSizeSnapshotView> sizeOptions;
}

class OrderShapeOptionSnapshotView {
  const OrderShapeOptionSnapshotView({
    required this.id,
    required this.labelSnapshot,
  });

  final String id;
  final String labelSnapshot;
}

class OrderShapeSizeSnapshotView {
  const OrderShapeSizeSnapshotView({
    required this.id,
    required this.valueSnapshot,
    required this.labelSnapshot,
    required this.unitSnapshot,
  });

  final String id;
  final double valueSnapshot;
  final String labelSnapshot;
  final String unitSnapshot;
}
