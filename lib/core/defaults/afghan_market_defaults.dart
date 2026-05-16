/// Typical tailoring prices in Afghanistan (AFN whole units; stored as amountMinor).
abstract final class AfghanMarketDefaults {
  /// Labor for one garment — common hint when adding a payment line.
  static const int exampleGarmentLaborAfn = 300;

  /// Typical full-order total for one outfit (perahan / suit).
  static const int exampleOrderTotalAfn = 1500;

  /// Typical advance/deposit when saving a new order.
  static const int exampleInitialPaymentAfn = 500;

  /// Typical partial payment on an existing order.
  static const int examplePaymentAfn = 300;
}
