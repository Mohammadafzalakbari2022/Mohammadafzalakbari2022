import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

/// Phone layout: width strictly below [kPrideTabletMinWidth].
const kPrideTabletMinWidth = 600.0;

/// Tablet layout: [kPrideTabletMinWidth] … [kPrideDesktopMinWidth − 1].
const kPrideDesktopMinWidth = 900.0;

/// Very wide layouts (extended navigation rail labels).
const kPrideWideDesktopMinWidth = 1200.0;

/// Optional cap for centered form-like content on ultra-wide screens.
const kPrideMaxContentWidth = 1400.0;

bool prideIsCompactWidth(double width) => width < kPrideTabletMinWidth;

bool prideIsTabletOrWider(double width) => width >= kPrideTabletMinWidth;

bool prideIsDesktopOrWider(double width) => width >= kPrideDesktopMinWidth;

/// Persistent [NavigationRail] on web or wide layouts (plan-30).
bool prideUseShellRail(BuildContext context) {
  if (kIsWeb) return true;
  return prideIsDesktopOrWider(MediaQuery.sizeOf(context).width);
}

/// Horizontal inset for scroll/list bodies — modest on tablet, not phone-stretched.
double prideContentHorizontalPadding(double width) {
  if (width < kPrideTabletMinWidth) return 12;
  if (width < kPrideDesktopMinWidth) return 8;
  return 12;
}

EdgeInsets prideListScreenPadding(BuildContext context) {
  final h = prideContentHorizontalPadding(MediaQuery.sizeOf(context).width);
  return EdgeInsets.fromLTRB(h, 8, h, 4);
}

EdgeInsets prideComposerScrollPadding(BuildContext context) {
  final safe = MediaQuery.paddingOf(context);
  final h = prideContentHorizontalPadding(MediaQuery.sizeOf(context).width);
  return EdgeInsets.fromLTRB(
    safe.left > 0 ? safe.left : h,
    8,
    safe.right > 0 ? safe.right : h,
    96,
  );
}
