/// Logical mutation kinds for [SyncOutboxRepository] (plan-03).
abstract final class SyncOutboxKinds {
  static const orderCreate = 'order_create';
  static const orderStatus = 'order_status';
  static const orderInternalNotes = 'order_internal_notes';
  static const paymentAppend = 'payment_append';
  static const notificationAppend = 'notification_append';
  static const measurementTypeUpsert = 'measurement_type_upsert';
  static const measurementTypeDelete = 'measurement_type_delete';
  static const customerUpsert = 'customer_upsert';
  static const customerDelete = 'customer_delete';
  static const taskUpsert = 'task_upsert';
  static const taskDelete = 'task_delete';
  static const measurementProfileUpsert = 'measurement_profile_upsert';
  static const measurementProfileDelete = 'measurement_profile_delete';
  static const catalogItemUpsert = 'catalog_item_upsert';
  static const catalogItemDelete = 'catalog_item_delete';
  static const styleNameUpsert = 'style_name_upsert';
  static const styleNameDelete = 'style_name_delete';
  static const stylePartUpsert = 'style_part_upsert';
  static const stylePartDelete = 'style_part_delete';
  static const styleFigureUpsert = 'style_figure_upsert';
  static const styleFigureDelete = 'style_figure_delete';
}
