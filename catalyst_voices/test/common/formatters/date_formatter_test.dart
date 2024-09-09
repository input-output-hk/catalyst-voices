import 'package:catalyst_voices/common/formatters/date_formatter.dart';
import 'package:catalyst_voices_localization/catalyst_voices_localization.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
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
}

void main() {
  group(DateFormatter, () {
    final l10n = _FakeVoicesLocalizations();

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
}
