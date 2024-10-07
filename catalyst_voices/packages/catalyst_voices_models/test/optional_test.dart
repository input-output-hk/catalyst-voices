import 'package:catalyst_voices_models/src/optional.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(Optional, () {
    test('empty creates instance with null data', () {
      // Given

      // When
      const optional = Optional<String>.empty();

      // Then
      expect(optional.isEmpty, isTrue);
      expect(optional.data, isNull);
    });

    test('default constructor accepts nullable data', () {
      // Given
      const String? data = null;

      // When
      const optional = Optional(data);

      // Then
      expect(optional.isEmpty, isTrue);
      expect(optional.data, data);
    });

    test('of constructor accepts non-nullable data', () {
      // Given
      const data = 'username';

      // When
      const optional = Optional.of(data);

      // Then
      expect(optional.isEmpty, isFalse);
      expect(optional.data, data);
    });

    test(
      'dataOr returns optional data when not null',
      () {
        // Given
        const data = 'username';
        const optional = Optional(data) as Optional<String>?;

        // When
        final optionalData = optional.dataOr('fallback');

        // Then
        expect(optionalData, data);
      },
    );

    test(
      'dataOr returns fallback when called on null Optional',
      () {
        // Given
        const fallbackData = 'fallback';
        const Optional<String>? optional = null;

        // When
        final optionalData = optional.dataOr(fallbackData);

        // Then
        expect(optionalData, fallbackData);
      },
    );
  });
}
