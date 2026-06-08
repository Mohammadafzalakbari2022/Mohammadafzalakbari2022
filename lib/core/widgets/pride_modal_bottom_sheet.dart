import 'package:flutter/material.dart';

/// Standard modal bottom sheet defaults for order composer and similar forms.
const double kPrideSheetInitialChildSize = 0.92;
const double kPrideSheetMinChildSize = 0.5;
const double kPrideSheetMaxChildSize = 0.96;

/// Opens a scroll-controlled modal bottom sheet with Pride defaults.
Future<T?> showPrideModalBottomSheet<T>({
  required BuildContext context,
  required WidgetBuilder builder,
  bool isDismissible = true,
  bool enableDrag = true,
  bool showDragHandle = true,
}) {
  return showModalBottomSheet<T>(
    context: context,
    isScrollControlled: true,
    useSafeArea: true,
    isDismissible: isDismissible,
    enableDrag: enableDrag,
    showDragHandle: showDragHandle,
    builder: builder,
  );
}

/// Draggable scrollable body with keyboard-safe padding and standard sizing.
class PrideDraggableSheetScaffold extends StatelessWidget {
  const PrideDraggableSheetScaffold({
    super.key,
    required this.header,
    required this.body,
    this.footer,
    this.initialChildSize = kPrideSheetInitialChildSize,
    this.minChildSize = kPrideSheetMinChildSize,
    this.maxChildSize = kPrideSheetMaxChildSize,
  });

  final Widget header;
  final Widget Function(ScrollController scrollController) body;
  final Widget? footer;
  final double initialChildSize;
  final double minChildSize;
  final double maxChildSize;

  @override
  Widget build(BuildContext context) {
    final viewInsets = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: viewInsets),
      child: DraggableScrollableSheet(
        expand: false,
        initialChildSize: initialChildSize,
        minChildSize: minChildSize,
        maxChildSize: maxChildSize,
        builder: (context, scrollController) {
          return Material(
            child: Column(
              children: [
                header,
                Expanded(child: body(scrollController)),
                if (footer != null) footer!,
              ],
            ),
          );
        },
      ),
    );
  }
}

/// Pinned footer with safe-area bottom padding.
class PrideSheetFooter extends StatelessWidget {
  const PrideSheetFooter({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        16,
        8,
        16,
        16 + MediaQuery.paddingOf(context).bottom,
      ),
      child: child,
    );
  }
}
