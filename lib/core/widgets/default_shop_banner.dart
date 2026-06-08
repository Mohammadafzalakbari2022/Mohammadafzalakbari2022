import 'dart:math' as math;

import 'package:flutter/material.dart';

import 'package:pride_v3/core/widgets/shop_logo_image.dart';

/// Branded default shop banner (~3:1) when no uploaded banner is available.
class DefaultShopBanner extends StatelessWidget {
  const DefaultShopBanner({
    super.key,
    required this.shopName,
    this.logoRelativePath,
    this.maxHeight = 120,
    this.borderRadius = 12,
    this.compact = false,
    this.showShopNameText = true,
  });

  final String shopName;
  final String? logoRelativePath;
  final double maxHeight;
  final double borderRadius;
  final bool compact;
  final bool showShopNameText;

  static const double kAspectRatio = 3;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final name = shopName.trim().isEmpty ? ' ' : shopName.trim();
    final logoSize = compact ? 36.0 : 52.0;
    final screenWidth = MediaQuery.sizeOf(context).width;

    return LayoutBuilder(
      builder: (context, constraints) {
        final maxW = constraints.maxWidth.isFinite && constraints.maxWidth > 0
            ? constraints.maxWidth
            : screenWidth;
        final naturalHeight = maxW / kAspectRatio;
        final minH = compact ? 40.0 : 64.0;
        final effectiveMin = math.min(minH, maxHeight);
        final height = naturalHeight.clamp(effectiveMin, maxHeight);

        return SizedBox(
          width: double.infinity,
          height: height,
          child: DecoratedBox(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(borderRadius),
              gradient: LinearGradient(
                begin: AlignmentDirectional.centerStart,
                end: AlignmentDirectional.centerEnd,
                colors: [
                  scheme.primary,
                  const Color(0xFF6D28D9),
                  scheme.secondary.withValues(alpha: 0.85),
                ],
              ),
              border: Border.all(
                color: scheme.outlineVariant.withValues(alpha: 0.45),
              ),
              boxShadow: [
                BoxShadow(
                  color: scheme.primary.withValues(alpha: 0.18),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(borderRadius),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  PositionedDirectional(
                    end: -24,
                    top: -18,
                    child: Icon(
                      Icons.content_cut,
                      size: height * 0.9,
                      color: Colors.white.withValues(alpha: 0.08),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsetsDirectional.fromSTEB(
                      compact ? 10 : 14,
                      compact ? 6 : 10,
                      compact ? 10 : 14,
                      compact ? 6 : 10,
                    ),
                    child: showShopNameText
                        ? Row(
                            children: [
                              ShopLogoImage(
                                logoRelativePath: logoRelativePath,
                                size: logoSize,
                                borderRadius: compact ? 8 : 10,
                              ),
                              SizedBox(width: compact ? 8 : 12),
                              Expanded(
                                child: Text(
                                  name,
                                  maxLines: compact ? 1 : 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: (compact
                                          ? theme.textTheme.titleSmall
                                          : theme.textTheme.titleMedium)
                                      ?.copyWith(
                                    color: scheme.onPrimary,
                                    fontWeight: FontWeight.w800,
                                    height: 1.15,
                                  ),
                                ),
                              ),
                            ],
                          )
                        : const SizedBox.shrink(),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

/// Minimal logo + name row when banner rendering is not possible.
class ShopLogoNameFallback extends StatelessWidget {
  const ShopLogoNameFallback({
    super.key,
    required this.shopName,
    this.logoRelativePath,
    this.logoSize = 32,
  });

  final String shopName;
  final String? logoRelativePath;
  final double logoSize;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShopLogoImage(
          logoRelativePath: logoRelativePath,
          size: logoSize,
          borderRadius: 8,
        ),
        const SizedBox(width: 10),
        Flexible(
          child: Text(
            shopName,
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: scheme.onSurface,
            ),
          ),
        ),
      ],
    );
  }
}
