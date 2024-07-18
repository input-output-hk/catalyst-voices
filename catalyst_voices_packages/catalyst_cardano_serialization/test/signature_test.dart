import 'package:catalyst_cardano_serialization/src/signature.dart';
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

  group(Ed25519PrivateKey, () {
    final message = List.generate(256, (i) => i);
    final reverseMessage = List.generate(256, (i) => 256 - i);
    final privateKey = Ed25519PrivateKey.seeded(1);

    test('derivePublicKey', () async {
      expect(
        await privateKey.derivePublicKey(),
        equals(
          Ed25519PublicKey.fromHex(
            '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
          ),
        ),
      );
    });

    test('KeyPair from seed equals private key', () async {
      final keyPair = await Ed25519KeyPair.fromSeed(privateKey.bytes);
      expect(keyPair.privateKey, equals(privateKey));
    });

    test('sign and verify', () async {
      final signature = await privateKey.sign(message);
      final keyPair = await Ed25519KeyPair.fromSeed(privateKey.bytes);

      expect(
        signature,
        equals(
          Ed25519Signature.fromHex(
            '38be3f06b38db12c27898e52dd8b82a3c13a1b6f9b8ffda65'
            'ccfe1bd54923c7693c3478a5ca6265487fbd1a1e249ddf1a6'
            '041c234c4144c1ea9818c7274b300c',
          ),
        ),
      );

      expect(
        await signature.verify(message, publicKey: keyPair.publicKey),
        isTrue,
      );

      expect(
        await signature.verify(reverseMessage, publicKey: keyPair.publicKey),
        isFalse,
      );
    });

    test('seeded has correct length', () {
      expect(
        Ed25519PrivateKey.seeded(2).bytes.length,
        equals(Ed25519PrivateKey.length),
      );
    });
  });

  group(Ed25519Signature, () {
    test('seeded has correct length', () {
      expect(
        Ed25519Signature.seeded(3).bytes.length,
        equals(Ed25519Signature.length),
      );
    });
  });
}
