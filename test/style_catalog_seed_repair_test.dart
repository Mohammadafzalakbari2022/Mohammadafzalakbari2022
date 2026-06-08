import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/memory_style_catalog_repository.dart';
import 'package:pride_v3/data/local/seed_data.dart';
import 'package:pride_v3/data/local/style/style_catalog_bundled_figures.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';

void main() {
  const shopId = kDevShopId;

  group('bundledStyleFigureNeedsRepair', () {
    final template = bundledStyleFigureTemplates.first;

    test('returns false for healthy bundled row', () {
      expect(
        bundledStyleFigureNeedsRepair(
          shopId: shopId,
          template: template,
          existingShopId: shopId,
          existingImageRef: template.imageRef,
          existingPartInternalId: template.partInternalId,
          existingSortOrder: template.sortOrder,
          isDeleted: false,
        ),
        isFalse,
      );
    });

    test('returns true when imageRef is empty or wrong', () {
      expect(
        bundledStyleFigureNeedsRepair(
          shopId: shopId,
          template: template,
          existingShopId: shopId,
          existingImageRef: '',
          existingPartInternalId: template.partInternalId,
          existingSortOrder: template.sortOrder,
          isDeleted: false,
        ),
        isTrue,
      );
      expect(
        bundledStyleFigureNeedsRepair(
          shopId: shopId,
          template: template,
          existingShopId: shopId,
          existingImageRef: StyleFigureImageRef.bundledAssetKey(99),
          existingPartInternalId: template.partInternalId,
          existingSortOrder: template.sortOrder,
          isDeleted: false,
        ),
        isTrue,
      );
    });
  });

  group('MemoryStyleCatalogRepository bundled repair', () {
    late MemoryStyleCatalogRepository repo;

    setUp(() {
      repo = MemoryStyleCatalogRepository();
    });

    test('catalog with style names but no figures receives bundled shapes',
        () async {
      await repo.createStyleName(shopId: shopId, name: 'Qasimi');

      await repo.seedIfEmpty(shopId);

      final figures = await repo
          .watchAllFigures(
            shopId,
            garmentTypeIndex: 0,
          )
          .first;
      expect(figures.length, bundledStyleFigureTemplates.length);
    });

    test('broken bundled metadata is repaired without overwriting names',
        () async {
      await repo.seedIfEmpty(shopId);
      await repo.updateStyleFigure(
        internalId: DevSeedIds.styleFigure1,
        name: 'Custom sleeve name',
      );
      await repo.mergeRemoteStyleFigure(
        shopId: shopId,
        internalId: DevSeedIds.styleFigure1,
        operation: 'upsert',
        data: {
          'name': 'Custom sleeve name',
          'part_internal_id': DevSeedIds.stylePartSleeve,
          'image_ref': 'legacy:shape_1',
        },
      );
      await repo.updateStyleFigure(
        internalId: DevSeedIds.styleFigure2,
        sortOrder: 0,
      );
      await repo.updateStyleFigure(
        internalId: DevSeedIds.styleFigure3,
        isActive: false,
      );
      await repo.mergeRemoteStyleFigure(
        shopId: shopId,
        internalId: DevSeedIds.styleFigure3,
        operation: 'upsert',
        data: {
          'name': '',
          'part_internal_id': DevSeedIds.stylePartSleeve,
          'image_ref': 'legacy:shape_3',
        },
      );

      await repo.seedIfEmpty(shopId);

      final figures = await repo
          .watchAllFigures(
            shopId,
            garmentTypeIndex: 0,
          )
          .first;
      final first = figures.firstWhere(
        (f) => f.internalId == DevSeedIds.styleFigure1,
      );
      expect(first.name, 'Custom sleeve name');
      expect(first.imageRef, StyleFigureImageRef.bundledAssetKey(1));

      final repairedSort = figures.firstWhere(
        (f) => f.internalId == DevSeedIds.styleFigure2,
      );
      expect(repairedSort.sortOrder, 20);

      final deactivated = figures.firstWhere(
        (f) => f.internalId == DevSeedIds.styleFigure3,
      );
      expect(deactivated.isActive, isFalse);
      expect(
        deactivated.imageRef,
        StyleFigureImageRef.bundledAssetKey(3),
      );
    });

    test('running seedIfEmpty twice creates no duplicate bundled shapes',
        () async {
      await repo.seedIfEmpty(shopId);
      await repo.softDeleteStyleFigure(DevSeedIds.styleFigure5);
      await repo.seedIfEmpty(shopId);
      await repo.seedIfEmpty(shopId);

      final figures = await repo
          .watchAllFigures(
            shopId,
            garmentTypeIndex: 0,
          )
          .first;
      expect(figures.length, bundledStyleFigureTemplates.length);
      expect(
        figures.map((f) => f.internalId).toSet().length,
        bundledStyleFigureTemplates.length,
      );
    });

    test('missing bundled figures are inserted without touching custom shapes',
        () async {
      await repo.createStyleName(shopId: shopId, name: 'Qasimi');
      final customId = await repo.createStyleFigure(
        shopId: shopId,
        partInternalId: DevSeedIds.stylePartSleeve,
        name: 'My custom shape',
        imageRef: '${StyleFigureImageRef.filePrefix}custom.png',
      );

      await repo.seedIfEmpty(shopId);

      final figures = await repo
          .watchAllFigures(
            shopId,
            garmentTypeIndex: 0,
          )
          .first;
      expect(figures.length, bundledStyleFigureTemplates.length + 1);
      final custom = figures.firstWhere((f) => f.internalId == customId);
      expect(custom.name, 'My custom shape');
      expect(custom.imageRef, '${StyleFigureImageRef.filePrefix}custom.png');
    });
  });
}
