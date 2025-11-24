import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DocumentDataMetadataDto, () {
    group('migration', () {
      test('version and id migration works as expected', () {
        // Given
        final id = DocumentRefFactory.randomUuidV7();
        final version = DocumentRefFactory.randomUuidV7();
        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalDocument.uuid,
          'id': id,
          'version': version,
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);

        // Then
        expect(dto.id.id, id);
        expect(dto.id.ver, version);
      });

      test('selfRef to id works as expected', () {
        // Given
        final id = DocumentRefFactory.randomUuidV7();
        final version = DocumentRefFactory.randomUuidV7();
        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalDocument.uuid,
          'selfRef': {
            'id': id,
            'version': version,
            'type': 'signed',
          },
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);

        // Then
        expect(dto.id.id, id);
        expect(dto.id.ver, version);
        expect(dto.id.type, DocumentRefDtoType.signed);
      });
    });
  });
}
