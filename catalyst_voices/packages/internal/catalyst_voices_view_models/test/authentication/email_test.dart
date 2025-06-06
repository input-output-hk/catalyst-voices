import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:test/test.dart';

void main() {
  group(Email, () {
    group('validator', () {
      test('correct value returns no errors', () {
        // Given
        const value = 'dev@iohk.com';

        // When
        const email = Email.pure(value);

        // Then
        final error = email.error;

        expect(error, isNull);
      });

      test('empty value is accepted as valid', () {
        // When
        const email = Email.pure();

        // Then
        final error = email.error;

        expect(error, isNull);
      });

      test('without top level domain returns error', () {
        // Given
        const value = 'dev@iohk';

        // When
        const email = Email.pure(value);

        // Then
        final error = email.error;

        expect(error, isA<EmailPatternInvalidException>());
      });
    });
  });
}
