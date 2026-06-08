/// Planning stub for multi-garment order migration (Phase 2+).
///
/// **Not wired into app startup in Phase 1.** Do not call from providers or
/// repository code until Phase 2 implements and tests the migration.
abstract final class IsarOrderMigrationV4 {
  /// Human-readable migration version label for docs and future logs.
  static const migrationLabel = 'order_items_v4';

  /// Planned steps (documentation only — no active behavior):
  ///
  /// 1. **Flat order → first item**
  ///    - For each existing [OrderEntity] with legacy garment fields populated,
  ///      create one [OrderItemEntity] with `garmentType = perahanTunban`.
  ///    - Copy measurements, style, catalog, and fabric snapshots from the
  ///      order row onto that item.
  ///
  /// 2. **Price**
  ///    - Set the migrated item's `priceAmountMinor` from the order's existing
  ///      `totalAmountMinor` (single-garment orders today).
  ///    - Keep `OrderEntity.totalAmountMinor` as the sum of item prices.
  ///
  /// 3. **Measurement/style snapshots**
  ///    - Retarget [OrderMeasurementSnapshotEntity] and [OrderStyleSnapshotEntity]
  ///      from unique `orderInternalId` to unique `orderItemInternalId`.
  ///    - One snapshot header (+ items/figures) per order item.
  ///
  /// 4. **Backup**
  ///    - Bump [IsarBackupV1.currentExportVersion] to **4**.
  ///    - Export/import `orderItems`, style snapshot tables, and order fields
  ///      currently missing from backup v3 (fabric, catalog, customer snapshots).
  ///
  /// 5. **Sync**
  ///    - **Dual-read:** `mergeRemoteOrder` accepts legacy flat payloads and
  ///      new `items[]` arrays; flat payloads map to one `perahanTunban` item.
  ///    - **Transitional dual-write:** new clients may send both `items[]` and
  ///      flat fields (copied from the first Perahan item) for one release window.
  ///
  /// 6. **Constraints**
  ///    - At most one item per [GarmentType] per order (unique composite index).
  ///
  /// Phase 1 does not register schemas, run migration, or change repositories.
}
