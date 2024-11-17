import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/key_derivation.dart';
import 'package:mocktail/mocktail.dart';
import 'package:test/test.dart';

void main() {
  group(KeyDerivation, () {
    final seedPhrase = SeedPhrase.fromMnemonic(
      'few loyal swift champion rug peace dinosaur'
      ' erase bacon tone install universe',
    );

    late _FakeCatalystKeyDerivation catalystKeyDerivation;
    late KeyDerivation keyDerivation;
    late _FakeBip32Ed22519XPrivateKey masterKey;

    setUp(() {
      catalystKeyDerivation = _FakeCatalystKeyDerivation();
      keyDerivation = KeyDerivation(catalystKeyDerivation);
      masterKey = _FakeBip32Ed22519XPrivateKey(bytes: [1]);
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

class _FakeCatalystKeyDerivation extends Fake implements CatalystKeyDerivation {
  @override
  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    return _FakeBip32Ed22519XPrivateKey(bytes: mnemonic.codeUnits);
  }
}

class _FakeBip32Ed22519XPrivateKey extends Fake
    implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed22519XPrivateKey({required this.bytes});

  @override
  Future<Bip32Ed25519XPublicKey> derivePublicKey() async {
    return _FakeBip32Ed25519XPublicKey(bytes: bytes);
  }

  @override
  Future<Bip32Ed25519XPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return _FakeBip32Ed22519XPrivateKey(bytes: path.codeUnits);
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake
    implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPublicKey({required this.bytes});
}
