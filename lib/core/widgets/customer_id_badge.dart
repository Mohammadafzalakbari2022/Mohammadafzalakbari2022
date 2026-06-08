import 'package:flutter/material.dart';
import 'package:pride_v3/app/app_theme.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import '../../data/local/customer_display_no.dart';
import '../formatting/display_customer_no_format.dart';

/// High-visibility customer identifier chip used across list, detail, and reports.
class CustomerIdBadge extends StatelessWidget {
  const CustomerIdBadge({
    super.key,
    required this.storedCustomerNo,
    this.compact = false,
    this.showLabel = true,
  });

  final String storedCustomerNo;
  final bool compact;
  final bool showLabel;

  @override
  Widget build(BuildContext context) {
    if (parseStoredDisplayCustomerNo(storedCustomerNo) <= 0) {
      return const SizedBox.shrink();
    }

    final l10n = AppLocalizations.of(context)!;
    final theme = Theme.of(context);
    final idColors = prideCustomerIdColors(context);
    final number = formatDisplayCustomerNo(storedCustomerNo);
    final labelStyle = (compact
            ? theme.textTheme.labelSmall
            : theme.textTheme.labelMedium)
        ?.copyWith(
      color: idColors.onBackground.withValues(alpha: 0.92),
      fontWeight: FontWeight.w600,
      letterSpacing: 0.2,
    );
    final numberStyle = (compact
            ? theme.textTheme.titleSmall
            : theme.textTheme.titleMedium)
        ?.copyWith(
      color: idColors.onBackground,
      fontWeight: FontWeight.w800,
      letterSpacing: 0.4,
    );

    return DecoratedBox(
      decoration: BoxDecoration(
        color: idColors.background,
        borderRadius: BorderRadius.circular(compact ? 8 : 10),
        boxShadow: [
          BoxShadow(
            color: idColors.background.withValues(alpha: 0.18),
            blurRadius: compact ? 3 : 6,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Padding(
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 10 : 14,
          vertical: compact ? 5 : 8,
        ),
        child: showLabel
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(l10n.customerIdLabel, style: labelStyle),
                  Text(number, style: numberStyle),
                ],
              )
            : Text(
                displayCustomerNumberLabel(l10n, storedCustomerNo),
                style: numberStyle,
              ),
      ),
    );
  }
}
