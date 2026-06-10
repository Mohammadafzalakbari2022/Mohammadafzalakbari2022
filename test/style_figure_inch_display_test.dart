import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/data/local/memory_style_catalog_repository.dart';
import 'package:pride_v3/data/local/style/style_figure_inch_display.dart';
import 'package:pride_v3/data/local/style/order_shape_selection_formatter.dart';
import 'package:pride_v3/data/local/style/style_order_selection.dart';
import 'package:pride_v3/features/orders/order_composer_shape_config_draft.dart';
import 'package:pride_v3/data/local/style_figure_config_summary.dart';
import 'package:pride_v3/data/local/style_figure_summary.dart';

void main() {
  group('parseInchMeasurementForStorage', () {
    test('preserves tailor text exactly', () {
      const input = '5 1/2 x 7 1/2 inch';
      final stored = parseInchMeasurementForStorage(input);
      expect(stored.label, input);
      expect(stored.valueInches, 0);
    });

    test('preserves unicode fraction measurements', () {
      const input = '5½ x 7½ inch';
      final stored = parseInchMeasurementForStorage(input);
      expect(stored.label, input);
      expect(stored.valueInches, 0);
    });

    test('preserves decimal dimension measurements without reformatting', () {
      const input = '5.5 x 7.5 inch';
      final stored = parseInchMeasurementForStorage(input);
      expect(stored.label, input);
      expect(stored.valueInches, 0);
    });

    test('preserves pure numeric text without appending inch', () {
      final stored = parseInchMeasurementForStorage('5.5');
      expect(stored.label, '5.5');
      expect(stored.valueInches, 5.5);
    });

    test('preserves any unicode text', () {
      const input = 'ABC اردو پښتو ½ @ #';
      final stored = parseInchMeasurementForStorage(input);
      expect(stored.label, input);
      expect(stored.valueInches, 0);
    });

    test('preserves letters-only text', () {
      const input = 'Large collar';
      final stored = parseInchMeasurementForStorage(input);
      expect(stored.label, input);
      expect(stored.valueInches, 0);
    });
  });

  group('displayInchOptionLabel', () {
    test('shows saved label text exactly', () {
      expect(
        displayInchOptionLabel(
          valueInches: 0,
          label: '5 1/2 x 7 1/2 inch',
        ),
        '5 1/2 x 7 1/2 inch',
      );
    });

    test('shows stored label without modification', () {
      expect(
        displayInchOptionLabel(valueInches: 5.5, label: '5.5 inch'),
        '5.5 inch',
      );
    });

    test('legacy numeric fallback without inch suffix', () {
      expect(
        displayInchOptionLabel(valueInches: 5.5, label: ''),
        '5.5',
      );
      expect(
        displayInchOptionLabel(valueInches: 5, label: ''),
        '5',
      );
    });

    test('prefers label over valueInches', () {
      expect(
        displayInchOptionLabel(valueInches: 0, label: 'Legacy size'),
        'Legacy size',
      );
    });
  });

  group('MemoryStyleCatalogRepository inch option create', () {
    test('auto-assigns sortOrder and preserves label', () async {
      final repo = MemoryStyleCatalogRepository();
      const shopId = 'shop-1';
      const figureId = 'figure-1';

      final firstId = await repo.createStyleFigureSizeOption(
        shopId: shopId,
        styleFigureInternalId: figureId,
        label: '5',
        valueInches: 5,
      );
      final secondId = await repo.createStyleFigureSizeOption(
        shopId: shopId,
        styleFigureInternalId: figureId,
        label: '5.5',
        valueInches: 5.5,
      );

      final options =
          await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      expect(options.length, 2);

      final first = options.firstWhere((o) => o.internalId == firstId);
      final second = options.firstWhere((o) => o.internalId == secondId);
      expect(first.sortOrder, 10);
      expect(second.sortOrder, 20);
      expect(displayInchOptionLabel(
        valueInches: second.valueInches,
        label: second.label,
      ), '5.5');
    });

    test('persists tailor measurement label', () async {
      final repo = MemoryStyleCatalogRepository();
      const shopId = 'shop-1';
      const figureId = 'figure-1';
      const tailorLabel = '5 1/2 x 7 1/2 inch';

      final id = await repo.createStyleFigureSizeOption(
        shopId: shopId,
        styleFigureInternalId: figureId,
        label: tailorLabel,
        valueInches: 0,
      );

      final options =
          await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      final option = options.firstWhere((o) => o.internalId == id);
      expect(option.label, tailorLabel);
      expect(option.valueInches, 0);
      expect(
        displayInchOptionLabel(
          valueInches: option.valueInches,
          label: option.label,
        ),
        tailorLabel,
      );
    });

    test('tailor option with valueInches zero appears in order composer display',
        () async {
      final repo = MemoryStyleCatalogRepository();
      const shopId = 'shop-1';
      const figureId = 'figure-1';
      const tailorLabel = '5 1/2 x 7 1/2 inch';

      final sizeId = await repo.createStyleFigureSizeOption(
        shopId: shopId,
        styleFigureInternalId: figureId,
        label: tailorLabel,
        valueInches: 0,
      );

      const figure = StyleFigureSummary(
        internalId: figureId,
        shopId: shopId,
        partInternalId: 'part-1',
        name: 'Collar',
        imageRef: '',
        sortOrder: 10,
        isActive: true,
      );
      final options =
          await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      final config = StyleFigureConfigSummary(
        figure: figure,
        textOptions: const [],
        sizeOptions: options,
      );
      final selection = buildStyleOrderSelectionFromDrafts(
        selectedFigureIds: {figureId},
        drafts: {
          figureId: ShapeConfigDraft(
            shapeId: figureId,
            selectedSizeOptionIds: {sizeId},
          ),
        },
        allFigures: [figure],
        configs: {figureId: config},
      );

      final display = formatOrderShapeSelectionDisplay(
        styleSelectionJson: selection.toJsonString(),
      );

      expect(display.figures.single.sizeLabel, tailorLabel);
    });

    test('remote merge accepts valueInches zero for tailor text', () async {
      final repo = MemoryStyleCatalogRepository();
      const shopId = 'shop-1';
      const figureId = 'figure-1';
      const tailorLabel = '5½ x 7½ inch';

      await repo.mergeRemoteStyleFigureSizeOption(
        shopId: shopId,
        internalId: 'remote-size-1',
        operation: 'upsert',
        data: {
          'style_figure_internal_id': figureId,
          'label': tailorLabel,
          'value_inches': 0,
          'unit_code': 1,
          'sort_order': 10,
          'is_active': true,
        },
      );

      final options =
          await repo.watchSizeOptionsForFigure(shopId, figureId).first;
      expect(options, hasLength(1));
      expect(options.single.label, tailorLabel);
      expect(options.single.valueInches, 0);
    });
  });
}
