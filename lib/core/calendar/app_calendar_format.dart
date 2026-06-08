import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:pride_v3/core/formatting/digit_normalizer.dart';
import 'package:pride_v3/l10n/app_localizations.dart';

import 'date_calendar_system.dart';
import 'solar_hijri_month_name.dart';

/// Formats dates for UI according to [DateCalendarSystem].
abstract final class AppCalendarFormat {
  static const _latinLocale = 'en';

  static String mediumDate(
    AppLocalizations l10n,
    DateCalendarSystem sys,
    DateTime d,
    String intlLocale,
  ) {
    if (sys == DateCalendarSystem.gregorian) {
      return normalizeWesternDigits(
        DateFormat.yMMMd(_latinLocale).format(d),
      );
    }
    final j = Jalali.fromDateTime(d);
    return '${solarHijriMonthName(l10n, j.month)} ${j.year}, ${j.day}';
  }

  static String monthYearHeading(
    AppLocalizations l10n,
    DateCalendarSystem sys,
    DateTime anyDayInMonth,
    String intlLocale,
  ) {
    if (sys == DateCalendarSystem.gregorian) {
      return normalizeWesternDigits(
        DateFormat.yMMMM(_latinLocale).format(anyDayInMonth),
      );
    }
    final j = Jalali.fromDateTime(anyDayInMonth);
    return '${solarHijriMonthName(l10n, j.month)} ${j.year}';
  }

  /// Date + 12-hour time with English AM/PM and Latin digits.
  static String dateTimeMedium(
    AppLocalizations l10n,
    DateCalendarSystem sys,
    DateTime d,
    String intlLocale,
  ) {
    final date = mediumDate(l10n, sys, d, intlLocale);
    final time = normalizeWesternDigits(DateFormat.jm(_latinLocale).format(d));
    return '$date · $time';
  }
}
