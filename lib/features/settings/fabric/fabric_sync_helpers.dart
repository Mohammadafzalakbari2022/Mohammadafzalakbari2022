import 'dart:convert';

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/auth_providers.dart';
import '../../../data/local/sync_outbox_kinds.dart';
import '../../../shell/shell_sync_providers.dart';

void enqueueFabricNameUpsert(
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
    kind: SyncOutboxKinds.fabricNameUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueFabricNameDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.fabricNameDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}

void enqueueFabricColorUpsert(
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
    kind: SyncOutboxKinds.fabricColorUpsert,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: jsonEncode(map),
  );
}

void enqueueFabricColorDelete(WidgetRef ref, {required String internalId}) {
  recordSyncOutboxMutation(
    ref,
    kind: SyncOutboxKinds.fabricColorDelete,
    entityRef: internalId,
    shopId: ref.read(effectiveShopIdProvider),
    payloadJson: '{}',
  );
}
