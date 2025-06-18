import 'package:catalyst_cose/catalyst_cose.dart';
import 'package:catalyst_cose/src/utils/cbor_utils.dart';
import 'package:cbor/cbor.dart';
import 'package:test/test.dart';

void main() {
  group(DocumentType, () {
    group('fromCbor', () {
      test('single uuid bytes are decoded as single uuid DocumentType', () {
        // Given
        const uuid = Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc');
        final value = uuid.toCbor();

        // When
        final documentType = DocumentType.fromCbor(value);

        // Then
        expect(documentType.value, allOf(hasLength(1), contains(uuid)));
      });

      test('list is decoded as list of uuids in order', () {
        // Given
        const uuid1 = Uuid('0ce8ab38-9258-4fbc-a62e-7faa6e58318f');
        const uuid2 = Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc');
        final value = CborList([uuid1.toCbor(), uuid2.toCbor()]);

        // When
        final documentType = DocumentType.fromCbor(value);

        // Then
        expect(
          documentType.value,
          allOf(hasLength(value.length), containsAllInOrder([uuid1, uuid2])),
        );
      });

      test('not supported value throws exception', () {
        // Given
        const value = CborSmallInt(1);

        // When
        DocumentType parse() => DocumentType.fromCbor(value);

        // Then
        expect(parse, throwsA(isA<ArgumentError>()));
      });
    });

    group('toCbor', () {
      test('encodes as cbor list', () {
        // Given
        const documentType = DocumentType([
          Uuid('0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
          Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
        ]);

        // When
        final cborValue = documentType.toCbor();

        // Then
        expect(cborValue, isA<CborList>());
        expect(
          cborValue as CborList,
          everyElement(
            allOf(
              isA<CborBytes>(),
              predicate<CborBytes>((value) => value.tags.contains(CborUtils.uuidTag)),
            ),
          ),
        );
      });
    });

    test('encodes and decodes back correctly', () {
      // Given
      const documentType = DocumentType([
        Uuid('0ce8ab38-9258-4fbc-a62e-7faa6e58318f'),
        Uuid('7808d2ba-d511-40af-84e8-c0d1625fdfdc'),
      ]);

      // When
      final encoded = documentType.toCbor();
      final decoded = DocumentType.fromCbor(encoded);

      // Then
      expect(decoded, documentType);
    });
  });
}
