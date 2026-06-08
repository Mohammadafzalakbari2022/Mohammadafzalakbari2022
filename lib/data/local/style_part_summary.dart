class StylePartSummary {
  const StylePartSummary({
    required this.internalId,
    required this.shopId,
    this.garmentTypeIndex = 0,
    required this.name,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  final int garmentTypeIndex;
  final String name;
  final int sortOrder;
  final bool isActive;
}
