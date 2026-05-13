class CatalogItemDetail {
  const CatalogItemDetail({
    required this.internalId,
    required this.shopId,
    required this.designName,
    required this.designerShopName,
    required this.createdAt,
    required this.updatedAt,
    required this.isSharedPublic,
    this.notes,
    this.imagePath,
    this.thumbnailPath,
  });

  final String internalId;
  final String shopId;
  final String designName;
  final String designerShopName;
  final DateTime createdAt;
  final DateTime updatedAt;
  final bool isSharedPublic;
  final String? notes;
  final String? imagePath;
  final String? thumbnailPath;
}

