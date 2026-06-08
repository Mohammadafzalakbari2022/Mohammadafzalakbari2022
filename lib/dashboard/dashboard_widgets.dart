import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';

import '../data/local/payment_summary.dart';

/// Bordered section card used throughout the dashboard drawer.
class DashboardSection extends StatelessWidget {
  const DashboardSection({
    super.key,
    required this.title,
    required this.child,
    this.icon,
    this.colorIndex = 0,
    this.trailing,
  });

  final String title;
  final Widget child;
  final IconData? icon;
  final int colorIndex;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final accent = prideSettingsIconColor(colorIndex);

    return Container(
      decoration: BoxDecoration(
        color: scheme.surfaceContainerLowest,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: scheme.outlineVariant.withValues(alpha: 0.65),
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            padding: const EdgeInsets.fromLTRB(14, 12, 14, 10),
            decoration: BoxDecoration(
              color: accent.withValues(alpha: 0.08),
              border: Border(
                bottom: BorderSide(
                  color: scheme.outlineVariant.withValues(alpha: 0.5),
                ),
              ),
            ),
            child: Row(
              children: [
                if (icon != null) ...[
                  PrideColoredLeading(icon: icon!, color: accent),
                  const SizedBox(width: 10),
                ],
                Expanded(
                  child: Text(
                    title,
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: scheme.onSurface,
                        ),
                  ),
                ),
                // ignore: use_null_aware_elements -- isar_generator cannot parse `?trailing`.
                if (trailing != null) trailing!,
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(14),
            child: child,
          ),
        ],
      ),
    );
  }
}

/// Gradient header for the dashboard drawer.
class DashboardHeader extends StatelessWidget {
  const DashboardHeader({
    super.key,
    required this.title,
    required this.subtitle,
    required this.onClose,
  });

  final String title;
  final String subtitle;
  final VoidCallback onClose;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(20, 16, 8, 20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: AlignmentDirectional.topStart,
          end: AlignmentDirectional.bottomEnd,
          colors: [
            scheme.primary,
            scheme.primary.withValues(alpha: 0.82),
            scheme.secondary.withValues(alpha: 0.9),
          ],
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 48,
            height: 48,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: scheme.onPrimary.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(
              Icons.space_dashboard_rounded,
              color: scheme.onPrimary,
              size: 28,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                        color: scheme.onPrimary,
                        fontWeight: FontWeight.w800,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: scheme.onPrimary.withValues(alpha: 0.9),
                      ),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: onClose,
            icon: Icon(Icons.close, color: scheme.onPrimary),
            tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
          ),
        ],
      ),
    );
  }
}

/// KPI tile with accent border and icon.
class DashboardKpiTile extends StatelessWidget {
  const DashboardKpiTile({
    super.key,
    required this.title,
    required this.value,
    required this.icon,
    required this.color,
    required this.onTap,
  });

  final String title;
  final String value;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;

    return Material(
      color: color.withValues(alpha: 0.06),
      borderRadius: BorderRadius.circular(14),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: color.withValues(alpha: 0.35)),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Row(
                children: [
                  Icon(icon, size: 18, color: color),
                  const Spacer(),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 12,
                    color: scheme.onSurfaceVariant.withValues(alpha: 0.6),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                value,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.w800,
                      color: color,
                    ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: Theme.of(context).textTheme.labelMedium?.copyWith(
                      color: scheme.onSurfaceVariant,
                      fontWeight: FontWeight.w600,
                    ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Horizontal stacked bar for new / in-progress / ready counts.
class DashboardOrderPipelineChart extends StatelessWidget {
  const DashboardOrderPipelineChart({
    super.key,
    required this.newCount,
    required this.inProgressCount,
    required this.readyCount,
    required this.newLabel,
    required this.inProgressLabel,
    required this.readyLabel,
  });

  final int newCount;
  final int inProgressCount;
  final int readyCount;
  final String newLabel;
  final String inProgressLabel;
  final String readyLabel;

  static const _newColor = Color(0xFF7C3AED);
  static const _progressColor = Color(0xFF2563EB);
  static const _readyColor = Color(0xFF059669);

  @override
  Widget build(BuildContext context) {
    final total = newCount + inProgressCount + readyCount;
    if (total == 0) {
      return Text(
        '—',
        style: Theme.of(context).textTheme.bodyLarge,
      );
    }

    Widget segment(int count, Color color) {
      if (count == 0) return const SizedBox.shrink();
      return Expanded(
        flex: count,
        child: Tooltip(
          message: '$count',
          child: Container(
            height: 14,
            color: color,
          ),
        ),
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(8),
          child: Row(
            children: [
              segment(newCount, _newColor),
              segment(inProgressCount, _progressColor),
              segment(readyCount, _readyColor),
            ],
          ),
        ),
        const SizedBox(height: 12),
        Wrap(
          spacing: 12,
          runSpacing: 6,
          children: [
            _LegendDot(color: _newColor, label: '$newLabel ($newCount)'),
            _LegendDot(
              color: _progressColor,
              label: '$inProgressLabel ($inProgressCount)',
            ),
            _LegendDot(color: _readyColor, label: '$readyLabel ($readyCount)'),
          ],
        ),
      ],
    );
  }
}

class _LegendDot extends StatelessWidget {
  const _LegendDot({required this.color, required this.label});

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(label, style: Theme.of(context).textTheme.labelSmall),
      ],
    );
  }
}

/// Last 7 calendar days of payment totals (mini bar chart).
class DashboardRecentIncomeBars extends StatelessWidget {
  const DashboardRecentIncomeBars({super.key, required this.payments});

  final List<PaymentSummary> payments;

  static const double _height = 88;

  List<MapEntry<DateTime, int>> _lastSevenDays() {
    final today = DateTime.now();
    final start = DateTime(today.year, today.month, today.day)
        .subtract(const Duration(days: 6));
    final map = <DateTime, int>{};
    for (var i = 0; i < 7; i++) {
      final d = start.add(Duration(days: i));
      map[d] = 0;
    }
    for (final p in payments) {
      final k = DateTime(p.createdAt.year, p.createdAt.month, p.createdAt.day);
      if (map.containsKey(k)) {
        map[k] = (map[k] ?? 0) + p.amountMinor;
      }
    }
    return map.entries.toList();
  }

  @override
  Widget build(BuildContext context) {
    final entries = _lastSevenDays();
    final maxV = entries.fold<int>(0, (m, e) => e.value > m ? e.value : m);
    final scheme = Theme.of(context).colorScheme;

    return SizedBox(
      height: _height,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          for (final e in entries)
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 2),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Align(
                        alignment: Alignment.bottomCenter,
                        child: Container(
                          width: double.infinity,
                          height: maxV == 0
                              ? 4
                              : (_height * 0.75 * (e.value / maxV))
                                  .clamp(4.0, _height * 0.75),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              colors: [
                                scheme.secondary,
                                scheme.secondaryContainer,
                              ],
                            ),
                            borderRadius: BorderRadius.circular(6),
                            border: Border.all(
                              color: scheme.secondary.withValues(alpha: 0.35),
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${e.key.day}',
                      style: Theme.of(context).textTheme.labelSmall?.copyWith(
                            color: scheme.onSurfaceVariant,
                          ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Styled quick-link chip for the dashboard.
class DashboardQuickLinkChip extends StatelessWidget {
  const DashboardQuickLinkChip({
    super.key,
    required this.label,
    required this.icon,
    required this.color,
    required this.onPressed,
  });

  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onPressed;

  @override
  Widget build(BuildContext context) {
    return ActionChip(
      avatar: Icon(icon, size: 16, color: color),
      label: Text(label),
      labelStyle: Theme.of(context).textTheme.labelMedium?.copyWith(
            color: Theme.of(context).colorScheme.onSurface,
            fontWeight: FontWeight.w600,
          ),
      backgroundColor: color.withValues(alpha: 0.1),
      side: BorderSide(color: color.withValues(alpha: 0.35)),
      onPressed: onPressed,
    );
  }
}
