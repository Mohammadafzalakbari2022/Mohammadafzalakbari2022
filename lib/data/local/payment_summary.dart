class PaymentSummary {
  const PaymentSummary({
    required this.internalId,
    required this.orderInternalId,
    required this.amountMinor,
    required this.method,
    required this.isAdjustment,
    required this.createdAt,
  });

  final String internalId;
  final String orderInternalId;
  final int amountMinor;
  final String method;
  final bool isAdjustment;
  final DateTime createdAt;
}

