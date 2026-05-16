import 'package:flutter/material.dart';

import '../../app/app_theme.dart';

/// Card + list row with a colored icon circle — same pattern as Settings tiles.
class PrideNavCardTile extends StatelessWidget {
  const PrideNavCardTile({
    super.key,
    required this.icon,
    required this.colorIndex,
    required this.title,
    this.subtitle,
    this.onTap,
    this.showChevron = true,
  });

  final IconData icon;
  final int colorIndex;
  final String title;
  final String? subtitle;
  final VoidCallback? onTap;
  final bool showChevron;

  @override
  Widget build(BuildContext context) {
    final color = prideSettingsIconColor(colorIndex);
    return Card(
      child: ListTile(
        leading: PrideColoredLeading(icon: icon, color: color),
        title: Text(title),
        subtitle: subtitle != null ? Text(subtitle!) : null,
        trailing: showChevron && onTap != null
            ? Icon(Icons.chevron_right, color: color.withValues(alpha: 0.7))
            : null,
        onTap: onTap,
      ),
    );
  }
}
