import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';

void main() {
  group('$DateRange', () {
    test('is not in range', () {
      // Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 22));

      // When
      final isInRageBeforFromDate = range.isInRange(DateTime(2025, 1, 19));
      final isInRageAfterToDate = range.isInRange(DateTime(2025, 1, 23));

      // Then
      expect(isInRageBeforFromDate, isFalse);
      expect(isInRageAfterToDate, isFalse);
    });
    test('isInRage if value is in between from to and and they are not null',
        () {
      // Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 22));

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 21));

      // Then
      expect(isInRange, isTrue);
    });

    test('isInRange if value is the same day as from', () {
      // Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 22));

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 20));

      // Then
      expect(isInRange, isTrue);
    });

    test('isInRange if value is the same day as from', () {
      // Given
      final range = DateRange(from: DateTime(2025, 1, 20), to: null);

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 20));

      // Then
      expect(isInRange, isTrue);
    });

    test('is in range when value is after from and to is null', () {
      // Given
      final range = DateRange(from: DateTime(2025, 1, 20), to: null);

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 22));

      // Then
      expect(isInRange, isTrue);
    });

    test('is in range when value is before to date and from is null', () {
      // Given
      final range = DateRange(from: null, to: DateTime(2025, 1, 22));

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 20));

      // Then
      expect(isInRange, isTrue);
    });
  });
}
