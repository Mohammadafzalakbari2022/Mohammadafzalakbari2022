/// Logical mutation kinds for [SyncOutboxRepository] (plan-03).
abstract final class SyncOutboxKinds {
  static const orderCreate = 'order_create';
  static const orderStatus = 'order_status';
  static const orderInternalNotes = 'order_internal_notes';
  static const paymentAppend = 'payment_append';
  static const notificationAppend = 'notification_append';
  static const measurementTypeUpsert = 'measurement_type_upsert';
  static const measurementTypeDelete = 'measurement_type_delete';
}
