import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/core/crash/pride_error_collector.dart';
import 'package:pride_v3/core/crash/pride_error_log_sheet.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Settings list tile for the on-device error log with a live entry count badge.
class SettingsErrorLogTile extends StatelessWidget {
  const SettingsErrorLogTile({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return ListenableBuilder(
      listenable: PrideErrorCollector.latestError,
      builder: (context, _) {
        final count = PrideErrorCollector.snapshot().length;
        return ListTile(
          leading: PrideColoredLeading(
            icon: Icons.bug_report_outlined,
            color: prideSettingsIconColor(5),
          ),
          title: Text(l10n.settingsDiagnosticsErrorLogTile),
          subtitle: Text(l10n.settingsDiagnosticsErrorLogSubtitle),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (count > 0)
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.errorContainer,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    '$count',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color:
                              Theme.of(context).colorScheme.onErrorContainer,
                          fontWeight: FontWeight.w700,
                        ),
                  ),
                ),
              if (count > 0) const SizedBox(width: 4),
              Icon(
                Icons.chevron_right,
                color: prideSettingsIconColor(5).withValues(alpha: 0.7),
              ),
            ],
          ),
          onTap: () => showPrideErrorLogSheet(context),
        );
      },
    );
  }
}
