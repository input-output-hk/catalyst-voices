import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
}
