import 'package:catalyst_voices_models/src/document/document_ref.dart';
import 'package:test/test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(DocumentRef, () {
    group('contains', () {
      final id = const Uuid().v7();
      final otherId = const Uuid().v7();
      final ver1 = const Uuid().v7();
      final ver2 = const Uuid().v7();

      test('should return false if runtime types are different', () {
        // Even with same ID and Version, Draft != Signed
        final draft = DraftRef(id: id, ver: ver1);
        final signed = SignedDocumentRef(id: id, ver: ver1);

        expect(draft.contains(signed), isFalse);
        expect(signed.contains(draft), isFalse);
      });

      test('should return false if IDs are different', () {
        final ref1 = DraftRef(id: id, ver: ver1);
        final ref2 = DraftRef(id: otherId, ver: ver1);

        expect(ref1.contains(ref2), isFalse);
      });

      test('should return true if parent is loose (ver is null)', () {
        final looseParent = DraftRef(id: id);
        final exactChild = DraftRef(id: id, ver: ver1);
        final looseChild = DraftRef(id: id);

        // Loose parent contains exact child of same ID
        expect(looseParent.contains(exactChild), isTrue);
        // Loose parent contains loose child of same ID
        expect(looseParent.contains(looseChild), isTrue);
      });

      test('should return true if both are exact and versions match', () {
        final ref1 = DraftRef(id: id, ver: ver1);
        final ref2 = DraftRef(id: id, ver: ver1);

        expect(ref1.contains(ref2), isTrue);
      });

      test('should return false if parent is exact and versions differ', () {
        final parent = DraftRef(id: id, ver: ver1);
        final child = DraftRef(id: id, ver: ver2);

        expect(parent.contains(child), isFalse);
      });

      test('should return false if parent is exact and child is loose', () {
        // An exact version cannot contain "all" versions
        final exactParent = DraftRef(id: id, ver: ver1);
        final looseChild = DraftRef(id: id);

        expect(exactParent.contains(looseChild), isFalse);
      });
    });
  });

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

  test('fresh generates new id and version for first document', () {
    final originalRef = DraftRef.generateFirstRef();
    final freshRef = originalRef.fresh();

    expect(originalRef.id, isNot(freshRef.id));
    expect(originalRef.ver, isNot(freshRef.ver));
  });

  test('fresh generates new version only for subsequent document', () {
    final originalRef = DraftRef.generateFirstRef();
    final subsequentRef = DraftRef(id: originalRef.id, ver: const Uuid().v7());
    final freshRef = subsequentRef.fresh();

    expect(originalRef.id, equals(freshRef.id));
    expect(originalRef.ver, isNot(freshRef.ver));
  });
}
