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
        final brandRef = DocumentRefFactory.signedDocumentRef();
        final campaignRef = DocumentRefFactory.signedDocumentRef();
        final categoryRef = DocumentRefFactory.signedDocumentRef();

        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalDocument.uuid,
          'selfRef': {
            'id': selfRef.id,
            'version': selfRef.version,
            'type': 'signed',
          },
          'brandId': {
            'id': brandRef.id,
            'version': brandRef.version,
            'type': 'signed',
          },
          'campaignId': {
            'id': campaignRef.id,
            'version': campaignRef.version,
            'type': 'signed',
          },
          'categoryId': {
            'id': categoryRef.id,
            'version': categoryRef.version,
            'type': 'signed',
          },
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);
        final model = dto.toModel();

        // Then
        expect(
          model.parameters,
          equals(DocumentParameters({brandRef, campaignRef, categoryRef})),
        );
      });

      test('content type migration works as expected for document with json content', () {
        // Given
        final selfRef = DocumentRefFactory.signedDocumentRef();
        final categoryRef = DocumentRefFactory.signedDocumentRef();

        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalDocument.uuid,
          'selfRef': {
            'id': selfRef.id,
            'version': selfRef.version,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.version,
              'type': 'signed',
            },
          ],
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);
        final model = dto.toModel();

        // Then
        expect(model.contentType, equals(DocumentContentType.json));
      });

      test('content type migration works as expected for document with json schema content', () {
        // Given
        final selfRef = DocumentRefFactory.signedDocumentRef();
        final categoryRef = DocumentRefFactory.signedDocumentRef();

        final oldJson = <String, dynamic>{
          'type': DocumentType.proposalTemplate.uuid,
          'selfRef': {
            'id': selfRef.id,
            'version': selfRef.version,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.version,
              'type': 'signed',
            },
          ],
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);
        final model = dto.toModel();

        // Then
        expect(model.contentType, equals(DocumentContentType.schemaJson));
      });
    });
  });
}
