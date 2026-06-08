import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/shop_identity_header.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';

/// Compact shop identity for the main shell app bar.
class ShellAppBarBranding extends ConsumerWidget {
  const ShellAppBarBranding({
    super.key,
    required this.shopName,
    required this.onTap,
  });

  final String shopName;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final shop = ref.watch(shopProfileProvider).valueOrNull;

    return ShopIdentityHeader(
      variant: ShopIdentityVariant.compact,
      shopName: shopName,
      logoRelativePath: shop?.logoRelativePath,
      bannerRelativePath: shop?.bannerRelativePath,
      onTap: onTap,
    );
  }
}
