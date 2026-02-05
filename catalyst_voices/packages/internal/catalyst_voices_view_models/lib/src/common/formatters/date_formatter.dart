import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [DateTime] formatter.
abstract class DateFormatter {
  static String formatDateRange(
    MaterialLocalizations localizations,
    VoicesLocalizations l10n,
    DateRange range, {
    bool formatSameWeek = true,
  }) {
    final from = range.from;
    final to = range.to;
    if (from != null && to != null) {
      if (formatSameWeek && range.areDatesInSameWeek(localizations.firstDayOfWeekIndex)) {
        return '${l10n.weekOf} ${DateFormat.MMMd().format(from)}';
      }

      return '${DateFormat.MMMd().format(from)} - ${DateFormat.MMMd().format(to)}';
    } else if (to == null && from != null) {
      return '${l10n.from} ${DateFormat.MMMd().format(from)}';
    } else if (to != null && from == null) {
      return '${l10n.to} ${DateFormat.MMMd().format(to)}';
    }

    return '';
  }

  /// Formats a given DateTime into separate date and time strings.
  ///
  /// The method formats the date part in either 'd MMMM yyyy' or
  /// 'd MMMM' format depending on the value of [includeYear].
  /// The time part is always formatted in 'HH:mm' format.
  ///
  /// Parameters:
  /// - [date]: The DateTime object to format.
  /// - [includeYear]: A boolean indicating whether the year should be included
  ///   in the formatted date string. Defaults to `false`.
  ///
  /// Returns a map with:
  /// - `date`: The formatted date string.
  /// - `time`: The formatted time string.
  ///
  /// Examples:
  /// - For `DateTime(2023, 10, 14, 9, 30)` with `includeYear = false`:
  ///   - date: "14 October"
  ///   - time: "09:30"
  /// - For `DateTime(2023, 10, 14, 9, 30)` with `includeYear = true`:
  ///   - date: "14 October 2023"
  ///   - time: "09:30"
  /// - For `DateTime(2022, 2, 5, 15, 45)` with `includeYear = false`:
  ///   - date: "5 February"
  ///   - time: "15:45"
  /// - For `DateTime(2022, 2, 5, 15, 45)` with `includeYear = true`:
  ///   - date: "5 February 2022"
  ///   - time: "15:45"
  static ({String date, String time}) formatDateTimeParts(
    DateTime date, {
    bool includeYear = false,
  }) {
    final formatter = includeYear ? DateFormat('d MMMM yyyy') : DateFormat('d MMMM');
    final dayMonthFormatter = formatter.format(date);
    final timeFormatter = DateFormat('HH:mm').format(date);

    return (date: dayMonthFormatter, time: timeFormatter);
  }

  /// Formats a given [DateTime] object into a string
  /// with the format "d MMM HH:mm".
  ///
  /// The format consists of:
  /// - Day of the month as a number without leading zeros (e.g., 4)
  /// - Abbreviated month name (e.g., Jan, Feb, Mar)
  /// - 24-hour time format with hours and minutes (e.g., 14:30)
  static String formatDayMonthTime(DateTime dateTime) {
    return DateFormat('d MMM HH:mm').format(dateTime);
  }

  /// Formats a given [DateTime] object into a string
  /// with the format "HH:mm · dd/MM/yyyy".
  ///
  /// The format consists of:
  /// - 24-hour time format with hours and minutes (e.g., 13:45)
  /// - A middle dot separator (·)
  /// - Date in day/month/year format (e.g., 01/05/2025)
  ///
  /// Example output: "13:45 · 01/05/2025"
  static String formatTimeAndDate(DateTime dateTime) {
    final time = DateFormat('HH:mm').format(dateTime);
    final date = DateFormat('dd/MM/yyyy').format(dateTime);
    return '$time · $date';
  }

  static String formatFullDate24Format(DateTime dateTime) {
    return DateFormat('d MMM, yyyy - HH:mm').format(dateTime);
  }

  static String formatFullDateFormat(DateTime dateTime) {
    return DateFormat('d MMM, yyyy').format(dateTime);
  }

  /// Formats full date and time in 24 format with leading day of week.
  /// If [timeOnNewline] is true then the time will be placed on a new line.
  ///
  /// Example:
  /// - Thu, 6 June 2024 10:00
  static String formatFullDateTime(
    DateTime dateTime, {
    bool timeOnNewline = false,
  }) {
    final format = timeOnNewline ? 'EEE, d MMMM yyyy\nHH:mm' : 'EEE, d MMMM yyyy, HH:mm';
    return DateFormat(format).format(dateTime);
  }

  static String formatInDays(
    VoicesLocalizations l10n,
    DateTime dateTime, {
    DateTime? from,
  }) {
    from ??= DateTimeExt.now();

    final days = dateTime.isAfter(from) ? dateTime.difference(from).inDays : 0;

    return l10n.inXDays(days);
  }

  /// Formats recent dates like:
  /// - Today
  /// - Tomorrow
  /// - Yesterday
  /// - 2 days ago
  /// - Other cases: yMMMMd date format.
  static String formatRecentDate(VoicesLocalizations l10n, DateTime dateTime) {
    final now = DateTimeExt.now();

    final today = DateTime(now.year, now.month, now.day, 12);
    if (dateTime.isSameDateAs(today)) return l10n.today;

    final tomorrow = today.plusDays(1);
    if (dateTime.isSameDateAs(tomorrow)) return l10n.tomorrow;

    final yesterday = today.minusDays(1);
    if (dateTime.isSameDateAs(yesterday)) return l10n.yesterday;

    final twoDaysAgo = today.minusDays(2);
    if (dateTime.isSameDateAs(twoDaysAgo)) return l10n.twoDaysAgo;

    return DateFormat.yMMMMd().format(dateTime);
  }

  static String formatShortMonth(
    VoicesLocalizations l10n,
    DateTime dateTime,
  ) {
    return DateFormat.MMM().format(dateTime);
  }

  /// Formats full date and time with more timestamp like pattern.
  /// Adapts to device local settings.
  ///
  /// Example:
  /// - 7/10/1996 5:08 PM
  /// - 7/10/1996 17:08
  static String formatTimestamp(
    DateTime dateTime, {
    bool includeTime = true,
  }) {
    var format = DateFormat.yMd();
    if (includeTime) {
      format = format.add_jm();
    }

    return format.format(dateTime);
  }

  /// Formats the timezone info extracted from the [dateTime].
  ///
  /// Example:
  /// - GMT+01:00 Central European Standard Time
  static String formatTimezone(DateTime dateTime) {
    final offset = _formatTimezoneOffset(dateTime.timeZoneOffset);
    final timezone = dateTime.timeZoneName;
    return 'GMT$offset $timezone';
  }

  static String _formatDurationHHmm(Duration offset) {
    final nf = NumberFormat('00');
    final hours = offset.inHours;
    final minutes = offset.inMinutes - hours * Duration.minutesPerHour;

    return '${nf.format(hours)}:${nf.format(minutes)}';
  }

  static String _formatTimezoneOffset(Duration offset) {
    if (offset.isNegative) {
      return '-${_formatDurationHHmm(offset)}';
    } else {
      return '+${_formatDurationHHmm(offset)}';
    }
  }
}
