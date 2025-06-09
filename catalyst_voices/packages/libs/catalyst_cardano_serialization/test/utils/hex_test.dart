import 'package:catalyst_cardano_serialization/src/utils/hex.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {
  group('Hex utils', () {
    test('can decode formatted hex', () {
      // Given
      const value = 'd0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2';
      const decoratedValue = '0x$value';

      // When
      final actual = hexDecode(decoratedValue);
      final expected = hex.decode(value);

      // Then
      expect(actual, orderedEquals(expected));
    });

    test('can decode unformatted hex', () {
      // Given
      const value = 'd0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2';

      // When
      final actual = hexDecode(value);
      final expected = hex.decode(value);

      // Then
      expect(actual, orderedEquals(expected));
    });
  });
}
