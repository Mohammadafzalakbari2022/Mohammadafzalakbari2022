import 'entities/order_status.dart';

/// Row for orders list (plan-12).
class OrderSummary {
  const OrderSummary({
    required this.shopId,
    required this.internalId,
    required this.displayOrderNo,
    required this.customerInternalId,
    required this.customerName,
    this.customerPhone,
    this.measurementsSnapshot = '',
    this.styleNotes = '',
    this.internalNotes = '',
    this.sourceMeasurementProfileId,
    this.sourceMeasurementProfileLabel = '',
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
  final String measurementsSnapshot;
  final String styleNotes;
  final String internalNotes;
  final String? sourceMeasurementProfileId;
  final String sourceMeasurementProfileLabel;
  final OrderLocalStatus status;
  final DateTime deliveryDate;
  final DateTime createdAt;
  final DateTime updatedAt;
  final int totalAmountMinor;
  final int paidAmountMinor;

  int get remainingAmountMinor => totalAmountMinor - paidAmountMinor;

  bool get isUnpaid => remainingAmountMinor > 0;
}
