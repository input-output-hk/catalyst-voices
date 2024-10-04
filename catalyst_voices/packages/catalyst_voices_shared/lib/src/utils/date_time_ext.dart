import 'package:flutter/foundation.dart';

extension DateTimeExt on DateTime {
  static DateTime? _mockedDateTime;

  /// Overrides the dateTime returned by [now].
  /// Useful for unit testing.
  @visibleForTesting
  static set mockedDateTime(DateTime? customTime) {
    _mockedDateTime = customTime;
  }

  /// Testable [DateTime] factory method which returns:
  /// - mocked value, if not null, set with [mockedDateTime]
  /// - if[utc] current utc [DateTime.timestamp]
  /// - else current local [DateTime.now]
  static DateTime now({bool utc = false}) {
    DateTime? getMockedDateTime() {
      return utc ? _mockedDateTime?.toUtc() : _mockedDateTime;
    }

    DateTime getDateTime() {
      return utc ? DateTime.timestamp() : DateTime.now();
    }

    return getMockedDateTime() ?? getDateTime();
  }

  /// Returns whether two date times have the same year, month and day.
  bool isSameDateAs(DateTime other) {
    return year == other.year && month == other.month && day == other.day;
  }

  /// A method that correctly adds / subtracts days from the dateTime.
  ///
  /// The default approach of `dateTime.add(Duration(days: 1))` doesn't work
  /// for days that have more or less than 24 hours. Due to DST some days have
  /// 25 hours and some 23 hours. Duration class is not aware of DST changes so
  /// `Duration(days: 1)` literally means `24 hours`.
  DateTime plusDays(int days) {
    final temp = DateTime(year, month, day, 12).add(Duration(days: days));
    if (isUtc) {
      return DateTime.utc(
        temp.year,
        temp.month,
        temp.day,
        hour,
        minute,
        second,
        millisecond,
        microsecond,
      );
    }
    return DateTime(
      temp.year,
      temp.month,
      temp.day,
      hour,
      minute,
      second,
      millisecond,
      microsecond,
    );
  }

  /// Subtracts [days] from the datetime, being aware of the DST.
  DateTime minusDays(int days) => plusDays(-days);
}
