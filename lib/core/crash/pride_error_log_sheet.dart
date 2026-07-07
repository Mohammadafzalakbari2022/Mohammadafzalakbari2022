import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import 'pride_error_collector.dart';

/// Modal sheet to view, copy, share, or clear the on-device error log.
Future<void> showPrideErrorLogSheet(BuildContext context) async {
  final l10n = AppLocalizations.of(context)!;
  final entries = PrideErrorCollector.snapshot();
  if (entries.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(l10n.errorLogEmpty)),
    );
    return;
  }

  final report = PrideErrorCollector.formatFullReport();

  await showModalBottomSheet<void>(
    context: context,
    isScrollControlled: true,
    showDragHandle: true,
    builder: (sheetContext) {
      final bottom = MediaQuery.paddingOf(sheetContext).bottom;
      return SafeArea(
        child: Padding(
          padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                l10n.errorLogTitle,
                style: Theme.of(sheetContext).textTheme.titleLarge,
              ),
              const SizedBox(height: 8),
              Flexible(
                child: SingleChildScrollView(
                  child: SelectableText(
                    report,
                    style: const TextStyle(fontSize: 12, height: 1.35),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.end,
                children: [
                  TextButton(
                    onPressed: () async {
                      await Clipboard.setData(ClipboardData(text: report));
                      if (sheetContext.mounted) {
                        ScaffoldMessenger.of(sheetContext).showSnackBar(
                          SnackBar(content: Text(l10n.errorLogCopied)),
                        );
                      }
                    },
                    child: Text(l10n.errorLogCopy),
                  ),
                  TextButton(
                    onPressed: () => Share.share(report),
                    child: Text(l10n.errorLogShare),
                  ),
                  TextButton(
                    onPressed: () async {
                      await PrideErrorCollector.clear();
                      if (sheetContext.mounted) {
                        Navigator.of(sheetContext).pop();
                      }
                    },
                    child: Text(l10n.errorLogClearAll),
                  ),
                  FilledButton(
                    onPressed: () => Navigator.of(sheetContext).pop(),
                    child: Text(l10n.errorLogClose),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}
