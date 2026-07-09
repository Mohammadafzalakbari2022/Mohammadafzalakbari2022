import 'entities/cloth_stock_movement_type.dart';

/// Read model for a cloth stock SKU.
class ClothStockSkuSummary {
  const ClothStockSkuSummary({
    required this.internalId,
    required this.shopId,
    required this.skuCode,
    required this.name,
    this.color = '',
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
    required this.qtyOnHandMilli,
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final String skuCode;
  final String name;
  final String color;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;
  final int qtyOnHandMilli;
  final DateTime updatedAt;

  double get qtyOnHandMeters => qtyOnHandMilli / 1000.0;

  bool get isShortStock => qtyOnHandMilli < 0;

  String displayLabel(String colorPart) {
    final parts = <String>[name.trim()];
    if (color.trim().isNotEmpty) parts.add(color.trim());
    if (skuCode.trim().isNotEmpty) parts.add('($skuCode)');
    return parts.join(' · ');
  }
}

class ClothSupplierSummary {
  const ClothSupplierSummary({
    required this.internalId,
    required this.shopId,
    required this.name,
    this.phone = '',
    this.notes = '',
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final String name;
  final String phone;
  final String notes;
  final DateTime updatedAt;
}

class ClothPurchaseLineSummary {
  const ClothPurchaseLineSummary({
    required this.internalId,
    required this.shopId,
    required this.purchaseInternalId,
    required this.skuInternalId,
    required this.qtyMilli,
    required this.unitCostAmountMinor,
    required this.lineTotalMinor,
  });

  final String internalId;
  final String shopId;
  final String purchaseInternalId;
  final String skuInternalId;
  final int qtyMilli;
  final int unitCostAmountMinor;
  final int lineTotalMinor;

  double get qtyMeters => qtyMilli / 1000.0;
}

class ClothPurchaseSummary {
  const ClothPurchaseSummary({
    required this.internalId,
    required this.shopId,
    required this.supplierInternalId,
    required this.purchaseDate,
    required this.totalAmountMinor,
    this.note = '',
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final String supplierInternalId;
  final DateTime purchaseDate;
  final int totalAmountMinor;
  final String note;
  final DateTime updatedAt;
}

class ClothPurchasePaymentSummary {
  const ClothPurchasePaymentSummary({
    required this.internalId,
    required this.shopId,
    required this.purchaseInternalId,
    required this.amountMinor,
    required this.paidAt,
    this.note = '',
  });

  final String internalId;
  final String shopId;
  final String purchaseInternalId;
  final int amountMinor;
  final DateTime paidAt;
  final String note;
}

class ClothStockMovementSummary {
  const ClothStockMovementSummary({
    required this.internalId,
    required this.shopId,
    required this.skuInternalId,
    required this.movementType,
    required this.qtyMilliDelta,
    this.orderItemInternalId,
    this.purchaseLineInternalId,
    this.note = '',
    required this.createdAt,
  });

  final String internalId;
  final String shopId;
  final String skuInternalId;
  final ClothStockMovementType movementType;
  final int qtyMilliDelta;
  final String? orderItemInternalId;
  final String? purchaseLineInternalId;
  final String note;
  final DateTime createdAt;
}

/// Input for creating/updating a purchase with lines.
class ClothPurchaseUpsertInput {
  const ClothPurchaseUpsertInput({
    required this.internalId,
    required this.supplierInternalId,
    required this.purchaseDate,
    this.note = '',
    required this.lines,
  });

  final String internalId;
  final String supplierInternalId;
  final DateTime purchaseDate;
  final String note;
  final List<ClothPurchaseLineInput> lines;
}

class ClothPurchaseLineInput {
  const ClothPurchaseLineInput({
    this.internalId,
    required this.skuInternalId,
    required this.qtyMilli,
    required this.unitCostAmountMinor,
  });

  final String? internalId;
  final String skuInternalId;
  final int qtyMilli;
  final int unitCostAmountMinor;

  int get lineTotalMinor =>
      ((qtyMilli / 1000.0) * unitCostAmountMinor).round();
}

int totalPaidForPurchase(
  String purchaseInternalId,
  List<ClothPurchasePaymentSummary> payments,
) =>
    payments
        .where((p) => p.purchaseInternalId == purchaseInternalId)
        .fold<int>(0, (sum, p) => sum + p.amountMinor);

int purchaseBalanceMinor(
  ClothPurchaseSummary purchase,
  List<ClothPurchasePaymentSummary> payments,
) =>
    purchase.totalAmountMinor -
    totalPaidForPurchase(purchase.internalId, payments);

/// Converts meters text to milli-meters (supports localized digits).
int parseMetersToMilli(String raw) {
  final normalized = raw.trim().replaceAll(',', '.');
  if (normalized.isEmpty) return 0;
  final meters = double.tryParse(normalized) ?? 0;
  return (meters * 1000).round();
}

String formatMilliMeters(int milli) {
  if (milli == 0) return '0';
  final meters = milli / 1000.0;
  if (meters == meters.roundToDouble()) {
    return meters.toStringAsFixed(0);
  }
  return meters.toStringAsFixed(3).replaceAll(RegExp(r'0+$'), '').replaceAll(RegExp(r'\.$'), '');
}
