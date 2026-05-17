/// One selected figure to persist on order creation.
class OrderStyleSnapshotFigureInput {
  const OrderStyleSnapshotFigureInput({
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
