import 'package:flutter/material.dart';

import 'package:pride_v3/core/widgets/shop_identity_header.dart';

/// @deprecated Use [ShopIdentityBannerStrip] or [ShopIdentityHeader].
class ShopBannerImage extends StatelessWidget {
  const ShopBannerImage({
    super.key,
    this.bannerRelativePath,
    this.logoRelativePath,
    this.shopName = '',
    this.maxHeight = 140,
  });

  final String? bannerRelativePath;
  final String? logoRelativePath;
  final String shopName;
  final double maxHeight;

  @override
  Widget build(BuildContext context) {
    return ShopIdentityBannerStrip(
      shopName: shopName,
      logoRelativePath: logoRelativePath,
      bannerRelativePath: bannerRelativePath,
      maxHeight: maxHeight,
    );
  }
}
