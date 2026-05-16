enum ShopExpenseCategory {
  daily(0),
  foodDrinks(1),
  other(2);

  const ShopExpenseCategory(this.code);
  final int code;

  static ShopExpenseCategory fromCode(int code) => ShopExpenseCategory.values.firstWhere(
        (c) => c.code == code,
        orElse: () => ShopExpenseCategory.other,
      );
}

class ShopRentSummary {
  const ShopRentSummary({
    required this.internalId,
    required this.shopId,
    required this.amountMinor,
    required this.dueDate,
    required this.periodMonths,
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final int amountMinor;
  final DateTime dueDate;
  final int periodMonths;
  final DateTime updatedAt;
}

class ShopRentPaymentSummary {
  const ShopRentPaymentSummary({
    required this.internalId,
    required this.shopId,
    required this.rentInternalId,
    required this.amountMinor,
    required this.paidAt,
    required this.note,
  });

  final String internalId;
  final String shopId;
  final String rentInternalId;
  final int amountMinor;
  final DateTime paidAt;
  final String note;
}

class ShopExpenseSummary {
  const ShopExpenseSummary({
    required this.internalId,
    required this.shopId,
    required this.category,
    required this.amountMinor,
    required this.expenseDate,
    required this.note,
    required this.updatedAt,
  });

  final String internalId;
  final String shopId;
  final ShopExpenseCategory category;
  final int amountMinor;
  final DateTime expenseDate;
  final String note;
  final DateTime updatedAt;
}
