import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../persistence/shared_preferences_provider.dart';
import 'date_calendar_system.dart';

const _kDateCalendarPref = 'pride_date_calendar_system';

final dateCalendarSystemProvider =
    NotifierProvider<DateCalendarNotifier, DateCalendarSystem>(
  DateCalendarNotifier.new,
);

class DateCalendarNotifier extends Notifier<DateCalendarSystem> {
  @override
  DateCalendarSystem build() {
    final prefs = ref.watch(sharedPreferencesProvider);
    final raw = prefs.getString(_kDateCalendarPref);
    for (final v in DateCalendarSystem.values) {
      if (v.name == raw) return v;
    }
    return DateCalendarSystem.solarHijri;
  }

  Future<void> set(DateCalendarSystem value) async {
    state = value;
    await ref.read(sharedPreferencesProvider).setString(_kDateCalendarPref, value.name);
  }
}
