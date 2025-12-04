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
          expect(json, same(migrated));
        });
      });
    });
  });
}
