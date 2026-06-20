import 'package:flutter/material.dart';

/// Soft-red background for optional fields left empty (receipt composer).
Color prideOptionalEmptyFillColor(BuildContext context) {
  return Theme.of(context).colorScheme.error.withValues(alpha: 0.10);
}

/// Merges [base] with an empty-state fill color when [isEmpty] is true.
InputDecoration prideOptionalDecoration(
  BuildContext context, {
  required InputDecoration base,
  required bool isEmpty,
}) {
  if (!isEmpty) return base;
  return base.copyWith(
    filled: true,
    fillColor: prideOptionalEmptyFillColor(context),
  );
}

/// Wraps [child] with a soft-red panel background when [isEmpty].
class PrideOptionalPanel extends StatelessWidget {
  const PrideOptionalPanel({
    super.key,
    required this.isEmpty,
    required this.child,
    this.padding = const EdgeInsets.all(12),
    this.borderRadius = const BorderRadius.all(Radius.circular(8)),
  });

  final bool isEmpty;
  final Widget child;
  final EdgeInsets padding;
  final BorderRadius borderRadius;

  @override
  Widget build(BuildContext context) {
    if (!isEmpty) return child;
    return DecoratedBox(
      decoration: BoxDecoration(
        color: prideOptionalEmptyFillColor(context),
        borderRadius: borderRadius,
      ),
      child: Padding(padding: padding, child: child),
    );
  }
}
