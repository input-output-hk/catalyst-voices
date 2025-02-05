import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:test/test.dart';

void main() {
  group(DateRange, () {
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

    test('isInRage if value is in between from to and they are not null', () {
      // Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 22));

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 21));
      final sameDayAsFrom = range.isInRange(DateTime(2025, 1, 20));
      final sameDayAsTo = range.isInRange(DateTime(2025, 1, 22));

      // Then
      expect(isInRange, isTrue);
      expect(sameDayAsFrom, isTrue);
      expect(sameDayAsTo, isTrue);
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

    test('is in range when both from and to are null', () {
      // Given
      const range = DateRange(from: null, to: null);

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 20));

      // Then
      expect(isInRange, isTrue);
    });

    test('is out of range', () {
      //Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 22));

      // When
      final isOutOfRange = range.isInRange(DateTime(2025, 1, 19));
      final isOutOfRange2 = range.isInRange(DateTime(2025, 1, 23));

      // Then
      expect(isOutOfRange, isFalse);
      expect(isOutOfRange2, isFalse);
    });

    test('is out of range even when from is null', () {
      // Given
      final range = DateRange(from: null, to: DateTime(2025, 1, 22));

      // When
      final isOutOfRange = range.isInRange(DateTime(2025, 1, 23));

      // Then
      expect(isOutOfRange, isFalse);
    });

    test('is in range when from and to are the same', () {
      // Given
      final range =
          DateRange(from: DateTime(2025, 1, 20), to: DateTime(2025, 1, 20));

      // When
      final isInRange = range.isInRange(DateTime(2025, 1, 20));

      // Then
      expect(isInRange, isTrue);
    });
  });
}
