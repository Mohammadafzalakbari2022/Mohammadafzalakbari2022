import 'package:isar/isar.dart';

part 'customer_entity.g.dart';

@collection
class CustomerEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String name;

  /// Shop-scoped stable display number (8-digit storage, e.g. 00000001).
  late String displayCustomerNo;

  String? phone;

  String? address;

  String? notes;

  /// Last catalog design chosen on a saved order (denormalized for profile).
  String lastCatalogDesignName = '';

  String? lastCatalogThumbnailPath;

  String? lastCatalogItemInternalId;

  String lastCatalogDesignerShopName = '';

  @Index()
  late DateTime createdAt;

  DateTime? deletedAt;
}
