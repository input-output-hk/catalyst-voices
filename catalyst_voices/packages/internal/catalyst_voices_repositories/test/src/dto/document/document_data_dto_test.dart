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
          'type': DocumentType.proposalDocument.toJson(),
          'id': id,
          'version': version,
        };

        // When
        final dto = DocumentDataMetadataDto.fromJson(oldJson);

        // Then
        expect(dto.selfRef.id, id);
        expect(dto.selfRef.version, version);
      });
    });
  });
}
