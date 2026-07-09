/// Append-only stock ledger movement kinds.
enum ClothStockMovementType {
  purchase(0),
  sale(1),
  saleVoid(2),
  adjustment(3);

  const ClothStockMovementType(this.code);

  final int code;

  static ClothStockMovementType fromCode(int code) {
    return ClothStockMovementType.values.firstWhere(
      (v) => v.code == code,
      orElse: () => ClothStockMovementType.adjustment,
    );
  }
}
