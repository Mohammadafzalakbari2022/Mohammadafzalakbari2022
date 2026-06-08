import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/entities/garment_type.dart';
import 'package:pride_v3/data/local/memory_style_catalog_repository.dart';
import 'package:pride_v3/data/local/seed_data.dart';
import 'package:pride_v3/data/local/style/style_catalog_bundled_figures.dart';
import 'package:pride_v3/data/local/style/style_catalog_garment_helpers.dart';
import 'package:pride_v3/data/local/style/style_catalog_waistcoat_bundled.dart';
import 'package:pride_v3/data/local/style/style_figure_image_ref.dart';

void main() {
  const shopId = kDevShopId;

  group('MemoryStyleCatalogRepository garment filtering', () {
    late MemoryStyleCatalogRepository repo;

    setUp(() {
      repo = MemoryStyleCatalogRepository();
    });

    test('seed assigns Perahan/Tunban to bundled perahan shapes', () async {
      await repo.seedIfEmpty(shopId);

      final names = await repo.watchStyleNames(
        shopId,
        garmentTypeIndex: GarmentType.perahanTunban.code,
      ).first;
      expect(names, isNotEmpty);
      expect(names.every((n) => n.garmentTypeIndex == 0), isTrue);

      final figures = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.perahanTunban.code,
      ).first;
      expect(figures.length, bundledStyleFigureTemplates.length);
      expect(figures.every((f) => f.garmentTypeIndex == 0), isTrue);
    });

    test('seed imports waistcoat sections and figures', () async {
      await repo.seedIfEmpty(shopId);

      final parts = await repo.watchStyleParts(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      expect(parts.length, bundledWaistcoatPartTemplates.length);

      final figures = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      expect(figures.length, bundledWaistcoatFigureTemplates.length);
      expect(figures.every((f) => f.garmentTypeIndex == 1), isTrue);
    });

    test('Perahan picker does not include waistcoat shapes', () async {
      await repo.seedIfEmpty(shopId);

      final perahan = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.perahanTunban.code,
      ).first;
      final waistcoatIds =
          bundledWaistcoatFigureTemplates.map((t) => t.internalId).toSet();

      expect(
        perahan.any((f) => waistcoatIds.contains(f.internalId)),
        isFalse,
      );
      expect(
        perahan.any(
          (f) => StyleFigureImageRef.isWaistcoatBundledAssetRef(f.imageRef),
        ),
        isFalse,
      );
    });

    test('waistcoat picker does not include Perahan shapes', () async {
      await repo.seedIfEmpty(shopId);

      final waistcoat = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      final perahanIds =
          bundledStyleFigureTemplates.map((t) => t.internalId).toSet();

      expect(
        waistcoat.any((f) => perahanIds.contains(f.internalId)),
        isFalse,
      );
    });

    test('create uses selected garment type', () async {
      await repo.seedIfEmpty(shopId);

      final wcNameId = await repo.createStyleName(
        shopId: shopId,
        name: 'Custom WC',
        garmentTypeIndex: GarmentType.waistcoat.code,
      );
      final wcNames = await repo.watchStyleNames(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      expect(wcNames.any((n) => n.internalId == wcNameId), isTrue);

      final perahanNames = await repo.watchStyleNames(
        shopId,
        garmentTypeIndex: GarmentType.perahanTunban.code,
      ).first;
      expect(perahanNames.any((n) => n.internalId == wcNameId), isFalse);
    });

    test('waistcoat folder sections are preserved in grouped order', () async {
      await repo.seedIfEmpty(shopId);

      final parts = await repo.watchStyleParts(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      final figures = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;

      final sections = groupStyleFiguresByPart(figures: figures, parts: parts);
      expect(sections.length, bundledWaistcoatPartTemplates.length);
      expect(
        sections.first.part.internalId,
        DevSeedIds.waistcoatPart01,
      );
      expect(sections.last.part.internalId, DevSeedIds.waistcoatPart08);
    });

    test('running seed twice does not duplicate waistcoat shapes', () async {
      await repo.seedIfEmpty(shopId);
      await repo.seedIfEmpty(shopId);

      final figures = await repo.watchAllFigures(
        shopId,
        garmentTypeIndex: GarmentType.waistcoat.code,
      ).first;
      expect(figures.length, bundledWaistcoatFigureTemplates.length);
    });
  });
}
