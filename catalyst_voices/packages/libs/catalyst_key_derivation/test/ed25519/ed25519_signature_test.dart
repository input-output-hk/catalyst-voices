import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:test/test.dart';

void main() {
  group(Ed25519Signature, () {
    test('seeded has correct length', () {
      expect(
        Ed25519Signature.seeded(3).bytes.length,
        equals(Ed25519Signature.length),
      );
    });
  });
}
