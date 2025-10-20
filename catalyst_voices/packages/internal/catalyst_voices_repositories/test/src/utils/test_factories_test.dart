import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  group(DocumentRefFactory, () {
    test('randomUuidV7 generates uuids with incremental timestamp', () {
      final id1 = DocumentRefFactory.randomUuidV7();
      final id2 = DocumentRefFactory.randomUuidV7();

      final ts1 = UuidV7.parseDateTime(id1).millisecondsSinceEpoch;
      final ts2 = UuidV7.parseDateTime(id2).millisecondsSinceEpoch;

      expect(id1, isNot(equals(id2)));
      expect(ts1, lessThan(ts2));
    });

    test('draftRef generates unique refs', () {
      final ref1 = DocumentRefFactory.draftRef();
      final ref2 = DocumentRefFactory.draftRef();

      expect(ref1, isNot(equals(ref2)));
    });

    test('signedDocumentRef generates unique refs', () {
      final ref1 = DocumentRefFactory.signedDocumentRef();
      final ref2 = DocumentRefFactory.signedDocumentRef();

      expect(ref1, isNot(equals(ref2)));
    });
  });
}
