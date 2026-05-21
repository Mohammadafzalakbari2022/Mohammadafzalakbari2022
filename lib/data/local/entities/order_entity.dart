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

  /// Frozen customer name for this order (display + history).
  String customerNameSnapshot = '';

  /// Frozen customer phone for this order.
  String customerPhoneSnapshot = '';

  /// JSON array of [OrderCustomerHistoryEntry] when name/phone changes after save.
  String customerChangeHistoryJson = '';

  @Index()
  late String displayOrderNo;

  /// [OrderLocalStatus.code]
  @Index()
  late int statusIndex;

  @Index()
  late DateTime deliveryDate;

  /// First creation time on this device (nullable for legacy rows before this field existed).
  DateTime? createdAt;

  @Index()
  late DateTime updatedAt;

  /// Total price for the order (MVP local-only). Used for remaining balance chips (plan-12).
  /// Represented as minor units (e.g. AFN) to avoid floating point errors.
  @Index()
  late int totalAmountMinor;

  /// Text snapshot at creation; not edited after save (plan-12).
  String measurementsSnapshot = '';

  /// Staff-only notes; editable after the order is otherwise locked (plan-12).
  String internalNotes = '';

  /// Optional link to the profile measurements were copied from (plan-02).
  String? sourceMeasurementProfileId;

  /// Denormalized label at order creation for display when profile is later edited.
  String sourceMeasurementProfileLabel = '';

  /// Main cloth style label at order creation (catalog name or custom text).
  String styleName = '';

  /// Set when [styleName] came from [StyleNameEntity].
  String? styleNameInternalId;

  /// JSON list of figure internal ids (legacy: part id → figure id map).
  String styleSelectionJson = '';

  /// Human-readable style lines for lists, receipts, and sync.
  String styleSummary = '';

  /// Optional photo-catalog complete design (frozen at order creation).
  String? catalogItemInternalId;

  String catalogDesignNameSnapshot = '';

  String catalogDesignerShopNameSnapshot = '';

  String? catalogImagePathSnapshot;

  String? catalogThumbnailPathSnapshot;

  /// Customer-supplied fabric frozen at order creation.
  String fabricNameSnapshot = '';

  String fabricColorSnapshot = '';

  /// Six-digit ID (e.g. 042817).
  String fabricIdSnapshot = '';

  String? fabricNamePresetInternalId;

  String? fabricColorPresetInternalId;

  DateTime? deletedAt;
}
