/// Local shop profile (plan-15) until multi-shop API exists.
class ShopProfile {
  const ShopProfile({
    required this.name,
    this.address,
    this.phone,
    this.notes,
    this.receiptThankYouMessage,
    this.logoRelativePath,
    this.bannerRelativePath,
  });

  final String name;
  final String? address;
  final String? phone;
  final String? notes;

  /// Printed at the bottom of receipts / shared invoices when set.
  final String? receiptThankYouMessage;

  /// App-documents relative path (POSIX segments), e.g. `branding/shop_logo.png`.
  final String? logoRelativePath;

  /// Wide banner path, e.g. `branding/shop_banner.png`.
  final String? bannerRelativePath;

  ShopProfile copyWith({
    String? name,
    String? address,
    String? phone,
    String? notes,
    String? receiptThankYouMessage,
    String? logoRelativePath,
    String? bannerRelativePath,
    bool clearLogo = false,
    bool clearBanner = false,
  }) {
    return ShopProfile(
      name: name ?? this.name,
      address: address ?? this.address,
      phone: phone ?? this.phone,
      notes: notes ?? this.notes,
      receiptThankYouMessage:
          receiptThankYouMessage ?? this.receiptThankYouMessage,
      logoRelativePath:
          clearLogo ? null : (logoRelativePath ?? this.logoRelativePath),
      bannerRelativePath:
          clearBanner ? null : (bannerRelativePath ?? this.bannerRelativePath),
    );
  }
}
