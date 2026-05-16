import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/sync_outbox_kinds.dart';
import '../../../shell/shell_sync_providers.dart';

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
