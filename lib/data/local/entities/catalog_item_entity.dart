import 'package:isar/isar.dart';

part 'catalog_item_entity.g.dart';

@collection
class CatalogItemEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  late String designName;

  /// Watermark label (shop name of creator). For local items, this is this shop name.
  late String designerShopName;

  /// Local paths (mobile/desktop). Web does not create images (plan-14).
  String? imagePath;
  String? thumbnailPath;

  String? notes;

  @Index()
  late DateTime createdAt;

  @Index()
  late DateTime updatedAt;

  @Index()
  late bool isSharedPublic;

  DateTime? deletedAt;
}

