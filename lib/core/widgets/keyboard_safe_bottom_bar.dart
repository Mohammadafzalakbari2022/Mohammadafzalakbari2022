import 'package:flutter/material.dart';

/// Pinned bottom action bar that stays above the software keyboard.
class KeyboardSafeBottomBar extends StatelessWidget {
  const KeyboardSafeBottomBar({
    super.key,
    required this.child,
    this.minimum = const EdgeInsets.all(16),
  });

  final Widget child;
  final EdgeInsets minimum;

  @override
  Widget build(BuildContext context) {
    final keyboard = MediaQuery.viewInsetsOf(context).bottom;
    return AnimatedPadding(
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOut,
      padding: EdgeInsets.only(bottom: keyboard),
      child: SafeArea(minimum: minimum, child: child),
    );
  }
}
