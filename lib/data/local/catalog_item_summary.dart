class CatalogItemSummary {
  const CatalogItemSummary({
    required this.internalId,
    required this.shopId,
    required this.designName,
    required this.designerShopName,
    required this.createdAt,
    required this.isSharedPublic,
    this.imagePath,
    this.thumbnailPath,
  });

  final String internalId;
  final String shopId;
  final String designName;
  final String designerShopName;
  final DateTime createdAt;
  final bool isSharedPublic;
  final String? imagePath;
  final String? thumbnailPath;
}

