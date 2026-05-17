import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'app_guide_copy.dart';
import 'app_guide_providers.dart';

/// Bottom tip card with skip, close, and got-it actions.
class AppGuideBanner extends ConsumerWidget {
  const AppGuideBanner({
    super.key,
    required this.guideId,
  });

  final String guideId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context)!;
    final copy = appGuideCopyFor(l10n, guideId);
    if (copy == null) return const SizedBox.shrink();

    final scheme = Theme.of(context).colorScheme;
    final notifier = ref.read(appGuideStateProvider.notifier);

    return Material(
      elevation: 8,
      color: scheme.primaryContainer,
      child: SafeArea(
        top: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 12, 8, 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.lightbulb_outline,
                    color: scheme.onPrimaryContainer,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          copy.title,
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(
                                fontWeight: FontWeight.w700,
                                color: scheme.onPrimaryContainer,
                              ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          copy.body,
                          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                                color: scheme.onPrimaryContainer
                                    .withValues(alpha: 0.92),
                              ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: l10n.appGuideCloseTooltip,
                    onPressed: () => notifier.dismissPage(guideId),
                    icon: Icon(
                      Icons.close,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Wrap(
                alignment: WrapAlignment.end,
                spacing: 8,
                runSpacing: 4,
                children: [
                  TextButton(
                    onPressed: () => notifier.disablePermanently(),
                    child: Text(l10n.appGuideSkipAll),
                  ),
                  FilledButton.tonal(
                    onPressed: () => notifier.dismissPage(guideId),
                    child: Text(l10n.appGuideGotIt),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
