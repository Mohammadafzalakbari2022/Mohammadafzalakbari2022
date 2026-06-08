import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pride_v3/core/widgets/default_shop_banner.dart';
import 'package:pride_v3/core/widgets/shop_banner_file.dart';

/// Where [ShopIdentityHeader] is shown.
enum ShopIdentityVariant {
  compact,
  dashboard,
  settingsPreview,
}

/// Unified shop identity: uploaded banner → default banner → logo + name.
class ShopIdentityHeader extends StatelessWidget {
  const ShopIdentityHeader({
    super.key,
    required this.variant,
    required this.shopName,
    this.logoRelativePath,
    this.bannerRelativePath,
    this.onTap,
    this.onClose,
    this.trailing,
  });

  final ShopIdentityVariant variant;
  final String shopName;
  final String? logoRelativePath;
  final String? bannerRelativePath;
  final VoidCallback? onTap;
  final VoidCallback? onClose;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return switch (variant) {
      ShopIdentityVariant.compact => _CompactIdentity(
          shopName: shopName,
          logoRelativePath: logoRelativePath,
          bannerRelativePath: bannerRelativePath,
          onTap: onTap,
        ),
      ShopIdentityVariant.dashboard => _DashboardIdentity(
          shopName: shopName,
          logoRelativePath: logoRelativePath,
          bannerRelativePath: bannerRelativePath,
          onClose: onClose,
          trailing: trailing,
        ),
      ShopIdentityVariant.settingsPreview => Padding(
          padding: const EdgeInsetsDirectional.only(bottom: 8),
          child: ShopIdentityBannerStrip(
            shopName: shopName,
            logoRelativePath: logoRelativePath,
            bannerRelativePath: bannerRelativePath,
            maxHeight: 120,
          ),
        ),
    };
  }
}

/// Uploaded or default banner strip (~3:1).
class ShopIdentityBannerStrip extends StatelessWidget {
  const ShopIdentityBannerStrip({
    super.key,
    required this.shopName,
    this.logoRelativePath,
    this.bannerRelativePath,
    this.maxHeight = 120,
    this.horizontalPadding = 12,
    this.showShopNameText = true,
  });

  final String shopName;
  final String? logoRelativePath;
  final String? bannerRelativePath;
  final double maxHeight;
  final double horizontalPadding;
  final bool showShopNameText;

  @override
  Widget build(BuildContext context) {
    final padding = EdgeInsetsDirectional.fromSTEB(
      horizontalPadding,
      0,
      horizontalPadding,
      8,
    );

    if (!shopBannerUploadConfigured(bannerRelativePath)) {
      return Padding(
        padding: padding,
        child: SizedBox(
          width: double.infinity,
          child: DefaultShopBanner(
            shopName: shopName,
            logoRelativePath: logoRelativePath,
            maxHeight: maxHeight,
            showShopNameText: showShopNameText,
          ),
        ),
      );
    }

    return Padding(
      padding: padding,
      child: FutureBuilder<File?>(
        future: resolveShopBannerFile(bannerRelativePath),
        builder: (context, snap) {
          if (snap.connectionState == ConnectionState.waiting) {
            return SizedBox(
              width: double.infinity,
              child: DefaultShopBanner(
                shopName: shopName,
                logoRelativePath: logoRelativePath,
                maxHeight: maxHeight,
                showShopNameText: showShopNameText,
              ),
            );
          }

          final file = snap.data;
          if (file != null) {
            return SizedBox(
              width: double.infinity,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.file(
                  file,
                  width: double.infinity,
                  height: maxHeight,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => DefaultShopBanner(
                    shopName: shopName,
                    logoRelativePath: logoRelativePath,
                    maxHeight: maxHeight,
                    showShopNameText: showShopNameText,
                  ),
                ),
              ),
            );
          }

          return SizedBox(
            width: double.infinity,
            child: DefaultShopBanner(
              shopName: shopName,
              logoRelativePath: logoRelativePath,
              maxHeight: maxHeight,
              showShopNameText: showShopNameText,
            ),
          );
        },
      ),
    );
  }
}

class _CompactIdentity extends StatelessWidget {
  const _CompactIdentity({
    required this.shopName,
    this.logoRelativePath,
    this.bannerRelativePath,
    this.onTap,
  });

  final String shopName;
  final String? logoRelativePath;
  final String? bannerRelativePath;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final content = ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 280, minWidth: 120),
      child: ShopIdentityBannerStrip(
        shopName: shopName,
        logoRelativePath: logoRelativePath,
        bannerRelativePath: bannerRelativePath,
        maxHeight: 44,
        horizontalPadding: 0,
        showShopNameText: true,
      ),
    );

    if (onTap == null) return content;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: content,
    );
  }
}

class _DashboardIdentity extends StatelessWidget {
  const _DashboardIdentity({
    required this.shopName,
    this.logoRelativePath,
    this.bannerRelativePath,
    this.onClose,
    this.trailing,
  });

  final String shopName;
  final String? logoRelativePath;
  final String? bannerRelativePath;
  final VoidCallback? onClose;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: scheme.primaryContainer,
      child: SafeArea(
        bottom: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsetsDirectional.fromSTEB(4, 4, 4, 0),
              child: Row(
                children: [
                  if (onClose != null)
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: onClose,
                      tooltip:
                          MaterialLocalizations.of(context).closeButtonTooltip,
                    ),
                  const Spacer(),
                  // ignore: use_null_aware_elements -- isar_generator cannot parse `?trailing`.
                  if (trailing != null) trailing!,
                ],
              ),
            ),
            ShopIdentityBannerStrip(
              shopName: shopName,
              logoRelativePath: logoRelativePath,
              bannerRelativePath: bannerRelativePath,
              horizontalPadding: 12,
              showShopNameText: false,
            ),
          ],
        ),
      ),
    );
  }
}
