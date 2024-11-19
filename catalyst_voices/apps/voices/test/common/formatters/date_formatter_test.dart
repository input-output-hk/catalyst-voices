import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations_en.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:intl/intl.dart';

void main() {
  group(DateFormatter, () {
    final l10n = VoicesLocalizationsEn();

    group('formatRecentDate', () {
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
    });

    group('formatInDays', () {
      test('returns 20 days when in comparing to 20 days in future', () {
        // Given
        final publishDate = DateTime(2024, 11, 20);
        final now = DateTime(2024, 11, 0);

        // When
        final result = DateFormatter.formatInDays(
          l10n,
          publishDate,
          from: now,
        );

        // Then
        expect(result, 'In 20 days');
      });

      test('returns 0 days when in comparing to past', () {
        // Given
        final publishDate = DateTime(2024, 2, 10);
        final now = DateTime(2024, 11, 0);

        // When
        final result = DateFormatter.formatInDays(
          l10n,
          publishDate,
          from: now,
        );

        // Then
        expect(result, 'In 0 days');
      });

      test('returns 1 day when in comparing to 1 day in future', () {
        // Given
        final publishDate = DateTime(2024, 11, 1);
        final now = DateTime(2024, 11, 0);

        // When
        final result = DateFormatter.formatInDays(
          l10n,
          publishDate,
          from: now,
        );

        // Then
        expect(result, 'In 1 day');
      });
    });
  });
}
