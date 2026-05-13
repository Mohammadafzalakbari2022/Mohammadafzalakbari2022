import 'package:isar/isar.dart';

part 'order_entity.g.dart';

@collection
class OrderEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String customerInternalId;

  @Index()
  late String displayOrderNo;

  /// [OrderLocalStatus.code]
  @Index()
  late int statusIndex;

  @Index()
  late DateTime deliveryDate;

  @Index()
  late DateTime updatedAt;

  /// Total price for the order (MVP local-only). Used for remaining balance chips (plan-12).
  /// Represented as minor units (e.g. AFN) to avoid floating point errors.
  @Index()
  late int totalAmountMinor;

  /// Text snapshot at creation; not edited after save (plan-12).
  String measurementsSnapshot = '';

  /// Style / design notes at creation (plan-12).
  String styleNotes = '';

  /// Staff-only notes; editable after the order is otherwise locked (plan-12).
  String internalNotes = '';

  /// Optional link to the profile measurements were copied from (plan-02).
  String? sourceMeasurementProfileId;

  /// Denormalized label at order creation for display when profile is later edited.
  String sourceMeasurementProfileLabel = '';

  DateTime? deletedAt;
}
