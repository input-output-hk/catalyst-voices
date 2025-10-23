import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:flutter_test/flutter_test.dart';

import '../../utils/test_factories.dart';

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
        expect(dto.selfRef.id, id);
        expect(dto.selfRef.version, version);
      });

      test('parameters migration works as expected', () {
        // Given
        final selfRef = DocumentRefFactory.signedDocumentRef();
        final brandId = DocumentRefFactory.signedDocumentRef();
        final campaignId = DocumentRefFactory.signedDocumentRef();
        final categoryId = DocumentRefFactory.signedDocumentRef();

        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalDocument.uuid,
          'selfRef': {
            'id': selfRef.id,
            'version': selfRef.version,
            'type': 'signed',
          },
          'brandId': {
            'id': brandId.id,
            'version': brandId.version,
            'type': 'signed',
          },
          'campaignId': {
            'id': campaignId.id,
            'version': campaignId.version,
            'type': 'signed',
          },
          'categoryId': {
            'id': categoryId.id,
            'version': categoryId.version,
            'type': 'signed',
          },
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);
        final model = dto.toModel();

        // Then
        expect(
          model.parameters,
          equals(DocumentParameters({brandId, campaignId, categoryId})),
        );
      });
    });
  });
}
