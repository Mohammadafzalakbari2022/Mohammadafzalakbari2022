import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../core/defaults/effective_shop_profile.dart';
import 'settings_providers.dart';
import 'shop_profile.dart';
import 'shop_profile_storage.dart';

class ShopProfileNotifier extends AsyncNotifier<ShopProfile> {
  @override
  Future<ShopProfile> build() => loadShopProfile();

  Future<void> save(ShopProfile profile) async {
    final name = profile.name.trim();
    final address = profile.address?.trim();
    final phone = profile.phone?.trim();
    final notes = profile.notes?.trim();
    final receiptThanks = profile.receiptThankYouMessage?.trim();

    final next = ShopProfile(
      name: name,
      address: (address == null || address.isEmpty) ? null : address,
      phone: (phone == null || phone.isEmpty) ? null : phone,
      notes: (notes == null || notes.isEmpty) ? null : notes,
      receiptThankYouMessage: (receiptThanks == null || receiptThanks.isEmpty)
          ? null
          : receiptThanks,
      logoRelativePath: profile.logoRelativePath,
    );

    await saveShopProfile(next);
    state = AsyncData(next);
  }
}

final shopProfileProvider =
    AsyncNotifierProvider<ShopProfileNotifier, ShopProfile>(
  ShopProfileNotifier.new,
);

Locale _resolvedLocale(Locale override) => override;

AppLocalizations _l10nFor(Locale locale) {
  final supported = AppLocalizations.supportedLocales.any(
    (l) => l.languageCode == locale.languageCode,
  );
  return lookupAppLocalizations(
    supported ? locale : const Locale('fa'),
  );
}

/// Resolved shop name for shell title, catalog watermark, etc.
final shopDisplayNameProvider = Provider<String>((ref) {
  final l10n = _l10nFor(_resolvedLocale(ref.watch(localeOverrideProvider)));
  final async = ref.watch(shopProfileProvider);
  return async.maybeWhen(
    data: (s) => effectiveShopProfile(s, l10n).name.trim(),
    orElse: () => l10n.defaultShopName,
  );
});
