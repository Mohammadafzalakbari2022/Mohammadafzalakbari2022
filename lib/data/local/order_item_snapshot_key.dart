/// Identifies one garment line when watching item-scoped snapshots.
class OrderItemSnapshotKey {
  const OrderItemSnapshotKey({
    required this.orderInternalId,
    required this.orderItemInternalId,
  });

  final String orderInternalId;
  final String orderItemInternalId;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is OrderItemSnapshotKey &&
          orderInternalId == other.orderInternalId &&
          orderItemInternalId == other.orderItemInternalId;

  @override
  int get hashCode => Object.hash(orderInternalId, orderItemInternalId);
}
