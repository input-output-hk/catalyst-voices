import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
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
}
