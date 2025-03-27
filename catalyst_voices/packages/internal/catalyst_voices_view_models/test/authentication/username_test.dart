import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:test/test.dart';

void main() {
  group(Username, () {
    group('validator', () {
      test('correct value returns no errors', () {
        // Given
        const value = 'Dev';

        // When
        const username = Username.pure(value);

        // Then
        final error = username.error;

        expect(error, isNull);
      });

      test('empty returns error', () {
        // Given
        const value = '';

        // When
        const username = Username.pure(value);

        // Then
        final error = username.error;

        expect(error, isA<EmptyUsernameException>());
      });

      test('too long value returns error', () {
        // Given
        final value = List.generate(
          (Username.lengthRange.max ?? 0) + 1,
          (_) => 'A',
        ).join();

        // When
        final username = Username.pure(value);

        // Then
        final error = username.error;

        expect(error, isA<OutOfRangeUsernameException>());
      });
    });
  });
}
