import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(DraftRef, () {
    test('should generate first reference correctly', () {
      final draftRef = DraftRef.generateFirstRef();
      expect(draftRef.id, isNotEmpty);
      expect(draftRef.ver, equals(draftRef.id));
    });

    test('should return itself for nextVersion', () {
      const draftRef = DraftRef(id: '123', ver: 'v1');
      expect(draftRef.nextVersion(), same(draftRef));
    });
  });

  group(SignedDocumentRef, () {
    test('nextVersion should create a DraftRef with new version', () {
      const signedRef = SignedDocumentRef(id: 'xyz', ver: 'v1');
      final nextDraft = signedRef.nextVersion();

      expect(nextDraft, isA<DraftRef>());
      expect(nextDraft.id, signedRef.id);
      expect(nextDraft.ver, isNot(equals(signedRef.ver)));
    });

    test('isValid should return true for SignedDocumentRef with specified version', () {
      final validSignedRef = SignedDocumentRef.generateFirstRef();
      const invalidSignedRef = SignedDocumentRef(id: 'xyz', ver: 'v1');

      expect(validSignedRef.isExact, isTrue);
      expect(validSignedRef.isExact, isTrue);
      expect(validSignedRef.isValid, isTrue);
      expect(invalidSignedRef.isValid, isFalse);
    });

    test('isValid should return true for SignedDocumentRef without specified version', () {
      final uuid = const Uuid().v7();
      final validSignedRef = SignedDocumentRef(id: uuid);
      const invalidSignedRef = SignedDocumentRef(id: 'xyz');

      expect(validSignedRef.isExact, isFalse);
      expect(validSignedRef.isExact, isFalse);
      expect(validSignedRef.isValid, isTrue);
      expect(invalidSignedRef.isValid, isFalse);
    });
  });
}
