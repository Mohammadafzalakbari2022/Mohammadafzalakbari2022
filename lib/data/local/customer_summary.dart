/// Row for customers list (plan-13).
class CustomerSummary {
  const CustomerSummary({
    required this.shopId,
    required this.internalId,
    required this.name,
    this.phone,
    this.address,
    this.notes,
    this.lastCatalogDesignName = '',
    this.lastCatalogThumbnailPath,
    this.lastCatalogItemInternalId,
    this.lastCatalogDesignerShopName = '',
    required this.createdAt,
  });

  final String shopId;
  final String internalId;
  final String name;
  final String? phone;
  final String? address;
  final String? notes;
  final String lastCatalogDesignName;
  final String? lastCatalogThumbnailPath;
  final String? lastCatalogItemInternalId;
  final String lastCatalogDesignerShopName;
  final DateTime createdAt;

  bool get hasLastCatalogDesign => lastCatalogDesignName.trim().isNotEmpty;
}

