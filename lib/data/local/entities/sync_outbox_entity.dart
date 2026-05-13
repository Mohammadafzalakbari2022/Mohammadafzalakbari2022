import 'package:isar/isar.dart';

part 'sync_outbox_entity.g.dart';

/// One local mutation waiting to be pushed when the sync API exists (plan-03).
@collection
class SyncOutboxEntity {
  Id id = Isar.autoIncrement;

  @Index(unique: true, replace: true)
  late String entryId;

  @Index()
  late String shopId;

  /// [SyncOutboxKinds] value.
  @Index()
  late String kind;

  /// Related entity id when applicable (e.g. order [internalId]).
  String entityRef = '';

  /// Opaque JSON snapshot for a future sync worker.
  String payloadJson = '{}';

  @Index()
  late DateTime queuedAt;

  /// When non-null, this entry has been acknowledged by sync (not used yet).
  DateTime? syncedAt;
}
