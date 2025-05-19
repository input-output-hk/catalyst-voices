import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  group(CoseHeaders, () {
    group('fromCbor', () {
      test('single value type is decoded as single element list', () {
        // Given
        const typeValue = Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc');
        final value = CborMap({
          CoseHeaderKeys.type: typeValue.toCbor(),
        });
        const expectedType = DocumentType([typeValue]);

        // When
        final headers = CoseHeaders.fromCbor(value);

        // Then
        expect(headers.type, allOf(isNotNull, equals(expectedType)));
      });

      test('list value type is decoded as list', () {
        // Given
        const typeValue = [
          Uuid('0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
          Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
        ];
        final value = CborMap({
          CoseHeaderKeys.type: CborList(typeValue.map((e) => e.toCbor()).toList()),
        });
        const expectedType = DocumentType(typeValue);

        // When
        final headers = CoseHeaders.fromCbor(value);

        // Then
        expect(headers.type, allOf(isNotNull, equals(expectedType)));
      });
    });

    group('toCbor', () {
      test('single value type is encoded as list', () {
        // Given
        const documentType = DocumentType([Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc')]);
        const header = CoseHeaders(type: documentType, encodeAsBytes: false);

        final expectedValue = CborMap({
          CoseHeaderKeys.type: CborList(documentType.value.map((e) => e.toCbor()).toList()),
        });

        // When
        final headerType = header.toCbor();

        // Then
        expect(headerType, expectedValue);
      });
    });
  });
}
