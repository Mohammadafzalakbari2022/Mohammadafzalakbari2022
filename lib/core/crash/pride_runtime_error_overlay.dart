import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'pride_error_collector.dart';

/// Full-screen fallback when a widget fails to build (release builds).
Widget prideBuildFatalErrorWidget(FlutterErrorDetails details) {
  final text = details.exceptionAsString();
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
            const Text(
              'Widget build failed',
              textAlign: TextAlign.center,
              style: TextStyle(
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

/// On-device banner + dialog for the most recent captured error.
class PrideRuntimeErrorOverlay extends StatefulWidget {
  const PrideRuntimeErrorOverlay({required this.child, super.key});

  final Widget child;

  @override
  State<PrideRuntimeErrorOverlay> createState() =>
      _PrideRuntimeErrorOverlayState();
}

class _PrideRuntimeErrorOverlayState extends State<PrideRuntimeErrorOverlay> {
  Map<String, dynamic>? _shown;

  @override
  void initState() {
    super.initState();
    _shown = PrideErrorCollector.lastEntry;
    PrideErrorCollector.latestError.addListener(_onLatestError);
  }

  @override
  void dispose() {
    PrideErrorCollector.latestError.removeListener(_onLatestError);
    super.dispose();
  }

  void _onLatestError() {
    final next = PrideErrorCollector.latestError.value;
    if (next == null) return;
    setState(() => _shown = next);
  }

  Future<void> _openDetails() async {
    final entry = _shown;
    if (entry == null || !mounted) return;
    await showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('App error log'),
        content: SingleChildScrollView(
          child: SelectableText(PrideErrorCollector.formatEntry(entry)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final entry = _shown;
    return Stack(
      fit: StackFit.expand,
      children: [
        widget.child,
        if (entry != null)
          Positioned(
            left: 8,
            right: 8,
            bottom: 8,
            child: Material(
              elevation: 6,
              color: const Color(0xFF991B1B),
              borderRadius: BorderRadius.circular(10),
              child: InkWell(
                onTap: _openDetails,
                borderRadius: BorderRadius.circular(10),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                    vertical: 10,
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
                      const Icon(Icons.chevron_right, color: Colors.white70),
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
