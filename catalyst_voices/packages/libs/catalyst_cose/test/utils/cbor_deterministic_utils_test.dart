import 'package:catalyst_cose/src/utils/cbor_deterministic_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  group(CborDeterministicUtils, () {
    test('createList always creates definite-length list', () {
      // Given
      final input = CborList([], type: CborLengthType.indefinite);

      // When
      final output = CborDeterministicUtils.createList(input);

      // Then
      expect(output.type, equals(CborLengthType.definite));
    });

    test('createList sorts deterministically the list', () {
      // Given
      final input = CborList([
        const CborSmallInt(2),
        CborBytes([1, 2, 3]),
        const CborSmallInt(1),
      ]);

      // When
      final output = CborDeterministicUtils.createList(input);

      // Then
      expect(
        output,
        orderedEquals([
          const CborSmallInt(1),
          const CborSmallInt(2),
          CborBytes([1, 2, 3]),
        ]),
      );
    });

    test('createList does not modify already deterministic list', () {
      // Given
      final input = [
        const CborSmallInt(1),
        const CborSmallInt(2),
        CborBytes([1, 2, 3]),
      ];

      // When
      final output = CborDeterministicUtils.createList(input);

      // Then
      expect(output, orderedEquals(input));
    });
  });
}
