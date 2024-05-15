import 'package:catalyst_cardano_serialization/src/witness.dart';
import 'package:test/test.dart';

void main() {
  group(Vkey, () {
    test('seeded has correct length', () {
      expect(
        Vkey.seeded(1).bytes.length,
        equals(Vkey.length),
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
