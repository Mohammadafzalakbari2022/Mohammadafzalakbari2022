import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pride_v3/core/defaults/effective_shop_profile.dart';
import 'package:pride_v3/core/widgets/shop_logo_image.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Shop name + logo row for dashboard and similar surfaces.
class ShopBrandingHeader extends ConsumerWidget {
  const ShopBrandingHeader({
    super.key,
    this.onClose,
    this.trailing,
  });

  final VoidCallback? onClose;
  final Widget? trailing;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final scheme = Theme.of(context).colorScheme;
    final shopAsync = ref.watch(shopProfileProvider);

    final shop = shopAsync.valueOrNull;
    final effective = effectiveShopProfile(shop, l10n);
    final name = effective.name.trim();

    return Material(
      color: scheme.primaryContainer,
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(8, 8, 8, 12),
          child: Row(
            children: [
              if (onClose != null)
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: onClose,
                  tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                ),
              Expanded(
                child: InkWell(
                  onTap: () => context.push('/app/settings/shop'),
                  borderRadius: BorderRadius.circular(12),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 4,
                    ),
                    child: Row(
                      children: [
                        ShopLogoImage(
                          logoRelativePath: shop?.logoRelativePath,
                          size: 44,
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            name,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(
                                  fontWeight: FontWeight.w700,
                                  color: scheme.onPrimaryContainer,
                                ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                        Icon(
                          Directionality.of(context) == TextDirection.rtl
                              ? Icons.chevron_left
                              : Icons.chevron_right,
                          color: scheme.onPrimaryContainer.withValues(
                            alpha: 0.7,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              // ignore: use_null_aware_elements -- isar_generator cannot parse `?trailing`.
              if (trailing != null) trailing!,
            ],
          ),
        ),
      ),
    );
  }
}
