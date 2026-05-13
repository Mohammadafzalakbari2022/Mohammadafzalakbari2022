import 'package:intl/intl.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:pride_v3/l10n/app_localizations.dart';

import 'date_calendar_system.dart';
import 'solar_hijri_month_name.dart';

/// Formats dates for UI according to [DateCalendarSystem].
abstract final class AppCalendarFormat {
  static String mediumDate(
    AppLocalizations l10n,
    DateCalendarSystem sys,
    DateTime d,
    String intlLocale,
  ) {
    if (sys == DateCalendarSystem.gregorian) {
      return DateFormat.yMMMd(intlLocale).format(d);
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
      return DateFormat.yMMMM(intlLocale).format(anyDayInMonth);
    }
    final j = Jalali.fromDateTime(anyDayInMonth);
    return '${solarHijriMonthName(l10n, j.month)} ${j.year}';
  }

  static String dateTimeMedium(
    AppLocalizations l10n,
    DateCalendarSystem sys,
    DateTime d,
    String intlLocale,
  ) {
    final date = mediumDate(l10n, sys, d, intlLocale);
    final time = DateFormat.Hm(intlLocale).format(d);
    return '$date · $time';
  }
}
