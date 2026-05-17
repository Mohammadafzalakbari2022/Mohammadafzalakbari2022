import 'package:isar/isar.dart';

part 'order_style_snapshot_figure_entity.g.dart';

/// Selected style figure frozen on an order (name + image ref at order time).
@collection
class OrderStyleSnapshotFigureEntity {
  Id id = Isar.autoIncrement;

  @Index()
  late String snapshotInternalId;

  @Index()
  late String shopId;

  @Index()
  late String styleFigureInternalId;

  late String figureNameSnapshot;

  /// Asset path or local file ref at order time (see [StyleFigureSummary.imageRef]).
  late String imageRefSnapshot;

  @Index()
  late int sortOrder;
}
