import 'package:flutter/material.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

/// Step progress for the new-order composer.
class OrderComposerProgressHeader extends StatelessWidget {
  const OrderComposerProgressHeader({
    super.key,
    required this.l10n,
    required this.customerDone,
    required this.measurementsDone,
    required this.styleDone,
    required this.fabricDone,
    required this.deliveryDone,
    required this.paymentDone,
  });

  final AppLocalizations l10n;
  final bool customerDone;
  final bool measurementsDone;
  final bool styleDone;
  final bool fabricDone;
  final bool deliveryDone;
  final bool paymentDone;

  int get _completedCount => [
        customerDone,
        measurementsDone,
        styleDone,
        fabricDone,
        deliveryDone,
        paymentDone,
      ].where((d) => d).length;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final scheme = theme.colorScheme;
    final steps = [
      _Step(customerDone, l10n.ordersComposerProgressCustomer),
      _Step(measurementsDone, l10n.ordersComposerProgressMeasurements),
      _Step(styleDone, l10n.ordersComposerProgressStyle),
      _Step(fabricDone, l10n.ordersComposerProgressFabric),
      _Step(deliveryDone, l10n.ordersComposerProgressDelivery),
      _Step(paymentDone, l10n.ordersComposerProgressPayment),
    ];
    final progress = _completedCount / steps.length;

    return Card(
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 14, 16, 14),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    l10n.ordersComposerProgressTitle,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                Text(
                  l10n.ordersComposerProgressCount(_completedCount, steps.length),
                  style: theme.textTheme.labelLarge?.copyWith(
                    color: scheme.primary,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ClipRRect(
              borderRadius: BorderRadius.circular(6),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: scheme.surfaceContainerHigh,
                color: scheme.primary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                for (var i = 0; i < steps.length; i++) ...[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: _StepChip(step: steps[i]),
                  ),
                ],
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Step {
  const _Step(this.done, this.label);

  final bool done;
  final String label;
}

class _StepChip extends StatelessWidget {
  const _StepChip({required this.step});

  final _Step step;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    final bg = step.done
        ? scheme.primaryContainer
        : scheme.surfaceContainerHigh;
    final fg = step.done ? scheme.onPrimaryContainer : scheme.onSurfaceVariant;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 200),
      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: step.done
              ? scheme.primary.withValues(alpha: 0.35)
              : scheme.outlineVariant.withValues(alpha: 0.6),
        ),
      ),
      child: Column(
        children: [
          Icon(
            step.done ? Icons.check_circle : Icons.radio_button_unchecked,
            size: 16,
            color: fg,
          ),
          const SizedBox(height: 2),
          Text(
            step.label,
            maxLines: 2,
            textAlign: TextAlign.center,
            overflow: TextOverflow.ellipsis,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontWeight: step.done ? FontWeight.w700 : FontWeight.w500,
                  color: fg,
                  height: 1.05,
                ),
          ),
        ],
      ),
    );
  }
}
