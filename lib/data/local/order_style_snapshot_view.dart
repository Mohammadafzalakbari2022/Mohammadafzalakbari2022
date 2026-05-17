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
  });

  final String styleFigureInternalId;
  final String figureNameSnapshot;
  final String imageRefSnapshot;
  final int sortOrder;
}
