import 'package:isar/isar.dart';

part 'style_figure_text_option_entity.g.dart';

@collection
class StyleFigureTextOptionEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String internalId;

  @Index()
  late String shopId;

  @Index()
  late String styleFigureInternalId;

  late String label;

  @Index()
  late int sortOrder;

  @Index()
  late bool isActive;

  late DateTime createdAt;

  late DateTime updatedAt;

  DateTime? deletedAt;
}
