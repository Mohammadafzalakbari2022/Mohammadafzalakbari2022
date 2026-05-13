import 'package:flutter/material.dart';
import 'package:shamsi_date/shamsi_date.dart';

import 'package:pride_v3/l10n/app_localizations.dart';

import 'date_calendar_system.dart';
import 'solar_hijri_month_name.dart';

DateTime _dateOnly(DateTime d) => DateTime(d.year, d.month, d.day);

DateTime _clampDay(DateTime d, DateTime first, DateTime last) {
  if (d.isBefore(first)) return first;
  if (d.isAfter(last)) return last;
  return d;
}

Jalali _normalizeJalali(Jalali j, DateTime first, DateTime last) {
  final cap = Jalali(j.year, j.month, 1).monthLength;
  final jd = Jalali(j.year, j.month, j.day.clamp(1, cap));
  final dt = _dateOnly(jd.toDateTime());
  return Jalali.fromDateTime(_clampDay(dt, first, last));
}

/// Single date: Material picker (Gregorian) or Solar Hijri dialog.
Future<DateTime?> showAppDatePicker({
  required BuildContext context,
  required AppLocalizations l10n,
  required DateCalendarSystem system,
  required DateTime initialDate,
  required DateTime firstDate,
  required DateTime lastDate,
}) async {
  final first = _dateOnly(firstDate);
  final last = _dateOnly(lastDate);
  if (system == DateCalendarSystem.gregorian) {
    return showDatePicker(
      context: context,
      initialDate: _clampDay(_dateOnly(initialDate), first, last),
      firstDate: first,
      lastDate: last,
    );
  }
  return showDialog<DateTime>(
    context: context,
    builder: (ctx) => _SolarHijriDatePickerDialog(
      l10n: l10n,
      initialDate: _clampDay(_dateOnly(initialDate), first, last),
      firstDate: first,
      lastDate: last,
    ),
  );
}

/// Range: Material (Gregorian) or Solar Hijri dialog.
Future<DateTimeRange?> showAppDateRangePicker({
  required BuildContext context,
  required AppLocalizations l10n,
  required DateCalendarSystem system,
  required DateTimeRange initialDateRange,
  required DateTime firstDate,
  required DateTime lastDate,
  String? helpText,
}) async {
  final first = _dateOnly(firstDate);
  final last = _dateOnly(lastDate);
  if (system == DateCalendarSystem.gregorian) {
    return showDateRangePicker(
      context: context,
      helpText: helpText,
      firstDate: first,
      lastDate: last,
      initialDateRange: DateTimeRange(
        start: _clampDay(_dateOnly(initialDateRange.start), first, last),
        end: _clampDay(_dateOnly(initialDateRange.end), first, last),
      ),
    );
  }
  return showDialog<DateTimeRange>(
    context: context,
    builder: (ctx) => _SolarHijriRangePickerDialog(
      l10n: l10n,
      helpText: helpText,
      initialRange: DateTimeRange(
        start: _clampDay(_dateOnly(initialDateRange.start), first, last),
        end: _clampDay(_dateOnly(initialDateRange.end), first, last),
      ),
      firstDate: first,
      lastDate: last,
    ),
  );
}

class _SolarHijriDatePickerDialog extends StatefulWidget {
  const _SolarHijriDatePickerDialog({
    required this.l10n,
    required this.initialDate,
    required this.firstDate,
    required this.lastDate,
  });

  final AppLocalizations l10n;
  final DateTime initialDate;
  final DateTime firstDate;
  final DateTime lastDate;

  @override
  State<_SolarHijriDatePickerDialog> createState() =>
      _SolarHijriDatePickerDialogState();
}

class _SolarHijriDatePickerDialogState extends State<_SolarHijriDatePickerDialog> {
  late Jalali _j;

  @override
  void initState() {
    super.initState();
    _j = _normalizeJalali(
      Jalali.fromDateTime(widget.initialDate),
      widget.firstDate,
      widget.lastDate,
    );
  }

  @override
  Widget build(BuildContext context) {
    final mat = MaterialLocalizations.of(context);
    final jFirst = Jalali.fromDateTime(widget.firstDate);
    final jLast = Jalali.fromDateTime(widget.lastDate);
    final years = [for (var y = jFirst.year; y <= jLast.year; y++) y];
    final daysCount = Jalali(_j.year, _j.month, 1).monthLength;
    final days = [for (var d = 1; d <= daysCount; d++) d];

    return AlertDialog(
      title: Text(widget.l10n.datePickerSolarHijriTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            InputDecorator(
              decoration: InputDecoration(labelText: widget.l10n.datePickerYearLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _j.year,
                  items: years
                      .map(
                        (y) => DropdownMenuItem(value: y, child: Text('$y')),
                      )
                      .toList(),
                  onChanged: (y) {
                    if (y == null) return;
                    setState(() {
                      _j = _normalizeJalali(
                        Jalali(y, _j.month, _j.day),
                        widget.firstDate,
                        widget.lastDate,
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: InputDecoration(labelText: widget.l10n.datePickerMonthLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _j.month,
                  items: List.generate(12, (i) {
                    final m = i + 1;
                    return DropdownMenuItem(
                      value: m,
                      child: Text(solarHijriMonthName(widget.l10n, m)),
                    );
                  }),
                  onChanged: (m) {
                    if (m == null) return;
                    setState(() {
                      _j = _normalizeJalali(
                        Jalali(_j.year, m, _j.day),
                        widget.firstDate,
                        widget.lastDate,
                      );
                    });
                  },
                ),
              ),
            ),
            const SizedBox(height: 12),
            InputDecorator(
              decoration: InputDecoration(labelText: widget.l10n.datePickerDayLabel),
              child: DropdownButtonHideUnderline(
                child: DropdownButton<int>(
                  isExpanded: true,
                  value: _j.day.clamp(1, daysCount),
                  items: days
                      .map(
                        (d) => DropdownMenuItem(value: d, child: Text('$d')),
                      )
                      .toList(),
                  onChanged: (d) {
                    if (d == null) return;
                    setState(() {
                      _j = _normalizeJalali(
                        Jalali(_j.year, _j.month, d),
                        widget.firstDate,
                        widget.lastDate,
                      );
                    });
                  },
                ),
              ),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(mat.cancelButtonLabel)),
        FilledButton(
          onPressed: () {
            final g = _dateOnly(_j.toDateTime());
            Navigator.pop(context, g);
          },
          child: Text(mat.okButtonLabel),
        ),
      ],
    );
  }
}

class _SolarHijriRangePickerDialog extends StatefulWidget {
  const _SolarHijriRangePickerDialog({
    required this.l10n,
    required this.initialRange,
    required this.firstDate,
    required this.lastDate,
    this.helpText,
  });

  final AppLocalizations l10n;
  final DateTimeRange initialRange;
  final DateTime firstDate;
  final DateTime lastDate;
  final String? helpText;

  @override
  State<_SolarHijriRangePickerDialog> createState() =>
      _SolarHijriRangePickerDialogState();
}

class _SolarHijriRangePickerDialogState extends State<_SolarHijriRangePickerDialog> {
  late Jalali _from;
  late Jalali _to;

  @override
  void initState() {
    super.initState();
    _from = _normalizeJalali(
      Jalali.fromDateTime(widget.initialRange.start),
      widget.firstDate,
      widget.lastDate,
    );
    _to = _normalizeJalali(
      Jalali.fromDateTime(widget.initialRange.end),
      widget.firstDate,
      widget.lastDate,
    );
    if (_dateOnly(_from.toDateTime()).isAfter(_dateOnly(_to.toDateTime()))) {
      _to = _from;
    }
  }

  Widget _row({
    required String label,
    required Jalali current,
    required void Function(Jalali next) onChanged,
  }) {
    final jFirst = Jalali.fromDateTime(widget.firstDate);
    final jLast = Jalali.fromDateTime(widget.lastDate);
    final years = [for (var y = jFirst.year; y <= jLast.year; y++) y];
    final daysCount = Jalali(current.year, current.month, 1).monthLength;
    final days = [for (var d = 1; d <= daysCount; d++) d];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(label, style: Theme.of(context).textTheme.titleSmall),
        const SizedBox(height: 8),
        InputDecorator(
          decoration: InputDecoration(labelText: widget.l10n.datePickerYearLabel),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: current.year,
              items: years.map((y) => DropdownMenuItem(value: y, child: Text('$y'))).toList(),
              onChanged: (y) {
                if (y == null) return;
                onChanged(
                  _normalizeJalali(Jalali(y, current.month, current.day), widget.firstDate, widget.lastDate),
                );
              },
            ),
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(labelText: widget.l10n.datePickerMonthLabel),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: current.month,
              items: List.generate(
                12,
                (i) {
                  final m = i + 1;
                  return DropdownMenuItem(
                    value: m,
                    child: Text(solarHijriMonthName(widget.l10n, m)),
                  );
                },
              ),
              onChanged: (m) {
                if (m == null) return;
                onChanged(
                  _normalizeJalali(Jalali(current.year, m, current.day), widget.firstDate, widget.lastDate),
                );
              },
            ),
          ),
        ),
        InputDecorator(
          decoration: InputDecoration(labelText: widget.l10n.datePickerDayLabel),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<int>(
              isExpanded: true,
              value: current.day.clamp(1, daysCount),
              items: days.map((d) => DropdownMenuItem(value: d, child: Text('$d'))).toList(),
              onChanged: (d) {
                if (d == null) return;
                onChanged(
                  _normalizeJalali(Jalali(current.year, current.month, d), widget.firstDate, widget.lastDate),
                );
              },
            ),
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final mat = MaterialLocalizations.of(context);
    return AlertDialog(
      title: Text(widget.helpText ?? widget.l10n.datePickerSolarHijriRangeTitle),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _row(
              label: widget.l10n.dateRangeFromLabel,
              current: _from,
              onChanged: (j) => setState(() {
                _from = j;
                if (_dateOnly(_from.toDateTime()).isAfter(_dateOnly(_to.toDateTime()))) {
                  _to = _from;
                }
              }),
            ),
            const SizedBox(height: 16),
            _row(
              label: widget.l10n.dateRangeToLabel,
              current: _to,
              onChanged: (j) => setState(() {
                _to = j;
                if (_dateOnly(_to.toDateTime()).isBefore(_dateOnly(_from.toDateTime()))) {
                  _from = _to;
                }
              }),
            ),
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(mat.cancelButtonLabel)),
        FilledButton(
          onPressed: () {
            final a = _dateOnly(_from.toDateTime());
            final b = _dateOnly(_to.toDateTime());
            if (a.isAfter(b)) {
              Navigator.pop(context, DateTimeRange(start: b, end: a));
            } else {
              Navigator.pop(context, DateTimeRange(start: a, end: b));
            }
          },
          child: Text(mat.okButtonLabel),
        ),
      ],
    );
  }
}
