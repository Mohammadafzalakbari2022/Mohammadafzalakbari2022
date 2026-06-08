import 'package:isar/isar.dart';

import '../entities/garment_type.dart';
import '../entities/style_figure_entity.dart';
import '../entities/style_name_entity.dart';
import '../entities/style_part_entity.dart';
import '../seed_data.dart';
import 'isar_style_catalog_migration_garment.dart';
import 'style_catalog_bundled_figures.dart';
import 'style_catalog_waistcoat_bundled.dart';

/// First-run defaults and upgrade repair for style catalog (names, parts, bundled figures).
Future<void> seedStyleCatalogIfEmpty(Isar isar, String shopId) async {
  await IsarStyleCatalogMigrationGarment.runIfNeeded(isar: isar);
  final now = DateTime.now();
  await _seedPerahanStyleNamesIfMissing(isar, shopId, now);
  await _seedPerahanStylePartsIfMissing(isar, shopId, now);
  await _ensureBundledStyleFigures(isar, shopId, now);
  await _seedWaistcoatStyleNameIfMissing(isar, shopId, now);
  await _seedWaistcoatStylePartsIfMissing(isar, shopId, now);
  await _ensureBundledWaistcoatStyleFigures(isar, shopId, now);
}

Future<void> _seedPerahanStyleNamesIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final hasNames = await isar.styleNameEntitys
      .filter()
      .shopIdEqualTo(shopId)
      .and()
      .garmentTypeIndexEqualTo(GarmentType.perahanTunban.code)
      .and()
      .deletedAtIsNull()
      .count();
  if (hasNames > 0) return;

  final names = <(String id, String label, int order)>[
    (DevSeedIds.styleNameQasimi, 'Qasimi', 10),
    (DevSeedIds.styleNameKandahari, 'Kandahari', 20),
    (DevSeedIds.styleNameArabi, 'Arabi', 30),
    (DevSeedIds.styleNameClassic, 'Classic', 40),
    (DevSeedIds.styleNameModern, 'Modern', 50),
  ];

  final nameEntities = names
      .map(
        (n) => StyleNameEntity()
          ..internalId = n.$1
          ..shopId = shopId
          ..garmentTypeIndex = GarmentType.perahanTunban.code
          ..name = n.$2
          ..sortOrder = n.$3
          ..isActive = true
          ..createdAt = now
          ..updatedAt = now,
      )
      .toList();

  await isar.writeTxn(() async {
    await isar.styleNameEntitys.putAll(nameEntities);
  });
}

Future<void> _seedPerahanStylePartsIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final hasParts = await isar.stylePartEntitys
      .filter()
      .shopIdEqualTo(shopId)
      .and()
      .garmentTypeIndexEqualTo(GarmentType.perahanTunban.code)
      .and()
      .deletedAtIsNull()
      .count();
  if (hasParts > 0) return;

  final parts = <(String id, String label, int order)>[
    (DevSeedIds.stylePartSleeve, 'Sleeve', 10),
    (DevSeedIds.stylePartCollar, 'Collar', 20),
    (DevSeedIds.stylePartPocket, 'Pocket', 30),
    (DevSeedIds.stylePartCuff, 'Cuff', 40),
    (DevSeedIds.stylePartNeck, 'Neck', 50),
    (DevSeedIds.stylePartFront, 'Front', 60),
    (DevSeedIds.stylePartBottom, 'Bottom', 70),
  ];

  final partEntities = parts
      .map(
        (p) => StylePartEntity()
          ..internalId = p.$1
          ..shopId = shopId
          ..garmentTypeIndex = GarmentType.perahanTunban.code
          ..name = p.$2
          ..sortOrder = p.$3
          ..isActive = true
          ..createdAt = now
          ..updatedAt = now,
      )
      .toList();

  await isar.writeTxn(() async {
    await isar.stylePartEntitys.putAll(partEntities);
  });
}

Future<void> _ensureBundledStyleFigures(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final figureIds =
      bundledStyleFigureTemplates.map((t) => t.internalId).toList();
  final existingRows =
      await isar.styleFigureEntitys.getAllByInternalId(figureIds);

  final toWrite = <StyleFigureEntity>[];
  for (var i = 0; i < bundledStyleFigureTemplates.length; i++) {
    final template = bundledStyleFigureTemplates[i];
    final existing = existingRows[i];

    if (existing == null) {
      toWrite.add(
        StyleFigureEntity()
          ..internalId = template.internalId
          ..shopId = shopId
          ..partInternalId = template.partInternalId
          ..garmentTypeIndex = GarmentType.perahanTunban.code
          ..name = ''
          ..imageRef = template.imageRef
          ..sortOrder = template.sortOrder
          ..isActive = true
          ..createdAt = now
          ..updatedAt = now,
      );
      continue;
    }

    final preservedName = existing.name;
    final preservedActive = existing.isActive;
    final needsRepair = bundledStyleFigureNeedsRepair(
      shopId: shopId,
      template: template,
      existingShopId: existing.shopId,
      existingImageRef: existing.imageRef,
      existingPartInternalId: existing.partInternalId,
      existingSortOrder: existing.sortOrder,
      isDeleted: existing.deletedAt != null,
    );
    if (!needsRepair && existing.garmentTypeIndex == GarmentType.perahanTunban.code) {
      continue;
    }

    existing
      ..shopId = shopId
      ..partInternalId = template.partInternalId
      ..garmentTypeIndex = GarmentType.perahanTunban.code
      ..imageRef = template.imageRef
      ..sortOrder = template.sortOrder
      ..name = preservedName
      ..isActive = preservedActive
      ..updatedAt = now
      ..deletedAt = null;
    if (existing.createdAt.millisecondsSinceEpoch <= 0) {
      existing.createdAt = now;
    }
    toWrite.add(existing);
  }

  if (toWrite.isEmpty) return;

  await isar.writeTxn(() async {
    await isar.styleFigureEntitys.putAll(toWrite);
  });
}

Future<void> _seedWaistcoatStyleNameIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final has = await isar.styleNameEntitys
      .filter()
      .shopIdEqualTo(shopId)
      .and()
      .garmentTypeIndexEqualTo(GarmentType.waistcoat.code)
      .and()
      .deletedAtIsNull()
      .count();
  if (has > 0) return;

  final e = StyleNameEntity()
    ..internalId = DevSeedIds.waistcoatStyleName
    ..shopId = shopId
    ..garmentTypeIndex = GarmentType.waistcoat.code
    ..name = 'Waistcoat'
    ..sortOrder = 10
    ..isActive = true
    ..createdAt = now
    ..updatedAt = now;

  await isar.writeTxn(() async {
    await isar.styleNameEntitys.put(e);
  });
}

Future<void> _seedWaistcoatStylePartsIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final partIds =
      bundledWaistcoatPartTemplates.map((t) => t.internalId).toList();
  final existing = await isar.stylePartEntitys.getAllByInternalId(partIds);
  final toWrite = <StylePartEntity>[];

  for (var i = 0; i < bundledWaistcoatPartTemplates.length; i++) {
    final template = bundledWaistcoatPartTemplates[i];
    final row = existing[i];
    if (row != null && row.deletedAt == null) continue;
    toWrite.add(
      StylePartEntity()
        ..internalId = template.internalId
        ..shopId = shopId
        ..garmentTypeIndex = GarmentType.waistcoat.code
        ..name = template.folderKey
        ..sortOrder = template.sortOrder
        ..isActive = true
        ..createdAt = now
        ..updatedAt = now,
    );
  }

  if (toWrite.isEmpty) return;
  await isar.writeTxn(() async {
    await isar.stylePartEntitys.putAll(toWrite);
  });
}

bool bundledWaistcoatFigureNeedsRepair({
  required String shopId,
  required BundledWaistcoatFigureTemplate template,
  required String existingShopId,
  required String existingImageRef,
  required String existingPartInternalId,
  required int existingSortOrder,
  required int existingGarmentTypeIndex,
  required bool isDeleted,
}) {
  if (isDeleted) return true;
  if (existingShopId != shopId) return true;
  if (existingGarmentTypeIndex != GarmentType.waistcoat.code) return true;
  if (existingImageRef.trim() != template.imageRef) return true;
  if (existingPartInternalId != template.partInternalId) return true;
  if (existingSortOrder != template.sortOrder) return true;
  return false;
}

Future<void> _ensureBundledWaistcoatStyleFigures(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final figureIds =
      bundledWaistcoatFigureTemplates.map((t) => t.internalId).toList();
  final existingRows =
      await isar.styleFigureEntitys.getAllByInternalId(figureIds);

  final toWrite = <StyleFigureEntity>[];
  for (var i = 0; i < bundledWaistcoatFigureTemplates.length; i++) {
    final template = bundledWaistcoatFigureTemplates[i];
    final existing = existingRows[i];

    if (existing == null) {
      toWrite.add(
        StyleFigureEntity()
          ..internalId = template.internalId
          ..shopId = shopId
          ..partInternalId = template.partInternalId
          ..garmentTypeIndex = GarmentType.waistcoat.code
          ..name = template.displayName
          ..imageRef = template.imageRef
          ..sortOrder = template.sortOrder
          ..isActive = true
          ..createdAt = now
          ..updatedAt = now,
      );
      continue;
    }

    final preservedName = existing.name.trim().isNotEmpty
        ? existing.name
        : template.displayName;
    final preservedActive = existing.isActive;
    final needsRepair = bundledWaistcoatFigureNeedsRepair(
      shopId: shopId,
      template: template,
      existingShopId: existing.shopId,
      existingImageRef: existing.imageRef,
      existingPartInternalId: existing.partInternalId,
      existingSortOrder: existing.sortOrder,
      existingGarmentTypeIndex: existing.garmentTypeIndex,
      isDeleted: existing.deletedAt != null,
    );
    if (!needsRepair) continue;

    existing
      ..shopId = shopId
      ..partInternalId = template.partInternalId
      ..garmentTypeIndex = GarmentType.waistcoat.code
      ..imageRef = template.imageRef
      ..sortOrder = template.sortOrder
      ..name = preservedName
      ..isActive = preservedActive
      ..updatedAt = now
      ..deletedAt = null;
    if (existing.createdAt.millisecondsSinceEpoch <= 0) {
      existing.createdAt = now;
    }
    toWrite.add(existing);
  }

  if (toWrite.isEmpty) return;

  await isar.writeTxn(() async {
    await isar.styleFigureEntitys.putAll(toWrite);
  });
}
