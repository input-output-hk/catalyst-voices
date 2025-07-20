import 'package:catalyst_voices/common/formatters/duration_formatter.dart';
import 'package:catalyst_voices_localization/generated/catalyst_voices_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';

void main() {
  group(DurationFormatter, () {
    final localizations = MockVoicesLocalizations();

    setUpAll(() {
      when(() => localizations.dayAbbr).thenReturn('d');
      when(() => localizations.hourAbbr).thenReturn('h');
      when(() => localizations.minuteAbbr).thenReturn('m');
      when(() => localizations.secondAbbr).thenReturn('s');
    });

    group('formatDurationMMss', () {
      test('formats full duration with days, hours, and minutes', () {
        // Given
        const duration = Duration(days: 10, hours: 15, minutes: 5);

        // When
        final result = DurationFormatter.formatDurationDDhhmm(localizations, duration);

        // Then
        expect(result, '10d 15h 5m');
      });

      test('formats duration with only hours and minutes', () {
        // Given
        const duration = Duration(hours: 13);

        // When
        final result = DurationFormatter.formatDurationDDhhmm(localizations, duration);

        // Then
        expect(result, '13h 0m');
      });

      test('formats duration with only minutes', () {
        // Given
        const duration = Duration(minutes: 10);

        // When
        final result = DurationFormatter.formatDurationDDhhmm(localizations, duration);

        // Then
        expect(result, '10m');
      });

      test('formats duration with zero minutes', () {
        // Given
        const duration = Duration.zero;

        // When
        final result = DurationFormatter.formatDurationDDhhmm(localizations, duration);

        // Then
        expect(result, '0m');
      });
    });

    group('formatDurationMMss', () {
      test('formats full duration with minutes and seconds', () {
        // Given
        const duration = Duration(minutes: 1200, seconds: 34);

        // When
        final result = DurationFormatter.formatDurationMMss(localizations, duration);

        // Then
        expect(result, '1200m 34s');
      });

      test('formats duration with only minutes', () {
        // Given
        const duration = Duration(minutes: 13);

        // When
        final result = DurationFormatter.formatDurationMMss(localizations, duration);

        // Then
        expect(result, '13m 0s');
      });

      test('formats duration with only seconds', () {
        // Given
        const duration = Duration(seconds: 17);

        // When
        final result = DurationFormatter.formatDurationMMss(localizations, duration);

        // Then
        expect(result, '17s');
      });

      test('formats duration with zero seconds', () {
        // Given
        const duration = Duration.zero;

        // When
        final result = DurationFormatter.formatDurationMMss(localizations, duration);

        // Then
        expect(result, '0s');
      });
    });
  });
}

class MockVoicesLocalizations extends Mock implements VoicesLocalizations {}
