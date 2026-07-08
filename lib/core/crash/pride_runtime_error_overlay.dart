import 'dart:async';

import 'package:flutter/material.dart';

import 'package:pride_v3/l10n/app_localizations.dart';

import 'pride_error_collector.dart';

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

/// Wraps the app tree; errors are collected silently via [PrideErrorCollector].
/// View the log from Settings.
class PrideRuntimeErrorOverlay extends StatelessWidget {
  const PrideRuntimeErrorOverlay({required this.child, super.key});

  final Widget child;

  @override
  Widget build(BuildContext context) => child;
}
