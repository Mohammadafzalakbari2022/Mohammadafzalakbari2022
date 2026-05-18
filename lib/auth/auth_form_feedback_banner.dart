import 'package:flutter/material.dart';

/// Inline status above auth forms — loading progress or a single error line.
class AuthFormFeedbackBanner extends StatelessWidget {
  const AuthFormFeedbackBanner({
    super.key,
    this.loadingTitle,
    this.loadingHint,
    this.errorMessage,
  }) : assert(
          (loadingTitle != null) != (errorMessage != null),
          'Show either loading or error, not both',
        );

  final String? loadingTitle;
  final String? loadingHint;
  final String? errorMessage;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;

    if (loadingTitle != null) {
      return Card(
        elevation: 0,
        color: scheme.primaryContainer,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: scheme.onPrimaryContainer,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Text(
                      loadingTitle!,
                      style: theme.textTheme.titleSmall?.copyWith(
                        color: scheme.onPrimaryContainer,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: LinearProgressIndicator(
                  minHeight: 4,
                  backgroundColor: scheme.onPrimaryContainer.withValues(
                    alpha: 0.2,
                  ),
                  color: scheme.primary,
                ),
              ),
              if (loadingHint != null && loadingHint!.isNotEmpty) ...[
                const SizedBox(height: 10),
                Text(
                  loadingHint!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: scheme.onPrimaryContainer.withValues(alpha: 0.9),
                  ),
                ),
              ],
            ],
          ),
        ),
      );
    }

    return Card(
      elevation: 0,
      color: scheme.errorContainer,
      child: ListTile(
        leading: Icon(
          Icons.error_outline_rounded,
          color: scheme.onErrorContainer,
        ),
        title: Text(
          errorMessage!,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: scheme.onErrorContainer,
            fontWeight: FontWeight.w500,
          ),
        ),
      ),
    );
  }
}
