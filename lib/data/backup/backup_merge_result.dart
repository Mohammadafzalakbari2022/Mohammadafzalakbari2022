/// Counts after a merge-style restore (plan-15).
class BackupMergeResult {
  const BackupMergeResult({
    required this.customersInserted,
    required this.customersUpdated,
    required this.measurementTypesUpserted,
    required this.measurementProfilesUpserted,
    required this.measurementProfileItemsWritten,
    required this.ordersUpserted,
    required this.paymentsInserted,
    required this.paymentsSkippedExisting,
    required this.snapshotsUpserted,
    required this.snapshotItemsWritten,
    required this.notificationsInserted,
    required this.notificationsSkippedExisting,
  });

  final int customersInserted;
  final int customersUpdated;
  final int measurementTypesUpserted;
  final int measurementProfilesUpserted;
  final int measurementProfileItemsWritten;
  final int ordersUpserted;
  final int paymentsInserted;
  final int paymentsSkippedExisting;
  final int snapshotsUpserted;
  final int snapshotItemsWritten;
  final int notificationsInserted;
  final int notificationsSkippedExisting;
}
