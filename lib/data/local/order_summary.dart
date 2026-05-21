import 'entities/order_status.dart';
import 'order_customer_history.dart';

/// Row for orders list (plan-12).
class OrderSummary {
  const OrderSummary({
    required this.shopId,
    required this.internalId,
    required this.displayOrderNo,
    required this.customerInternalId,
    required this.customerName,
    this.customerPhone,
    this.customerChangeHistory = const [],
    this.measurementsSnapshot = '',
    this.internalNotes = '',
    this.sourceMeasurementProfileId,
    this.sourceMeasurementProfileLabel = '',
    this.styleName = '',
    this.styleNameInternalId,
    this.styleSelectionJson = '',
    this.styleSummary = '',
    this.catalogItemInternalId,
    this.catalogDesignNameSnapshot = '',
    this.catalogDesignerShopNameSnapshot = '',
    this.catalogImagePathSnapshot,
    this.catalogThumbnailPathSnapshot,
    this.fabricNameSnapshot = '',
    this.fabricColorSnapshot = '',
    this.fabricIdSnapshot = '',
    this.fabricNamePresetInternalId,
    this.fabricColorPresetInternalId,
    required this.status,
    required this.deliveryDate,
    required this.createdAt,
    required this.updatedAt,
    required this.totalAmountMinor,
    required this.paidAmountMinor,
  });

  final String shopId;
  final String internalId;
  final String displayOrderNo;
  final String customerInternalId;
  final String customerName;
  final String? customerPhone;
  final List<OrderCustomerHistoryEntry> customerChangeHistory;
  final String measurementsSnapshot;
  final String internalNotes;
  final String? sourceMeasurementProfileId;
  final String sourceMeasurementProfileLabel;
  final String styleName;
  final String? styleNameInternalId;
  final String styleSelectionJson;
  final String styleSummary;
  final String? catalogItemInternalId;
  final String catalogDesignNameSnapshot;
  final String catalogDesignerShopNameSnapshot;
  final String? catalogImagePathSnapshot;
  final String? catalogThumbnailPathSnapshot;
  final String fabricNameSnapshot;
  final String fabricColorSnapshot;
  final String fabricIdSnapshot;
  final String? fabricNamePresetInternalId;
  final String? fabricColorPresetInternalId;
  final OrderLocalStatus status;

  bool get hasCustomerFabric =>
      fabricNameSnapshot.trim().isNotEmpty ||
      fabricColorSnapshot.trim().isNotEmpty ||
      fabricIdSnapshot.trim().isNotEmpty;
  final DateTime deliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalAmountMinor;
  final int paidAmountMinor;

  int get remainingAmountMinor => totalAmountMinor - paidAmountMinor;

  bool get isUnpaid => remainingAmountMinor > 0;
}
