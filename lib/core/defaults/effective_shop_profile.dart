import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import '../branding/app_branding.dart';

/// Bundled logo until the shop uploads its own (same mark as login / app icon).
const kDefaultShopLogoAsset = kAppBrandIconAsset;

/// Fills missing shop fields with localized placeholders for print/share only.
ShopProfile effectiveShopProfile(ShopProfile? shop, AppLocalizations l10n) {
  final name = (shop?.name ?? '').trim();
  final address = shop?.address?.trim();
  final phone = shop?.phone?.trim();

  return ShopProfile(
    name: name.isNotEmpty ? name : l10n.defaultShopName,
    address: (address != null && address.isNotEmpty)
        ? address
        : l10n.defaultShopAddress,
    phone: (phone != null && phone.isNotEmpty) ? phone : l10n.defaultShopPhone,
    notes: shop?.notes,
    receiptThankYouMessage: shop?.receiptThankYouMessage,
    logoRelativePath: shop?.logoRelativePath,
  );
}

bool shopProfileHasCustomLogo(ShopProfile? shop) {
  final path = shop?.logoRelativePath?.trim();
  return path != null && path.isNotEmpty;
}
