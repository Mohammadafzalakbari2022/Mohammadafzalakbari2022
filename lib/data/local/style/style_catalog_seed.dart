import 'package:isar/isar.dart';

import '../entities/style_figure_entity.dart';
import '../entities/style_name_entity.dart';
import '../entities/style_part_entity.dart';
import '../seed_data.dart';
import 'style_figure_image_ref.dart';

/// First-run defaults for style catalog (names, parts, bundled figures).
Future<void> seedStyleCatalogIfEmpty(Isar isar, String shopId) async {
  if (await isar.styleNameEntitys.filter().shopIdEqualTo(shopId).count() > 0) {
    return;
  }
  final now = DateTime.now();
  final names = <(String id, String label, int order)>[
    (DevSeedIds.styleNameQasimi, 'Qasimi', 10),
    (DevSeedIds.styleNameKandahari, 'Kandahari', 20),
    (DevSeedIds.styleNameArabi, 'Arabi', 30),
    (DevSeedIds.styleNameClassic, 'Classic', 40),
    (DevSeedIds.styleNameModern, 'Modern', 50),
  ];
  final parts = <(String id, String label, int order)>[
    (DevSeedIds.stylePartSleeve, 'Sleeve', 10),
    (DevSeedIds.stylePartCollar, 'Collar', 20),
    (DevSeedIds.stylePartPocket, 'Pocket', 30),
    (DevSeedIds.stylePartCuff, 'Cuff', 40),
    (DevSeedIds.stylePartNeck, 'Neck', 50),
    (DevSeedIds.stylePartFront, 'Front', 60),
    (DevSeedIds.stylePartBottom, 'Bottom', 70),
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

  final figureEntities = <StyleFigureEntity>[];
  for (var i = 0; i < 15; i++) {
    figureEntities.add(
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

  await isar.writeTxn(() async {
    await isar.styleNameEntitys.putAll(nameEntities);
    await isar.stylePartEntitys.putAll(partEntities);
    await isar.styleFigureEntitys.putAll(figureEntities);
  });
}
