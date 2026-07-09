/// Whether order cloth comes from the customer or shop stock inventory.
enum ClothSource {
  customerSupplied(0),
  shopStock(1);

  const ClothSource(this.code);

  final int code;

  static ClothSource fromCode(int code) {
    return ClothSource.values.firstWhere(
      (v) => v.code == code,
      orElse: () => ClothSource.customerSupplied,
    );
  }

  bool get isShopStock => this == ClothSource.shopStock;
}
