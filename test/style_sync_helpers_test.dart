import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/sync/outbox_push_batch.dart';
import 'package:pride_v3/data/local/measurement_unit_codes.dart';
import 'package:pride_v3/data/local/sync_outbox_kinds.dart';
import 'package:pride_v3/data/local/sync_outbox_pending_view.dart';

void main() {
  final queuedAt = DateTime.utc(2026, 6, 6, 12);

  SyncOutboxPendingView pending({
    required String kind,
    required String entityRef,
    required String payloadJson,
  }) =>
      SyncOutboxPendingView(
        entryId: 'entry-$entityRef',
        kind: kind,
        entityRef: entityRef,
        queuedAt: queuedAt,
        payloadJson: payloadJson,
      );

  group('style figure option/preset outbox push mapping', () {
    test('text option upsert maps to style_figure_text_option upsert', () {
      final meta = syncPushMetaForOutboxKind(
        SyncOutboxKinds.styleFigureTextOptionUpsert,
      );
      expect(meta!.entityType, 'style_figure_text_option');
      expect(meta.operation, 'upsert');

      final batch = buildOutboxPushBatch([
        pending(
          kind: SyncOutboxKinds.styleFigureTextOptionUpsert,
          entityRef: 'text-opt-1',
          payloadJson: jsonEncode({
            'style_figure_internal_id': 'fig-1',
            'label': 'Round front',
            'sort_order': 10,
            'is_active': true,
            'created_at': queuedAt.toIso8601String(),
            'updated_at': queuedAt.toIso8601String(),
          }),
        ),
      ]);

      expect(batch.mutations, hasLength(1));
      final row = batch.mutations.single;
      expect(row['internal_id'], 'text-opt-1');
      expect(row['entity_type'], 'style_figure_text_option');
      expect(row['operation'], 'upsert');
      final data = row['data'] as Map<String, dynamic>;
      expect(data['style_figure_internal_id'], 'fig-1');
      expect(data['label'], 'Round front');
    });

    test('text option delete omits data payload', () {
      final meta = syncPushMetaForOutboxKind(
        SyncOutboxKinds.styleFigureTextOptionDelete,
      );
      expect(meta!.entityType, 'style_figure_text_option');
      expect(meta.operation, 'delete');

      final batch = buildOutboxPushBatch([
        pending(
          kind: SyncOutboxKinds.styleFigureTextOptionDelete,
          entityRef: 'text-opt-1',
          payloadJson: '{}',
        ),
      ]);

      final row = batch.mutations.single;
      expect(row['operation'], 'delete');
      expect(row.containsKey('data'), isFalse);
    });

    test('size option upsert includes value_inches and unit_code', () {
      final batch = buildOutboxPushBatch([
        pending(
          kind: SyncOutboxKinds.styleFigureSizeOptionUpsert,
          entityRef: 'size-opt-1',
          payloadJson: jsonEncode({
            'style_figure_internal_id': 'fig-1',
            'label': '2.5 inch',
            'value_inches': 2.5,
            'unit_code': MeasurementUnitCodes.inch,
            'sort_order': 20,
            'is_active': true,
          }),
        ),
      ]);

      final data = batch.mutations.single['data'] as Map<String, dynamic>;
      expect(batch.mutations.single['entity_type'], 'style_figure_size_option');
      expect(data['value_inches'], 2.5);
      expect(data['unit_code'], MeasurementUnitCodes.inch);
    });

    test('preset upsert sends option id arrays not JSON string field names', () {
      final batch = buildOutboxPushBatch([
        pending(
          kind: SyncOutboxKinds.styleFigurePresetUpsert,
          entityRef: 'preset-1',
          payloadJson: jsonEncode({
            'style_figure_internal_id': 'fig-1',
            'name': 'Normal Style',
            'text_option_internal_ids': ['text-1', 'text-2'],
            'size_option_internal_ids': ['size-1'],
            'sort_order': 10,
            'is_active': true,
          }),
        ),
      ]);

      final data = batch.mutations.single['data'] as Map<String, dynamic>;
      expect(batch.mutations.single['entity_type'], 'style_figure_preset');
      expect(data['text_option_internal_ids'], ['text-1', 'text-2']);
      expect(data['size_option_internal_ids'], ['size-1']);
      expect(data.containsKey('textOptionInternalIdsJson'), isFalse);
      expect(data.containsKey('sizeOptionInternalIdsJson'), isFalse);
    });

    test('preset delete follows existing delete pattern', () {
      final batch = buildOutboxPushBatch([
        pending(
          kind: SyncOutboxKinds.styleFigurePresetDelete,
          entityRef: 'preset-1',
          payloadJson: '{}',
        ),
      ]);

      final row = batch.mutations.single;
      expect(row['entity_type'], 'style_figure_preset');
      expect(row['operation'], 'delete');
      expect(row.containsKey('data'), isFalse);
    });
  });
}
