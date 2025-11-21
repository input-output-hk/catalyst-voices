import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(DocumentDataMetadata, () {
    test('non exact selfRef throw assert exception', () {
      // Given
      final selfRef = DraftRef(id: const Uuid().v7());

      // When
      DocumentDataMetadata buildFun() {
        return DocumentDataMetadata(
          contentType: DocumentContentType.json,
          type: DocumentType.proposalDocument,
          selfRef: selfRef,
        );
      }

      // Then
      expect(buildFun, throwsA(isA<AssertionError>()));
    });

    test('exact selfRef returns normally', () {
      // Given
      final selfRef = DraftRef(
        id: const Uuid().v7(),
        version: const Uuid().v7(),
      );

      // When
      DocumentDataMetadata buildFun() {
        return DocumentDataMetadata(
          contentType: DocumentContentType.json,
          type: DocumentType.proposalDocument,
          selfRef: selfRef,
        );
      }

      // Then
      expect(buildFun, returnsNormally);
    });
  });
}
