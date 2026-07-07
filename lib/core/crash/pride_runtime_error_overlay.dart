import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pride_v3/l10n/app_localizations.dart';
import 'package:share_plus/share_plus.dart';

import 'pride_error_collector.dart';
import 'pride_error_log_sheet.dart';

/// Full-screen fallback when a widget fails to build (release builds).
Widget prideBuildFatalErrorWidget(FlutterErrorDetails details) {
  final text = details.exceptionAsString();
  final l10n = lookupAppLocalizations(const Locale('fa'));
  unawaited(PrideErrorCollector.record(
    details.exception,
    stack: details.stack,
    source: 'error_widget',
    fatal: true,
  ));
  return Material(
    color: const Color(0xFF12131A),
    child: SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Icon(
              Icons.error_outline_rounded,
              color: Color(0xFFF87171),
              size: 40,
            ),
            const SizedBox(height: 12),
            Text(
              l10n.errorWidgetBuildFailedTitle,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFFE8EDF4),
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),
            Expanded(
              child: SingleChildScrollView(
                child: SelectableText(
                  text,
                  style: const TextStyle(
                    color: Color(0xFF94A3B8),
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

/// On-device banner + sheet for captured errors (copy / share for support).
class PrideRuntimeErrorOverlay extends StatefulWidget {
  const PrideRuntimeErrorOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<PrideRuntimeErrorOverlay> createState() =>
      _PrideRuntimeErrorOverlayState();
}

class _PrideRuntimeErrorOverlayState extends State<PrideRuntimeErrorOverlay> {
  Map<String, dynamic>? _shown;
  final Set<String> _dismissedKeys = {};

  @override
  void initState() {
    super.initState();
    _shown = _visibleEntry(PrideErrorCollector.lastEntry);
    PrideErrorCollector.latestError.addListener(_onLatestError);
  }

  @override
  void dispose() {
    PrideErrorCollector.latestError.removeListener(_onLatestError);
    super.dispose();
  }

  Map<String, dynamic>? _visibleEntry(Map<String, dynamic>? entry) {
    if (entry == null) return null;
    final key = PrideErrorCollector.entryKey(entry);
    if (_dismissedKeys.contains(key)) return null;
    return entry;
  }

  void _onLatestError() {
    final next = _visibleEntry(PrideErrorCollector.latestError.value);
    setState(() => _shown = next);
  }

  void _dismissCurrent() {
    final entry = _shown;
    if (entry == null) return;
    setState(() {
      _dismissedKeys.add(PrideErrorCollector.entryKey(entry));
      _shown = null;
    });
  }

  Future<void> _copyText(String text, String copiedMessage) async {
    await Clipboard.setData(ClipboardData(text: text));
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(copiedMessage)),
    );
  }

  Future<void> _openDetails() async {
    final entry = _shown;
    if (entry == null || !mounted) return;
    final l10n = AppLocalizations.of(context)!;
    final text = PrideErrorCollector.formatEntry(entry);

    await showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      showDragHandle: true,
      builder: (context) {
        final bottom = MediaQuery.paddingOf(context).bottom;
        return SafeArea(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 8, 16, 16 + bottom),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Text(
                  l10n.errorLogTitle,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Flexible(
                  child: SingleChildScrollView(
                    child: SelectableText(
                      text,
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
                        await _copyText(text, l10n.errorLogCopied);
                      },
                      child: Text(l10n.errorLogCopy),
                    ),
                    TextButton(
                      onPressed: () => Share.share(text),
                      child: Text(l10n.errorLogShare),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        _dismissCurrent();
                      },
                      child: Text(l10n.errorLogDismiss),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        unawaited(showPrideErrorLogSheet(this.context));
                      },
                      child: Text(l10n.errorLogViewAll),
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

  @override
  Widget build(BuildContext context) {
    final entry = _shown;
    final topInset = MediaQuery.paddingOf(context).top;
    final l10n = AppLocalizations.of(context)!;

    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (entry != null)
          Positioned(
            left: 8,
            right: 8,
            top: topInset + 8,
            child: Material(
              elevation: 6,
              color: const Color(0xFF991B1B),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _openDetails,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 8,
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.bug_report_outlined,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          '${entry['type']}: ${entry['message']}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.errorLogViewAll,
                        onPressed: () => showPrideErrorLogSheet(context),
                        icon: const Icon(
                          Icons.list_alt_outlined,
                          color: Colors.white70,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                      IconButton(
                        tooltip: l10n.errorLogDismiss,
                        onPressed: _dismissCurrent,
                        icon: const Icon(
                          Icons.close,
                          color: Colors.white70,
                          size: 20,
                        ),
                        padding: EdgeInsets.zero,
                        constraints: const BoxConstraints(
                          minWidth: 32,
                          minHeight: 32,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
      ],
    );
  }
}
