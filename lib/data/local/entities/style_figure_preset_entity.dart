import 'package:isar/isar.dart';

part 'style_figure_preset_entity.g.dart';

@collection
class StyleFigurePresetEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String styleFigureInternalId;

  late String name;

  /// JSON array of [StyleFigureTextOptionEntity.internalId] values.
  late String textOptionInternalIdsJson;

  /// JSON array of [StyleFigureSizeOptionEntity.internalId] values.
  late String sizeOptionInternalIdsJson;

  @Index()
  late int sortOrder;

  @Index()
  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
