import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/sync_outbox_kinds.dart';
import '../../../shell/shell_sync_providers.dart';

void _writeSyncTimestamps(
  Map<String, dynamic> map, {
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final now = DateTime.now().toUtc();
  map['updated_at'] = (updatedAt ?? now).toIso8601String();
  if (createdAt != null) {
    map['created_at'] = createdAt.toUtc().toIso8601String();
  }
}

void enqueueStyleNameUpsert(
  WidgetRef ref, {
  required String internalId,
  required String name,
  int? sortOrder,
  bool? isActive,
}) {
  final map = <String, dynamic>{'name': name};
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleNameUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueStyleNameDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleNameDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueStylePartUpsert(
  WidgetRef ref, {
  required String internalId,
  required String name,
  int? sortOrder,
  bool? isActive,
}) {
  final map = <String, dynamic>{'name': name};
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.stylePartUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueStylePartDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.stylePartDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueStyleFigureUpsert(
  WidgetRef ref, {
  required String internalId,
  required String partInternalId,
  required String name,
  required String imageRef,
  int? sortOrder,
  bool? isActive,
}) {
  final map = <String, dynamic>{
    'name': name,
    'part_internal_id': partInternalId,
    'image_ref': imageRef,
  };
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueStyleFigureDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueStyleFigureTextOptionUpsert(
  WidgetRef ref, {
  required String internalId,
  required String styleFigureInternalId,
  required String label,
  int? sortOrder,
  bool? isActive,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final map = <String, dynamic>{
    'style_figure_internal_id': styleFigureInternalId,
    'label': label,
  };
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  _writeSyncTimestamps(map, createdAt: createdAt, updatedAt: updatedAt);
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureTextOptionUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueStyleFigureTextOptionDelete(
  WidgetRef ref, {
  required String internalId,
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureTextOptionDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueStyleFigureSizeOptionUpsert(
  WidgetRef ref, {
  required String internalId,
  required String styleFigureInternalId,
  required String label,
  required double valueInches,
  int? unitCode,
  int? sortOrder,
  bool? isActive,
  DateTime? createdAt,
  DateTime? updatedAt,
}) {
  final map = <String, dynamic>{
    'style_figure_internal_id': styleFigureInternalId,
    'label': label,
    'value_inches': valueInches,
  };
  if (unitCode != null) map['unit_code'] = unitCode;
  if (sortOrder != null) map['sort_order'] = sortOrder;
  if (isActive != null) map['is_active'] = isActive;
  _writeSyncTimestamps(map, createdAt: createdAt, updatedAt: updatedAt);
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureSizeOptionUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueStyleFigureSizeOptionDelete(
  WidgetRef ref, {
  required String internalId,
}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.styleFigureSizeOptionDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}
