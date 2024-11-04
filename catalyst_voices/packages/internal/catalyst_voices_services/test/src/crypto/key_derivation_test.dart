import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation.dart';
import 'package:test/test.dart';

void main() {
  group(KeyDerivation, () {
    late KeyDerivation keyDerivation;
    late SeedPhrase seedPhrase;
    late Ed25519ExtendedPrivateKey masterKey;

    setUp(() {
      keyDerivation = const KeyDerivation(CatalystKeyDerivation());
      seedPhrase = SeedPhrase.fromMnemonic(
        'few loyal swift champion rug peace dinosaur'
        ' erase bacon tone install universe',
      );
      masterKey = Ed25519ExtendedPrivateKey.seeded(0);
    });

    test('should generate master key from a seed phrase', () async {
      final privateKey =
          await keyDerivation.deriveMasterKey(seedPhrase: seedPhrase);
      expect(privateKey.bytes, isNotEmpty);
    });

    test('should generate key pair with different valid paths', () async {
      for (final role in AccountRole.values) {
        final keyPair = await keyDerivation.deriveKeyPair(
          masterKey: masterKey,
          path: "m/${role.roleNumber}'/1234'",
        );
        expect(keyPair, isNotNull);
      }
    });

    test('should generate key pair with different valid roles', () async {
      for (final role in AccountRole.values) {
        final keyPair = await keyDerivation.deriveAccountRoleKeyPair(
          masterKey: masterKey,
          role: role,
        );
        expect(keyPair, isNotNull);
      }
    });
  });
}
