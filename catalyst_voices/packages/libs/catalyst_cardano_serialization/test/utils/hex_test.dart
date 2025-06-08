import 'package:catalyst_cardano_serialization/src/utils/hex.dart';
import 'package:convert/convert.dart';
import 'package:test/test.dart';

void main() {
  group('Hex utils', () {
    test('can decode formatted hex', () {
      expect(
        hexDecode('0xd0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2'),
        equals(hex.decode('d0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2')),
      );
    });

    test('can decode unformatted hex', () {
      expect(
        hexDecode('d0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2'),
        equals(hex.decode('d0880c4ef2c7a6aa8edbf97ce662a92c7f145a31cdf5b0a71ec268f16ea0dec2')),
      );
    });
  });
}
