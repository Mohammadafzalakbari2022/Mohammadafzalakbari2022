import 'dart:io';

import 'package:flutter/material.dart';

import 'package:pride_v3/core/widgets/default_shop_banner.dart';
import 'package:pride_v3/core/widgets/shop_banner_file.dart';
import 'package:pride_v3/core/widgets/shop_logo_image.dart';

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

/// Uploaded or default banner strip (~3:1) with logo + full shop name overlay.
class ShopIdentityBannerStrip extends StatelessWidget {
  const ShopIdentityBannerStrip({
    super.key,
    required this.shopName,
    this.logoRelativePath,
    this.bannerRelativePath,
    this.maxHeight = 120,
    this.horizontalPadding = 12,
    this.showShopNameText = true,
    this.compact = false,
  });

  final String shopName;
  final String? logoRelativePath;
  final String? bannerRelativePath;
  final double maxHeight;
  final double horizontalPadding;
  final bool showShopNameText;
  final bool compact;

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
            compact: compact,
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
                compact: compact,
              ),
            );
          }

          final file = snap.data;
          if (file != null) {
            return _UploadedBannerWithOverlay(
              file: file,
              shopName: shopName,
              logoRelativePath: logoRelativePath,
              maxHeight: maxHeight,
              showShopNameText: showShopNameText,
              compact: compact,
            );
          }

          return SizedBox(
            width: double.infinity,
            child: DefaultShopBanner(
              shopName: shopName,
              logoRelativePath: logoRelativePath,
              maxHeight: maxHeight,
              showShopNameText: showShopNameText,
              compact: compact,
            ),
          );
        },
      ),
    );
  }
}

class _UploadedBannerWithOverlay extends StatelessWidget {
  const _UploadedBannerWithOverlay({
    required this.file,
    required this.shopName,
    this.logoRelativePath,
    required this.maxHeight,
    required this.showShopNameText,
    required this.compact,
  });

  final File file;
  final String shopName;
  final String? logoRelativePath;
  final double maxHeight;
  final bool showShopNameText;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final name = shopName.trim().isEmpty ? ' ' : shopName.trim();
    final logoSize = compact ? 48.0 : 72.0;

    return LayoutBuilder(
      builder: (context, constraints) {
        final width = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : MediaQuery.sizeOf(context).width;
        final naturalHeight = width / DefaultShopBanner.kAspectRatio;
        final minH = compact ? 48.0 : 72.0;
        final height = naturalHeight.clamp(minH, maxHeight);

        return SizedBox(
          width: double.infinity,
          height: height,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: Stack(
              fit: StackFit.expand,
              children: [
                Image.file(
                  file,
                  width: double.infinity,
                  height: height,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) =>
                      DefaultShopBanner(
                    shopName: shopName,
                    logoRelativePath: logoRelativePath,
                    maxHeight: maxHeight,
                    showShopNameText: showShopNameText,
                    compact: compact,
                  ),
                ),
                if (showShopNameText)
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          Colors.black.withValues(alpha: 0.55),
                          Colors.black.withValues(alpha: 0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Padding(
                      padding: EdgeInsetsDirectional.fromSTEB(
                        compact ? 10 : 14,
                        compact ? 8 : 12,
                        compact ? 10 : 14,
                        compact ? 8 : 12,
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          ShopLogoImage(
                            logoRelativePath: logoRelativePath,
                            size: logoSize,
                            borderRadius: compact ? 8 : 10,
                            presentation: ShopLogoPresentation.onBanner,
                          ),
                          SizedBox(width: compact ? 10 : 14),
                          Expanded(
                            child: Text(
                              name,
                              softWrap: true,
                              style: (compact
                                      ? theme.textTheme.titleSmall
                                      : theme.textTheme.titleMedium)
                                  ?.copyWith(
                                color: Colors.white,
                                fontWeight: FontWeight.w800,
                                height: 1.2,
                                shadows: const [
                                  Shadow(
                                    blurRadius: 4,
                                    color: Colors.black54,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
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
    final content = ShopIdentityBannerStrip(
      shopName: shopName,
      logoRelativePath: logoRelativePath,
      bannerRelativePath: bannerRelativePath,
      maxHeight: 56,
      horizontalPadding: 0,
      showShopNameText: true,
      compact: true,
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
              maxHeight: 140,
              horizontalPadding: 12,
              showShopNameText: true,
              compact: false,
            ),
          ],
        ),
      ),
    );
  }
}
