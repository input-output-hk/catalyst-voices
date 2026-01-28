import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:intl/intl.dart';

/// A [Duration] formatter.
abstract class DurationFormatter {
  /// Formats the [duration] as days / hours / minutes.
  /// Skips each segment where the value is 0 and previous segments were zero too.
  ///
  /// Examples:
  /// - 10d 15h 5m
  /// - 13h 0m
  /// - 10m
  /// - 0m
  static String formatDurationDDhhmm(VoicesLocalizations localizations, Duration duration) {
    final nf = NumberFormat('0');
    final days = duration.inDays;
    final hours = duration.inHours - days * Duration.hoursPerDay;
    final minutes =
        duration.inMinutes - days * Duration.minutesPerDay - hours * Duration.minutesPerHour;

    final values = <String>[];
    if (days > 0) {
      values.add('${nf.format(days)}${localizations.dayAbbr}');
    }

    if (hours > 0 || values.isNotEmpty) {
      values.add('${nf.format(hours)}${localizations.hourAbbr}');
    }

    values.add('${nf.format(minutes)}${localizations.minuteAbbr}');

    return values.join(' ');
  }

  /// Formats the [duration] as hours / minutes / seconds.
  /// Skips each segment where the value is 0 and previous segments were zero too.
  ///
  /// Examples:
  /// - 3h 15min
  /// - 45min
  /// - 30s
  static String formatDurationHHmmss(VoicesLocalizations localizations, Duration duration) {
    final nf = NumberFormat('0');
    final hours = duration.inHours;
    final minutes = duration.inMinutes.remainder(60);
    final seconds = duration.inSeconds;

    if (hours > 0) {
      return '${nf.format(hours)}${localizations.hourAbbr} ${nf.format(minutes)}${localizations.minuteAbbr}';
    } else if (minutes > 0) {
      return '${nf.format(minutes)}${localizations.minAbbr}';
    } else {
      return '${nf.format(seconds)}${localizations.secondAbbr}';
    }
  }

  /// Formats the [duration] as minutes / seconds.
  /// Skips each segment where the value is 0 and previous segments were zero too.
  ///
  /// Examples:
  /// - 1200m 34s
  /// - 13m 0s
  /// - 17s
  /// - 0s
  static String formatDurationMMss(VoicesLocalizations localizations, Duration duration) {
    final nf = NumberFormat('0');
    final minutes = duration.inMinutes;
    final seconds = duration.inSeconds - minutes * Duration.secondsPerMinute;

    final values = <String>[];

    if (minutes > 0) {
      values.add('${nf.format(minutes)}${localizations.minuteAbbr}');
    }

    values.add('${nf.format(seconds)}${localizations.secondAbbr}');

    return values.join(' ');
  }
}
