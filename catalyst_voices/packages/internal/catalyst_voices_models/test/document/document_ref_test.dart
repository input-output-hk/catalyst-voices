import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:test/test.dart';

void main() {
  group(DraftRef, () {
    test('should generate first reference correctly', () {
      final draftRef = DraftRef.generateFirstRef();
      expect(draftRef.id, isNotEmpty);
      expect(draftRef.version, equals(draftRef.id));
    });

    test('should return itself for nextVersion', () {
      const draftRef = DraftRef(id: '123', version: 'v1');
      expect(draftRef.nextVersion(), same(draftRef));
    });
  });

  group(SignedDocumentRef, () {
    test('nextVersion should create a DraftRef with new version', () {
      const signedRef = SignedDocumentRef(id: 'xyz', version: 'v1');
      final nextDraft = signedRef.nextVersion();

      expect(nextDraft, isA<DraftRef>());
      expect(nextDraft.id, signedRef.id);
      expect(nextDraft.version, isNot(equals(signedRef.version)));
    });
  });
}
