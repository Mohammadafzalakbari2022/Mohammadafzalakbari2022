import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/core/widgets/shop_logo_image.dart';
import 'package:pride_v3/features/settings/shop_profile_provider.dart';

/// Shop logo + name for the main shell app bar.
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
    final shopAsync = ref.watch(shopProfileProvider);
    final logoPath = shopAsync.valueOrNull?.logoRelativePath;

    final title = Text(
      shopName,
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );

    final row = Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        ShopLogoImage(
          logoRelativePath: logoPath,
          size: 32,
          borderRadius: 8,
        ),
        const SizedBox(width: 10),
        Flexible(child: title),
      ],
    );

    if (onTap == null) return row;

    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(8),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: row,
      ),
    );
  }
}
