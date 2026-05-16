import 'package:flutter_test/flutter_test.dart';
import 'package:pride_v3/core/calendar/date_calendar_system.dart';
import 'package:pride_v3/core/calendar/report_month_period.dart';

void main() {
  test('current month window is non-empty', () {
    final now = DateTime(2026, 5, 15);
    final start = startOfMonthContaining(now, DateCalendarSystem.gregorian);
    final end = endExclusiveForMonthStart(start, DateCalendarSystem.gregorian);
    expect(end.isAfter(start), isTrue);
    expect(now.isAfter(start) || now.isAtSameMomentAs(start), isTrue);
    expect(now.isBefore(end), isTrue);
  });
}
