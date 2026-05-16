class StyleNameSummary {
  const StyleNameSummary({
    required this.internalId,
    required this.shopId,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  final String name;
  final int sortOrder;
  final bool isActive;
}
