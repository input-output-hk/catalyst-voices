import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(DocumentDataMetadata, () {
    test('non exact id throw assert exception', () {
      // Given
      final id = DraftRef(id: const Uuid().v7());

      // When
      DocumentDataMetadata buildFun() {
        return DocumentDataMetadata(
          contentType: DocumentContentType.json,
          type: DocumentType.proposalDocument,
          id: id,
        );
      }

      // Then
      expect(buildFun, throwsA(isA<AssertionError>()));
    });

    test('exact id returns normally', () {
      // Given
      final id = DraftRef(
        id: const Uuid().v7(),
        ver: const Uuid().v7(),
      );

      // When
      DocumentDataMetadata buildFun() {
        return DocumentDataMetadata(
          contentType: DocumentContentType.json,
          type: DocumentType.proposalDocument,
          id: id,
        );
      }

      // Then
      expect(buildFun, returnsNormally);
    });
  });
}
