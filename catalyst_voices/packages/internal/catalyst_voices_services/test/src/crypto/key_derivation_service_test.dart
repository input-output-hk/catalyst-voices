import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation_service.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(KeyDerivationService, () {
    final seedPhrase = SeedPhrase.fromMnemonic(
      'few loyal swift champion rug peace dinosaur'
      ' erase bacon tone install universe',
    );

    late _FakeCatalystKeyDerivation catalystKeyDerivation;
    late KeyDerivationService keyDerivation;
    late FakeCatalystPrivateKey masterKey;

    setUp(() {
      catalystKeyDerivation = _FakeCatalystKeyDerivation();
      keyDerivation = KeyDerivationService(catalystKeyDerivation);
      masterKey = FakeCatalystPrivateKey(bytes: Uint8List.fromList([1]));
    });

    test('should generate master key from a seed phrase', () async {
      final privateKey = await keyDerivation.deriveMasterKey(seedPhrase: seedPhrase);
      expect(privateKey.bytes, isNotEmpty);
    });

    test('should generate key pair with different valid paths', () async {
      for (final role in AccountRole.values) {
        final keyPair = await keyDerivation.deriveKeyPair(
          masterKey: masterKey,
          path: "m/${role.number}'/1234'",
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

class _FakeCatalystKeyDerivation extends Fake implements CatalystKeyDerivation {
  @override
  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    return FakeBip32Ed25519XPrivateKey(mnemonic.codeUnits);
  }
}
