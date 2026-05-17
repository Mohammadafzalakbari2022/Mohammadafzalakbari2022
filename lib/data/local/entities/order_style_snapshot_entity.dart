import 'package:isar/isar.dart';

part 'order_style_snapshot_entity.g.dart';

/// Header: frozen style on an order (plan-02: order style snapshot).
@collection
class OrderStyleSnapshotEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index(unique: true, replace: true)
  late String orderInternalId;

  @Index()
  late String shopId;

  /// Main cloth style label at order time.
  late String styleNameSnapshot;

  /// When [styleNameSnapshot] came from [StyleNameEntity].
  String? styleNameInternalIdSnapshot;

  late DateTime createdAt;
}
