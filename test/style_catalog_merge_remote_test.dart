import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/dev_shop_constants.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/data/local/memory_style_catalog_repository.dart';

void main() {
  group('MemoryStyleCatalogRepository mergeRemote', () {
    late MemoryStyleCatalogRepository repo;
    const shopId = kDevShopId;
    const figureId = 'remote-figure-1';

    setUp(() {
      repo = MemoryStyleCatalogRepository();
    });

    test('mergeRemoteStyleFigureTextOption upsert creates entity', () async {
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'text-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': 'Round front',
          'sort_order': 10,
          'is_active': true,
        },
      );

      final options = await repo.watchTextOptionsForFigure(shopId, figureId).first;
      expect(options.length, 1);
      expect(options.single.internalId, 'text-remote-1');
      expect(options.single.label, 'Round front');
    });

    test('second text option upsert updates without duplicate', () async {
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'text-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': 'Round front',
          'sort_order': 10,
          'is_active': true,
        },
      );
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'text-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': 'Updated label',
          'sort_order': 15,
          'is_active': false,
        },
      );

      final options = await repo.watchTextOptionsForFigure(shopId, figureId).first;
      expect(options.length, 1);
      expect(options.single.label, 'Updated label');
      expect(options.single.sortOrder, 15);
      expect(options.single.isActive, isFalse);
    });

    test('text option delete soft-deletes entity', () async {
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'text-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': 'Round front',
        },
      );
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'text-remote-1',
        operation: 'delete',
      );

      final options = await repo.watchTextOptionsForFigure(shopId, figureId).first;
      expect(options, isEmpty);
    });

    test('size option upsert and delete', () async {
      await repo.mergeRemoteStyleFigureSizeOption(
        shopId: shopId,
        internalId: 'size-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': '2.5 inch',
          'value_inches': 2.5,
          'unit_code': MeasurementUnitCodes.inch,
          'sort_order': 20,
        },
      );

      var options = await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      expect(options.single.valueInches, 2.5);

      await repo.mergeRemoteStyleFigureSizeOption(
        shopId: shopId,
        internalId: 'size-remote-1',
        operation: 'delete',
      );
      options = await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      expect(options, isEmpty);
    });

    test('preset upsert stores referenced option ids before options exist', () async {
      await repo.mergeRemoteStyleFigurePreset(
        shopId: shopId,
        internalId: 'preset-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'name': 'Normal Style',
          'text_option_internal_ids': ['missing-text-1'],
          'size_option_internal_ids': ['missing-size-1'],
          'sort_order': 10,
          'is_active': true,
        },
      );

      final presets = await repo.watchPresetsForFigure(shopId, figureId).first;
      expect(presets.single.textOptionInternalIds, ['missing-text-1']);
      expect(presets.single.sizeOptionInternalIds, ['missing-size-1']);
    });

    test('preset delete removes entity', () async {
      await repo.mergeRemoteStyleFigurePreset(
        shopId: shopId,
        internalId: 'preset-remote-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'name': 'Normal Style',
        },
      );
      await repo.mergeRemoteStyleFigurePreset(
        shopId: shopId,
        internalId: 'preset-remote-1',
        operation: 'delete',
      );

      final presets = await repo.watchPresetsForFigure(shopId, figureId).first;
      expect(presets, isEmpty);
    });

    test('remote delete for missing entity does not crash', () async {
      await repo.mergeRemoteStyleFigureTextOption(
        shopId: shopId,
        internalId: 'missing-text',
        operation: 'delete',
      );
      await repo.mergeRemoteStyleFigureSizeOption(
        shopId: shopId,
        internalId: 'missing-size',
        operation: 'delete',
      );
      await repo.mergeRemoteStyleFigurePreset(
        shopId: shopId,
        internalId: 'missing-preset',
        operation: 'delete',
      );
    });
  });
}
