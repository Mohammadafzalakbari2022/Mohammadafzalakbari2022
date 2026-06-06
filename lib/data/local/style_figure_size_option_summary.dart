class StyleFigureSizeOptionSummary {
  const StyleFigureSizeOptionSummary({
    required this.internalId,
    required this.shopId,
    required this.styleFigureInternalId,
    required this.label,
    required this.valueInches,
    required this.unitCode,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  final String styleFigureInternalId;
  final String label;
  final double valueInches;
  final int unitCode;
  final int sortOrder;
  final bool isActive;
}
