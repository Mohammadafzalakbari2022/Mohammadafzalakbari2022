import 'package:isar/isar.dart';

import '../entities/garment_type.dart';
import '../entities/style_figure_entity.dart';
import 'style_figure_image_ref.dart';
import '../entities/style_name_entity.dart';
import '../entities/style_part_entity.dart';

/// Backfill [garmentTypeIndex] on legacy style rows (defaults to Perahan/Tunban).
abstract final class IsarStyleCatalogMigrationGarment {
  static Future<void> runIfNeeded({required Isar isar}) async {
    await isar.writeTxn(() async {
      await _backfillNames(isar);
      await _backfillParts(isar);
      await _backfillFigures(isar);
    });
  }

  static Future<void> _backfillNames(Isar isar) async {
    final rows = await isar.styleNameEntitys.where().findAll();
    final toWrite = <StyleNameEntity>[];
    for (final row in rows) {
      if (row.garmentTypeIndex == GarmentType.waistcoat.code) continue;
      if (row.garmentTypeIndex != GarmentType.perahanTunban.code) {
        row.garmentTypeIndex = GarmentType.perahanTunban.code;
        toWrite.add(row);
      }
    }
    if (toWrite.isNotEmpty) await isar.styleNameEntitys.putAll(toWrite);
  }

  static Future<void> _backfillParts(Isar isar) async {
    final rows = await isar.stylePartEntitys.where().findAll();
    final toWrite = <StylePartEntity>[];
    for (final row in rows) {
      if (row.garmentTypeIndex == GarmentType.waistcoat.code) continue;
      if (row.garmentTypeIndex != GarmentType.perahanTunban.code) {
        row.garmentTypeIndex = GarmentType.perahanTunban.code;
        toWrite.add(row);
      }
    }
    if (toWrite.isNotEmpty) await isar.stylePartEntitys.putAll(toWrite);
  }

  static Future<void> _backfillFigures(Isar isar) async {
    final rows = await isar.styleFigureEntitys.where().findAll();
    final toWrite = <StyleFigureEntity>[];
    for (final row in rows) {
      if (row.garmentTypeIndex == GarmentType.waistcoat.code) continue;
      if (StyleFigureImageRef.isWaistcoatBundledAssetRef(row.imageRef)) {
        row.garmentTypeIndex = GarmentType.waistcoat.code;
        toWrite.add(row);
        continue;
      }
      if (row.garmentTypeIndex != GarmentType.perahanTunban.code) {
        row.garmentTypeIndex = GarmentType.perahanTunban.code;
        toWrite.add(row);
      }
    }
    if (toWrite.isNotEmpty) await isar.styleFigureEntitys.putAll(toWrite);
  }
}
