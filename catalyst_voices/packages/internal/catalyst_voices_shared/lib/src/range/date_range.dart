import 'package:equatable/equatable.dart';

class DateRange extends Equatable {
  final DateTime? from;
  final DateTime? to;

  const DateRange({
    required this.from,
    required this.to,
  });

  bool isInRange(DateTime value) {
    final min = from?.millisecondsSinceEpoch ?? 0;
    final max =
        to?.millisecondsSinceEpoch ?? DateTime(2099).millisecondsSinceEpoch;
    final valueMillis = value.millisecondsSinceEpoch;

    return min <= valueMillis && valueMillis <= max;
  }

  bool isTodayInRange() {
    return isInRange(DateTime.now());
  }

  /// Checks if the date [from] is the first day of the week
  /// and [to] is the last day
  /// of the same week, considering the first day of the week as specified
  /// by [firstDayOfWeekIndex].
  ///
  /// The [firstDayOfWeekIndex] is an integer representing
  /// the first day of the week according to the locale or desired convention,
  /// where 0 represents Sunday and 1 represents Monday, and so on.
  ///
  /// Returns `true` if [from] is the first day and
  /// [to] is the last day of the same week, and `false` otherwise.
  ///
  /// If either [from] or [to] is `null`, the function returns `false`.
  bool areDatesInSameWeek(int firstDayOfWeekIndex) {
    if (from == null || to == null) {
      return false;
    }

    var adjustedFromWeekday = (from!.weekday - firstDayOfWeekIndex) % 7;
    var adjustedToWeekday = (to!.weekday - firstDayOfWeekIndex) % 7;

    if (adjustedFromWeekday < 0) adjustedFromWeekday += 7;
    if (adjustedToWeekday < 0) adjustedToWeekday += 7;

    return adjustedFromWeekday == 0 && adjustedToWeekday == 6;
  }

  @override
  List<Object?> get props => [from, to];
}
