import 'package:pride_v3/l10n/app_localizations.dart';

String solarHijriMonthName(AppLocalizations l10n, int month1to12) {
  return switch (month1to12) {
    1 => l10n.calendarMonthHamal,
    2 => l10n.calendarMonthSawr,
    3 => l10n.calendarMonthJawza,
    4 => l10n.calendarMonthSaratan,
    5 => l10n.calendarMonthAsad,
    6 => l10n.calendarMonthSonbola,
    7 => l10n.calendarMonthMizan,
    8 => l10n.calendarMonthAqrab,
    9 => l10n.calendarMonthQaws,
    10 => l10n.calendarMonthJadi,
    11 => l10n.calendarMonthDalw,
    12 => l10n.calendarMonthHut,
    _ => month1to12.toString(),
  };
}
