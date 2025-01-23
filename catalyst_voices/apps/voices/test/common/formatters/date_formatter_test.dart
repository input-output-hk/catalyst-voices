import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

class _FakeVoicesLocalizations extends Fake implements VoicesLocalizations {
  @override
  String get today => 'Today';
  @override
  String get tomorrow => 'Tomorrow';
  @override
  String get yesterday => 'Yesterday';
  @override
  String get twoDaysAgo => '2 days ago';
  @override
  // TODO: implement weekOf
  String get weekOf => 'Week of';
  @override
  // TODO: implement from
  String get from => 'From';
  @override
  // TODO: implement to
  String get to => 'To';
}

class _FakeMaterialLocalizations extends Fake implements MaterialLocalizations {
  int _firstDayOfWeekIndex = 0;
  @override
  int get firstDayOfWeekIndex => _firstDayOfWeekIndex;

  set firstDayOfWeekIndex(int value) {
    _firstDayOfWeekIndex = value;
  }
}

void main() {
  group(DateFormatter, () {
    final l10n = _FakeVoicesLocalizations();
    final mockLocalizations = _FakeMaterialLocalizations();

    test('should return "Today" for today\'s date', () {
      final today = DateTimeExt.now();
      final result = DateFormatter.formatRecentDate(l10n, today);
      expect(result, l10n.today);
    });

    test('should return "Tomorrow" for tomorrow\'s date', () {
      final tomorrow = DateTimeExt.now().plusDays(1);
      final result = DateFormatter.formatRecentDate(l10n, tomorrow);
      expect(result, l10n.tomorrow);
    });

    test('should return "Yesterday" for yesterday\'s date', () {
      final yesterday = DateTimeExt.now().minusDays(1);
      final result = DateFormatter.formatRecentDate(l10n, yesterday);
      expect(result, l10n.yesterday);
    });

    test('should return "2 days ago" for a date 2 days ago', () {
      final twoDaysAgo = DateTimeExt.now().minusDays(2);
      final result = DateFormatter.formatRecentDate(l10n, twoDaysAgo);
      expect(result, l10n.twoDaysAgo);
    });

    test('should return formatted date for older dates', () {
      final pastDate = DateTimeExt.now().minusDays(10);
      final result = DateFormatter.formatRecentDate(l10n, pastDate);
      final expectedFormat = DateFormat.yMMMMd().format(pastDate);
      expect(result, expectedFormat);
    });

    test(
        'Dates are in the same week for Local when Sunday is first day of week',
        () {
      //Set Sunday as first day of week
      mockLocalizations.firstDayOfWeekIndex = 0;
      final dateRangeWhenSundayFirst = DateRange(
        from: DateTime(2025, 1, 19),
        to: DateTime(2025, 1, 25),
      );
      final dateRangeWhenMondayFirst = DateRange(
        from: DateTime(2025, 1, 20),
        to: DateTime(2025, 1, 26),
      );

      final resultSunday = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        dateRangeWhenSundayFirst,
      );
      final resultMonday = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        dateRangeWhenMondayFirst,
      );

      expect(resultSunday, 'Week of Jan 19');
      expect(resultMonday, 'Jan 20 - Jan 26');
    });

    test(
        'Dates are in the same week for Local when Monday is first day of week',
        () {
      //Set Monday as first day of week
      mockLocalizations.firstDayOfWeekIndex = 1;
      final dateRangeWhenSundayFirst = DateRange(
        from: DateTime(2025, 1, 19),
        to: DateTime(2025, 1, 25),
      );
      final dateRangeWhenMondayFirst = DateRange(
        from: DateTime(2025, 1, 20),
        to: DateTime(2025, 1, 26),
      );

      final resultSunday = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        dateRangeWhenSundayFirst,
      );
      final resultMonday = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        dateRangeWhenMondayFirst,
      );

      expect(resultSunday, 'Jan 19 - Jan 25');
      expect(resultMonday, 'Week of Jan 20');
    });

    test('Return range when both dates are not null', () {
      final range = DateRange(
        from: DateTime(2025, 1, 18),
        to: DateTime(2025, 2, 25),
      );

      final result = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        range,
      );

      expect(result, 'Jan 18 - Feb 25');
    });

    test('Return only from', () {
      final range = DateRange(
        from: DateTime(2025, 1, 18),
        to: null,
      );

      final result = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        range,
      );

      expect(result, 'From Jan 18');
    });

    test('Return only to', () {
      final range = DateRange(
        from: null,
        to: DateTime(2025, 1, 18),
      );

      final result = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        range,
      );

      expect(result, 'To Jan 18');
    });

    test('Return empty string when both dates are null', () {
      const range = DateRange(
        from: null,
        to: null,
      );

      final result = DateFormatter.formatDateRange(
        mockLocalizations,
        l10n,
        range,
      );

      expect(result, '');
    });
  });
}
