class StyleFigureSummary {
  const StyleFigureSummary({
    required this.internalId,
    required this.shopId,
    required this.partInternalId,
    this.garmentTypeIndex = 0,
    required this.name,
    required this.imageRef,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  final String partInternalId;
  final int garmentTypeIndex;
  final String name;
  final String imageRef;
  final int sortOrder;
  final bool isActive;
}
