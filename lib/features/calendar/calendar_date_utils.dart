import 'calendar_theme.dart';

// ── Date helpers ─────────────────────────────────────────────────────────────

DateTime calDateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

DateTime calFirstDayOfMonth(DateTime date) => DateTime(date.year, date.month);

bool calIsSameDay(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month && a.day == b.day;

bool calIsSameMonth(DateTime a, DateTime b) =>
    a.year == b.year && a.month == b.month;

bool calIsBeforeToday(DateTime day) =>
    calDateOnly(day).isBefore(calDateOnly(DateTime.now()));

// ── Grid helpers ─────────────────────────────────────────────────────────────

/// Generates 42 days (6 rows × 7 cols) starting from the Monday of the week
/// that contains the first day of [month].
List<DateTime> calVisibleDays(DateTime month) {
  final firstDay = calFirstDayOfMonth(month);
  final offset = firstDay.weekday - DateTime.monday;
  final gridStart = firstDay.subtract(Duration(days: offset));
  return List.generate(42, (i) => gridStart.add(Duration(days: i)));
}

/// Range of days between [start] and [end] (inclusive), sorted ascending.
List<DateTime> calSelectedRange(DateTime? start, DateTime? end) {
  if (start == null) return [];
  final s = calDateOnly(start);
  final e = calDateOnly(end ?? start);
  final from = s.isBefore(e) ? s : e;
  final to   = s.isBefore(e) ? e : s;
  final days = to.difference(from).inDays + 1;
  return List.generate(days, (i) => from.add(Duration(days: i)));
}

// ── Formatting ───────────────────────────────────────────────────────────────

String calFormatApiDate(DateTime date) {
  final d = calDateOnly(date);
  final month = d.month.toString().padLeft(2, '0');
  final day   = d.day.toString().padLeft(2, '0');
  return '${d.year}-$month-$day';
}

DateTime? calParseApiDate(String value) {
  final parsed = DateTime.tryParse(value);
  if (parsed != null) return calDateOnly(parsed);

  final parts = value.split(RegExp(r'[-/]'));
  if (parts.length < 3) return null;
  final year  = int.tryParse(parts[0]);
  final month = int.tryParse(parts[1]);
  final day   = int.tryParse(parts[2]);
  if (year == null || month == null || day == null) return null;
  return DateTime(year, month, day);
}

String calFormatDateLong(DateTime date) =>
    '${date.day} ${calMonthNames[date.month - 1]} ${date.year}';

String calFormatDateShort(DateTime date) =>
    '${date.day} ${calMonthNames[date.month - 1]}';

String calMonthTitle(DateTime date) {
  final month = calMonthNames[date.month - 1];
  return '${month[0].toUpperCase()}${month.substring(1)} ${date.year}';
}

String calFormatSelectionSummary(List<DateTime> range) {
  if (range.isEmpty) return '';
  if (range.length == 1) return calFormatDateLong(range.first);
  final first = range.first;
  final last  = range.last;
  final label = range.length == 1 ? 'jour' : 'jours';
  if (first.year == last.year && first.month == last.month) {
    return '${first.day} - ${last.day} ${calMonthNames[first.month - 1]} — ${range.length} $label';
  }
  return '${calFormatDateShort(first)} - ${calFormatDateShort(last)} — ${range.length} $label';
}

String calFormatSelectionLong(List<DateTime> range) {
  if (range.isEmpty) return '';
  if (range.length == 1) return calFormatDateLong(range.first);
  final first = range.first;
  final last  = range.last;
  if (first.year == last.year && first.month == last.month) {
    return '${first.day} - ${last.day} ${calMonthNames[first.month - 1]} ${first.year}';
  }
  return '${calFormatDateLong(first)} - ${calFormatDateLong(last)}';
}

String calCompactNames(List<String> names) {
  final clean = names.where((n) => n.trim().isNotEmpty).toList();
  if (clean.isEmpty) return 'Résidence';
  if (clean.length == 1) return clean.first;
  if (clean.length == 2) return '${clean.first}, ${clean.last}';
  return '${clean.first} + ${clean.length - 1}';
}
