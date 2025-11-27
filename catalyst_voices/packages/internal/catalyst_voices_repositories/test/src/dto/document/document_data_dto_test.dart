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
          expect(identical(json, migrated), isTrue);
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
          expect(dto.brandId?.id, brandId);
          expect(dto.brandId?.ver, isNull);
          expect(dto.brandId?.type, DocumentRefDtoType.signed);
          expect(dto.campaignId?.id, campaignId);
          expect(dto.campaignId?.ver, isNull);
          expect(dto.campaignId?.type, DocumentRefDtoType.signed);
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
          final migrated = DocumentDataMetadataDto.migrateJson1(json);

          // Then
          expect(identical(json, migrated), isTrue);
        });
      });

      group('3', () {
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
          final migrated = DocumentDataMetadataDto.migrateJson1(json);

          // Then
          expect(identical(json, migrated), isTrue);
        });
      });
    });
  });
}
