import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:test/test.dart';

void main() {
  group(Ed25519PublicKey, () {
    test('seeded has correct length', () {
      expect(
        Ed25519PublicKey.seeded(1).bytes.length,
        equals(Ed25519PublicKey.length),
      );
    });
  });

  group(Ed25519Signature, () {
    test('seeded has correct length', () {
      expect(
        Ed25519Signature.seeded(2).bytes.length,
        equals(Ed25519Signature.length),
      );
    });
  });
}
