import 'package:isar/isar.dart';

import '../entities/style_figure_entity.dart';
import '../entities/style_name_entity.dart';
import '../entities/style_part_entity.dart';
import '../seed_data.dart';
import 'style_catalog_bundled_figures.dart';

/// First-run defaults and upgrade repair for style catalog (names, parts, bundled figures).
Future<void> seedStyleCatalogIfEmpty(Isar isar, String shopId) async {
  final now = DateTime.now();
  await _seedStyleNamesIfMissing(isar, shopId, now);
  await _seedStylePartsIfMissing(isar, shopId, now);
  await _ensureBundledStyleFigures(isar, shopId, now);
}

Future<void> _seedStyleNamesIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final hasNames = await isar.styleNameEntitys
      .filter()
      .shopIdEqualTo(shopId)
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

Future<void> _seedStylePartsIfMissing(
  Isar isar,
  String shopId,
  DateTime now,
) async {
  final hasParts = await isar.stylePartEntitys
      .filter()
      .shopIdEqualTo(shopId)
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
    if (!needsRepair) continue;

    existing
      ..shopId = shopId
      ..partInternalId = template.partInternalId
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
