import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

/// A [DateTime] formatter.
abstract class DateFormatter {
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

  static String formatInDays(
    VoicesLocalizations l10n,
    DateTime dateTime, {
    DateTime? from,
  }) {
    from ??= DateTimeExt.now();

    final days = dateTime.isAfter(from) ? dateTime.difference(from).inDays : 0;

    return l10n.inXDays(days);
  }

  static (String date, String time) formatDateTimeParts(
    DateTime date,
  ) {
    final dayMonthFormatter = DateFormat('d MMMM').format(date);
    final timeFormatter = DateFormat('HH:mm').format(date);

    return (dayMonthFormatter, timeFormatter);
  }

  static String formatShortMonth(
    VoicesLocalizations l10n,
    DateTime dateTime,
  ) {
    return DateFormat.MMM().format(dateTime);
  }

  /// Formats full date and time.
  /// If [timeOnNewline] is true then the time will be placed on a new line.
  ///
  /// Example:
  /// - Thu, 6 June 2024 10:00 am
  static String formatFullDateTime(
    DateTime dateTime, {
    bool timeOnNewline = false,
  }) {
    final format =
        timeOnNewline ? 'EEE, d MMMM yyyy\nh:mm a' : 'EEE, d MMMM yyyy h:mm a';
    return DateFormat(format).format(dateTime);
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

  static String _formatTimezoneOffset(Duration offset) {
    if (offset.isNegative) {
      return '-${_formatDurationHHmm(offset)}';
    } else {
      return '+${_formatDurationHHmm(offset)}';
    }
  }

  static String _formatDurationHHmm(Duration offset) {
    final nf = NumberFormat('00');
    final hours = offset.inHours;
    final minutes = offset.inMinutes - hours * Duration.minutesPerHour;

    return '${nf.format(hours)}:${nf.format(minutes)}';
  }

  static String formatDateRange(
    MaterialLocalizations localizations,
    VoicesLocalizations l10n,
    DateRange range,
  ) {
    final from = range.from;
    final to = range.to;
    if (from != null && to != null) {
      if (range.areDatesInSameWeek(localizations.firstDayOfWeekIndex)) {
        return '${l10n.weekOf} ${DateFormat.MMMd().format(from)}';
      }

      // ignore: lines_longer_than_80_chars
      return '${DateFormat.MMMd().format(from)} - ${DateFormat.MMMd().format(to)}';
    } else if (to == null && from != null) {
      return '${l10n.from} ${DateFormat.MMMd().format(from)}';
    } else if (to != null && from == null) {
      return '${l10n.to} ${DateFormat.MMMd().format(to)}';
    }

    return '';
  }
}
