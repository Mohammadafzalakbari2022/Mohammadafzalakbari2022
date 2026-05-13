import 'package:shamsi_date/shamsi_date.dart';

import 'date_calendar_system.dart';

/// First instant of the calendar month containing [ref] (local date).
DateTime startOfMonthContaining(DateTime ref, DateCalendarSystem sys) {
  if (sys == DateCalendarSystem.gregorian) {
    return DateTime(ref.year, ref.month);
  }
  final j = Jalali.fromDateTime(ref);
  return _dateOnly(Jalali(j.year, j.month, 1).toDateTime());
}

/// Exclusive end of the month that starts at [monthStart] (same [sys]).
DateTime endExclusiveForMonthStart(DateTime monthStart, DateCalendarSystem sys) {
  return addOneCalendarMonth(monthStart, sys);
}

/// First day of the month after [monthStart] (expects a date-only value).
DateTime addOneCalendarMonth(DateTime monthStart, DateCalendarSystem sys) {
  if (sys == DateCalendarSystem.gregorian) {
    return DateTime(monthStart.year, monthStart.month + 1);
  }
  final j = Jalali.fromDateTime(monthStart);
  return _dateOnly(Jalali(j.year, j.month, 1).addMonths(1).toDateTime());
}

/// First day of the month before [monthStart] (expects a date-only value).
DateTime subtractOneCalendarMonth(DateTime monthStart, DateCalendarSystem sys) {
  if (sys == DateCalendarSystem.gregorian) {
    return DateTime(monthStart.year, monthStart.month - 1);
  }
  final j = Jalali.fromDateTime(monthStart);
  return _dateOnly(Jalali(j.year, j.month, 1).addMonths(-1).toDateTime());
}

bool canAdvanceReportMonth(
  DateTime periodStart,
  DateCalendarSystem sys,
) {
  final now = DateTime.now();
  final currentStart = startOfMonthContaining(now, sys);
  final followingStart = addOneCalendarMonth(periodStart, sys);
  return !followingStart.isAfter(currentStart);
}

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);
