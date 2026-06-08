import 'package:isar/isar.dart';

part 'style_figure_entity.g.dart';

@collection
class StyleFigureEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String partInternalId;

  /// [GarmentType] code (`0` = Perahan/Tunban, `1` = Waistcoat).
  @Index()
  int garmentTypeIndex = 0;

  late String name;

  /// [StyleFigureImageRef.assetPrefix] or [StyleFigureImageRef.filePrefix].
  late String imageRef;

  @Index()
  late int sortOrder;

  @Index()
  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
