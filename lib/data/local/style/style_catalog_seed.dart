import 'package:isar/isar.dart';

import '../entities/style_figure_entity.dart';
import '../entities/style_name_entity.dart';
import '../entities/style_part_entity.dart';
import '../seed_data.dart';
import 'style_figure_image_ref.dart';

/// First-run defaults for style catalog (names, parts, bundled figures).
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
  final partIds = [
    DevSeedIds.stylePartSleeve,
    DevSeedIds.stylePartSleeve,
    DevSeedIds.stylePartSleeve,
    DevSeedIds.stylePartCollar,
    DevSeedIds.stylePartCollar,
    DevSeedIds.stylePartPocket,
    DevSeedIds.stylePartPocket,
    DevSeedIds.stylePartCuff,
    DevSeedIds.stylePartCuff,
    DevSeedIds.stylePartNeck,
    DevSeedIds.stylePartNeck,
    DevSeedIds.stylePartFront,
    DevSeedIds.stylePartFront,
    DevSeedIds.stylePartBottom,
    DevSeedIds.stylePartBottom,
  ];

  final figureIds = [
    DevSeedIds.styleFigure1,
    DevSeedIds.styleFigure2,
    DevSeedIds.styleFigure3,
    DevSeedIds.styleFigure4,
    DevSeedIds.styleFigure5,
    DevSeedIds.styleFigure6,
    DevSeedIds.styleFigure7,
    DevSeedIds.styleFigure8,
    DevSeedIds.styleFigure9,
    DevSeedIds.styleFigure10,
    DevSeedIds.styleFigure11,
    DevSeedIds.styleFigure12,
    DevSeedIds.styleFigure13,
    DevSeedIds.styleFigure14,
    DevSeedIds.styleFigure15,
  ];

  final toWrite = <StyleFigureEntity>[];
  for (var i = 0; i < 15; i++) {
    final existing = await isar.styleFigureEntitys.getByInternalId(figureIds[i]);
    if (existing != null &&
        existing.shopId == shopId &&
        existing.deletedAt == null) {
      continue;
    }

    if (existing != null) {
      final preservedName = existing.name;
      existing
        ..shopId = shopId
        ..partInternalId = partIds[i]
        ..imageRef = StyleFigureImageRef.bundledAssetKey(i + 1)
        ..sortOrder = (i + 1) * 10
        ..isActive = true
        ..updatedAt = now
        ..deletedAt = null
        ..name = preservedName;
      toWrite.add(existing);
      continue;
    }

    toWrite.add(
      StyleFigureEntity()
        ..internalId = figureIds[i]
        ..shopId = shopId
        ..partInternalId = partIds[i]
        ..name = ''
        ..imageRef = StyleFigureImageRef.bundledAssetKey(i + 1)
        ..sortOrder = (i + 1) * 10
        ..isActive = true
        ..createdAt = now
        ..updatedAt = now,
    );
  }

  if (toWrite.isEmpty) return;

  await isar.writeTxn(() async {
    await isar.styleFigureEntitys.putAll(toWrite);
  });
}
