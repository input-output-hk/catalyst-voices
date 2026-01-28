import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_data_dto.dart';
import 'package:catalyst_voices_repositories/src/dto/document/document_ref_dto.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group(DocumentDataMetadataDto, () {
    group('migration', () {
      group('1', () {
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

        test('do nothing when migration not needed', () {
          // Given
          final json = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
          };

          // When
          final migrated = DocumentDataMetadataDto.migrateJson1(json);

          // Then
          expect(json, same(migrated));
        });
      });

      group('2', () {
        test('version and id migration works as expected', () {
          // Given
          final campaignId = DocumentRefFactory.randomUuidV7();
          final brandId = DocumentRefFactory.randomUuidV7();
          final oldJson = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
            'brandId': brandId,
            'campaignId': campaignId,
          };

          // When
          final dto = DocumentDataMetadataDto.fromJson(oldJson);

          // Then
          expect(dto.parameters.any((ref) => ref.id == brandId), isTrue);
          expect(dto.parameters.any((ref) => ref.id == campaignId), isTrue);
        });

        test('do nothing when migration not needed', () {
          // Given
          final json = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
            'brandId': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
            'campaignId': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
          };

          // When
          final migrated = DocumentDataMetadataDto.migrateJson2(json);

          // Then
          expect(json, same(migrated));
        });
      });

      group('3', () {
        test('version and id migration works as expected', () {
          // Given
          final campaignId = DocumentRefFactory.randomUuidV7();
          final brandId = DocumentRefFactory.randomUuidV7();
          final oldJson = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
            'brandId': {
              'id': brandId,
              'ver': brandId,
              'type': 'signed',
            },
            'campaignId': {
              'id': campaignId,
              'ver': campaignId,
              'type': 'signed',
            },
          };

          final campaignRef = DocumentRefDto(
            id: campaignId,
            ver: campaignId,
            type: DocumentRefDtoType.signed,
          );
          final brandRef = DocumentRefDto(
            id: brandId,
            ver: brandId,
            type: DocumentRefDtoType.signed,
          );

          // When
          final dto = DocumentDataMetadataDto.fromJson(oldJson);

          // Then
          expect(dto.parameters.contains(campaignRef), isTrue);
          expect(dto.parameters.contains(brandRef), isTrue);
        });

        test('do nothing when migration not needed', () {
          // Given
          final json = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
            'parameters': [
              {
                'id': DocumentRefFactory.randomUuidV7(),
                'version': DocumentRefFactory.randomUuidV7(),
                'type': 'signed',
              },
              {
                'id': DocumentRefFactory.randomUuidV7(),
                'version': DocumentRefFactory.randomUuidV7(),
                'type': 'signed',
              },
            ],
          };

          // When
          final migrated = DocumentDataMetadataDto.migrateJson3(json);

          // Then
          expect(json, same(migrated));
        });
      });

      group('4', () {
        test('version and id migration works as expected', () {
          // Given
          final oldJson = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
          };

          // When
          final dto = DocumentDataMetadataDto.fromJson(oldJson);

          // Then
          expect(dto.contentType, DocumentContentType.json);
        });

        test('do nothing when migration not needed', () {
          // Given
          final json = <String, dynamic>{
            'contentType': DocumentContentType.json.value,
            'type': DocumentType.proposalDocument.uuid,
            'selfRef': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
          };

          // When
          final migrated = DocumentDataMetadataDto.migrateJson4(json);

          // Then
          expect(json, same(migrated));
        });
      });

      group('5', () {
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

        test('do nothing when migration not needed', () {
          // Given
          final json = <String, dynamic>{
            'type': DocumentType.proposalDocument.uuid,
            'id': {
              'id': DocumentRefFactory.randomUuidV7(),
              'version': DocumentRefFactory.randomUuidV7(),
              'type': 'signed',
            },
          };

          // When
          final migrated = DocumentDataMetadataDto.migrateJson5(json);

          // Then
          expect(json, same(migrated));
        });
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'brandId': {
            'id': brandRef.id,
            'version': brandRef.ver,
            'type': 'signed',
          },
          'campaignId': {
            'id': campaignRef.id,
            'version': campaignRef.ver,
            'type': 'signed',
          },
          'categoryId': {
            'id': categoryRef.id,
            'version': categoryRef.ver,
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.ver,
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.ver,
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'brandId': {
            'id': brandRef.id,
            'version': brandRef.ver,
            'type': 'signed',
          },
          'campaignId': {
            'id': campaignRef.id,
            'version': campaignRef.ver,
            'type': 'signed',
          },
          'categoryId': {
            'id': categoryRef.id,
            'version': categoryRef.ver,
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.ver,
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
            'version': selfRef.ver,
            'type': 'signed',
          },
          'parameters': [
            {
              'id': categoryRef.id,
              'version': categoryRef.ver,
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
