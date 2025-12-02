import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DocumentRefDto, () {
    group('migration', () {
      group('1', () {
        test('version to ver migration works as expected', () {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final ver = DocumentRefFactory.randomUuidV7();
          final oldJson = <String, dynamic>{'id': id, 'version': ver, 'type': 'signed'};

          // When
          final dto = DocumentRefDto.fromJson(oldJson);

          // Then
          expect(dto.id, id);
          expect(dto.ver, ver);
        });

        test('produced json works correctly', () {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final ver = DocumentRefFactory.randomUuidV7();
          final oldJson = <String, dynamic>{'id': id, 'version': ver, 'type': 'signed'};
          final expectedJson = <String, dynamic>{'id': id, 'ver': ver, 'type': 'signed'};

          // When
          final migrated = DocumentRefDto.migrateJson1(oldJson);

          // Then
          expect(migrated, expectedJson);
        });

        test('do nothing when migration not needed', () {
          // Given
          final id = DocumentRefFactory.randomUuidV7();
          final ver = DocumentRefFactory.randomUuidV7();
          final json = <String, dynamic>{'id': id, 'ver': ver, 'type': 'signed'};

          // When
          final migrated = DocumentRefDto.migrateJson1(json);

          // Then
          expect(identical(migrated, json), isTrue);
        });
      });
    });

    group('flatten', () {
      test('round trip with UUIDs (containing hyphens) works correctly', () {
        // Given
        // UUIDs contain hyphens, which tests if the separator logic is robust
        final id = DocumentRefFactory.randomUuidV7();
        final ver = DocumentRefFactory.randomUuidV7();
        const type = DocumentRefDtoType.signed;

        final original = DocumentRefDto(id: id, ver: ver, type: type);

        // When
        final flattened = original.toFlatten();
        final reconstructed = DocumentRefDto.fromFlatten(flattened);

        // Then
        expect(reconstructed.id, original.id);
        expect(reconstructed.ver, original.ver);
        expect(reconstructed.type, original.type);
      });

      test('round trip with null version works correctly', () {
        // Given
        final id = DocumentRefFactory.randomUuidV7();
        const type = DocumentRefDtoType.draft;

        // ver is explicitly null
        // ignore: avoid_redundant_argument_values
        final original = DocumentRefDto(id: id, ver: null, type: type);

        // When
        final flattened = original.toFlatten();
        final reconstructed = DocumentRefDto.fromFlatten(flattened);

        // Then
        expect(reconstructed.id, original.id);
        expect(reconstructed.ver, isNull);
        expect(reconstructed.type, original.type);
      });

      test('throws FormatException when data does not have 3 parts', () {
        // Given
        const invalidData = 'invalid-format';

        // Then
        expect(
          () => DocumentRefDto.fromFlatten(invalidData),
          throwsA(isA<FormatException>()),
        );
      });

      test('throws FormatException when type is unknown', () {
        // Given
        final id = DocumentRefFactory.randomUuidV7();
        // Uses the correct separator but an invalid enum name
        final invalidData = '$id|1.0|UNKNOWN_TYPE';

        // Then
        expect(
          () => DocumentRefDto.fromFlatten(invalidData),
          throwsA(isA<FormatException>()),
        );
      });
    });
  });
}
