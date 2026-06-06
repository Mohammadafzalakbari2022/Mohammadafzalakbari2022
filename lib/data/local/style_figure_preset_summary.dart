class StyleFigurePresetSummary {
  const StyleFigurePresetSummary({
    required this.internalId,
    required this.shopId,
    required this.styleFigureInternalId,
    required this.name,
    required this.textOptionInternalIds,
    required this.sizeOptionInternalIds,
    required this.sortOrder,
    required this.isActive,
  });

  final String internalId;
  final String shopId;
  final String styleFigureInternalId;
  final String name;
  final List<String> textOptionInternalIds;
  final List<String> sizeOptionInternalIds;
  final int sortOrder;
  final bool isActive;
}
