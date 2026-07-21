import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/printing/invoice/invoice_document_shapes.dart';
import 'package:pride_v3/data/local/order_style_snapshot_view.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

void main() {
  late AppLocalizations l10nEn;

  setUp(() async {
    l10nEn = lookupAppLocalizations(const Locale('en'));
  });

  test('invoiceDocumentShapesFromSnapshot includes name inch and hand details', () {
    final snapshot = OrderStyleSnapshotView(
      orderInternalId: 'order-1',
      snapshotInternalId: 'snap-1',
      styleNameSnapshot: 'Qasimi',
      createdAt: DateTime(2026, 5, 17),
      figures: [
        OrderStyleSnapshotFigureView(
          styleFigureInternalId: 'fig-1',
          figureNameSnapshot: 'Collar A',
          imageRefSnapshot: 'assets/style_figures/shape_1.png',
          sortOrder: 0,
          textOptions: [
            OrderShapeOptionSnapshotView(id: 't1', labelSnapshot: 'Hand stitch'),
          ],
          sizeOptions: [
            OrderShapeSizeSnapshotView(
              id: 's1',
              valueSnapshot: 2.5,
              labelSnapshot: 'Width',
              unitSnapshot: 'in',
            ),
          ],
          noteSnapshot: 'Extra padding',
        ),
      ],
    );

    final shapes = invoiceDocumentShapesFromSnapshot(
      snapshot: snapshot,
      l10n: l10nEn,
    );

    expect(shapes, hasLength(1));
    expect(shapes.first.shapeName, 'Collar A');
    expect(shapes.first.imageRef, contains('shape_1'));
    expect(shapes.first.detailRows.map((r) => r.value), contains('Hand stitch'));
    expect(shapes.first.detailRows.map((r) => r.value), contains('Width'));
    expect(shapes.first.note, 'Extra padding');
  });

  test('invoiceDocumentShapesFromSnapshot keeps shape with name only', () {
    final snapshot = OrderStyleSnapshotView(
      orderInternalId: 'order-1',
      snapshotInternalId: 'snap-1',
      styleNameSnapshot: 'Qasimi',
      createdAt: DateTime(2026, 5, 17),
      figures: [
        OrderStyleSnapshotFigureView(
          styleFigureInternalId: 'fig-1',
          figureNameSnapshot: 'Pocket style',
          imageRefSnapshot: '',
          sortOrder: 0,
        ),
      ],
    );

    final shapes = invoiceDocumentShapesFromSnapshot(
      snapshot: snapshot,
      l10n: l10nEn,
    );

    expect(shapes, hasLength(1));
    expect(shapes.first.shapeName, 'Pocket style');
  });
}
