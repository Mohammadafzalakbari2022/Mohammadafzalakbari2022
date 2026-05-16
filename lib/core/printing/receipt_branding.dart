import '../../core/defaults/effective_shop_profile.dart';
import '../../features/settings/shop_profile.dart';
import '../../l10n/app_localizations.dart';
import 'receipt_line_wrap.dart';

/// Shop identity block for thermal print and plain-text share invoices.
class ReceiptBranding {
  const ReceiptBranding({
    required this.shopDisplayName,
    this.shopPhoneLine,
    required this.addressLines,
    required this.thankYouLines,
    required this.wrapChars,
  });

  final String shopDisplayName;
  final String? shopPhoneLine;
  final List<String> addressLines;
  final List<String> thankYouLines;
  final int wrapChars;

  bool get hasAddress => addressLines.isNotEmpty;

  factory ReceiptBranding.fromShop({
    required ShopProfile? shop,
    required AppLocalizations l10n,
    required int wrapChars,
  }) {
    final effective = effectiveShopProfile(shop, l10n);

    final shopDisplayName = effective.name.trim();

    final addrRaw = effective.address?.trim();
    final addressLines = (addrRaw == null || addrRaw.isEmpty)
        ? const <String>[]
        : wrapReceiptLines(addrRaw, wrapChars);

    final phoneRaw = effective.phone?.trim();
    final shopPhoneLine = (phoneRaw == null || phoneRaw.isEmpty)
        ? null
        : '${l10n.receiptShopPhoneLabel}: $phoneRaw';

    final customThanks = effective.receiptThankYouMessage?.trim();
    final thankYouRaw = (customThanks != null && customThanks.isNotEmpty)
        ? customThanks
        : l10n.receiptFooterThanks;
    final thankYouLines = wrapReceiptLines(thankYouRaw, wrapChars);

    return ReceiptBranding(
      shopDisplayName: shopDisplayName,
      shopPhoneLine: shopPhoneLine,
      addressLines: addressLines,
      thankYouLines: thankYouLines,
      wrapChars: wrapChars,
    );
  }
}

/// Center a line for monospace-style share text (best-effort).
String centerReceiptShareLine(String line, {int width = 32}) {
  final t = line.trim();
  if (t.isEmpty) return '';
  if (t.length >= width) return t;
  final pad = (width - t.length) ~/ 2;
  return '${' ' * pad}$t';
}
