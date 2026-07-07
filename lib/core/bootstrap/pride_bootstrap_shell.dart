import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:share_plus/share_plus.dart';

import 'package:pride_v3/core/branding/app_branding.dart';
import 'package:pride_v3/core/crash/pride_error_collector.dart';
import 'package:pride_v3/core/crash/pride_error_log_sheet.dart';
import 'package:pride_v3/core/crash/pride_runtime_error_overlay.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Minimal [MaterialApp] used only while cold-start work runs.
class PrideBootstrapMaterialHost extends StatelessWidget {
  const PrideBootstrapMaterialHost({required this.child, super.key});

  final Widget child;

  static const _surface = Color(0xFF12131A);
  static const _primary = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      locale: const Locale('fa'),
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7C3AED),
          brightness: Brightness.dark,
          surface: _surface,
        ),
        scaffoldBackgroundColor: _surface,
        progressIndicatorTheme: const ProgressIndicatorThemeData(
          color: _primary,
        ),
        useMaterial3: true,
      ),
      builder: (context, appChild) => PrideRuntimeErrorOverlay(
        child: appChild ?? const SizedBox.shrink(),
      ),
      home: child,
    );
  }
}

/// Paints on the first Flutter frame — no l10n, no assets, no async deps.
class PrideBootstrapLoadingView extends StatelessWidget {
  const PrideBootstrapLoadingView({super.key});

  static const _surface = Color(0xFF12131A);
  static const _primary = Color(0xFFA78BFA);

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: _surface,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.storefront_rounded, size: 88, color: _primary),
            SizedBox(height: 28),
            SizedBox(
              width: 36,
              height: 36,
              child: CircularProgressIndicator(
                strokeWidth: 3,
                color: _primary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Shown when cold-start initialization fails instead of a blank black screen.
class PrideBootstrapErrorView extends StatelessWidget {
  const PrideBootstrapErrorView({
    required this.error,
    required this.onRetry,
    super.key,
  });

  final Object error;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);

    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Spacer(),
              Icon(
                Icons.error_outline_rounded,
                size: 48,
                color: theme.colorScheme.error,
              ),
              const SizedBox(height: 16),
              Text(
                l10n.startupFailedTitle,
                style: theme.textTheme.titleLarge,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              Text(
                l10n.startupFailedHint,
                style: theme.textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              SelectableText(
                error.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              Wrap(
                alignment: WrapAlignment.center,
                spacing: 8,
                runSpacing: 8,
                children: [
                  OutlinedButton.icon(
                    onPressed: () async {
                      final text = PrideErrorCollector.formatFullReport().isNotEmpty
                          ? PrideErrorCollector.formatFullReport()
                          : error.toString();
                      await Clipboard.setData(ClipboardData(text: text));
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text(l10n.errorLogCopied)),
                        );
                      }
                    },
                    icon: const Icon(Icons.copy_outlined, size: 18),
                    label: Text(l10n.errorLogCopy),
                  ),
                  OutlinedButton.icon(
                    onPressed: () {
                      final text = PrideErrorCollector.formatFullReport().isNotEmpty
                          ? PrideErrorCollector.formatFullReport()
                          : error.toString();
                      Share.share(text);
                    },
                    icon: const Icon(Icons.share_outlined, size: 18),
                    label: Text(l10n.errorLogShare),
                  ),
                  TextButton(
                    onPressed: () => showPrideErrorLogSheet(context),
                    child: Text(l10n.errorLogViewAll),
                  ),
                ],
              ),
              const Spacer(),
              FilledButton(
                onPressed: onRetry,
                child: Text(l10n.startupRetry),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Placeholder while [GoRouter] has not produced a page yet (avoids black flash).
class PrideRouterPlaceholder extends StatelessWidget {
  const PrideRouterPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    final side = (MediaQuery.sizeOf(context).width * 0.4).clamp(120.0, 180.0);
    return ColoredBox(
      color: Theme.of(context).scaffoldBackgroundColor,
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Image.asset(
              kLoginBrandLogoAsset,
              width: side,
              height: side,
              fit: BoxFit.contain,
              errorBuilder: (context, error, stackTrace) => Icon(
                Icons.storefront_rounded,
                size: side * 0.55,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
            const SizedBox(height: 24),
            const SizedBox(
              width: 32,
              height: 32,
              child: CircularProgressIndicator(strokeWidth: 3),
            ),
          ],
        ),
      ),
    );
  }
}
