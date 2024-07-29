import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:test/test.dart';

void main() {
  group(UuidV4, () {
    const uuidString = '550e8400-e29b-41d4-a716-446655440000';
    final uuid = UuidV4.fromString(uuidString);

    test('Uuid fromBytes', () {
      expect(UuidV4.fromBytes(uuid.bytes), equals(uuid));
    });

    test('UuidV4 fromString', () {
      expect(UuidV4.fromString(uuidString).toUuidString(), equals(uuidString));
    });

    test('Uuid fromCbor', () {
      expect(UuidV4.fromCbor(uuid.toCbor()), equals(uuid));
    });
  });
}
