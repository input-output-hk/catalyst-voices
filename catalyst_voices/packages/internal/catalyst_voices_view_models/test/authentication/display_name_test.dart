import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:test/test.dart';

void main() {
  group(DisplayName, () {
    group('validator', () {
      test('correct value returns no errors', () {
        // Given
        const value = 'Dev';

        // When
        const displayName = DisplayName.pure(value);

        // Then
        final error = displayName.error;

        expect(error, isNull);
      });

      test('empty returns error', () {
        // Given
        const value = '';

        // When
        const displayName = DisplayName.pure(value);

        // Then
        final error = displayName.error;

        expect(error, isA<EmptyDisplayNameException>());
      });

      test('too long value returns error', () {
        // Given
        final value = List.generate(
          (DisplayName.lengthRange.max ?? 0) + 1,
          (_) => 'A',
        ).join();

        // When
        final displayName = DisplayName.pure(value);

        // Then
        final error = displayName.error;

        expect(error, isA<OutOfRangeDisplayNameException>());
      });
    });
  });
}
