import 'dart:typed_data';

import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
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
    late _FakeCatalystPrivateKey masterKey;

    setUp(() {
      catalystKeyDerivation = _FakeCatalystKeyDerivation();
      keyDerivation = KeyDerivationService(catalystKeyDerivation);
      masterKey = _FakeCatalystPrivateKey(bytes: Uint8List.fromList([1]));
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

class _FakeBip32Ed25519XPrivateKey extends Fake implements Bip32Ed25519XPrivateKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPrivateKey({required this.bytes});

  @override
  Future<Bip32Ed25519XPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return _FakeBip32Ed25519XPrivateKey(bytes: path.codeUnits);
  }

  @override
  Future<Bip32Ed25519XPublicKey> derivePublicKey() async {
    return _FakeBip32Ed25519XPublicKey(bytes: bytes);
  }
}

class _FakeBip32Ed25519XPublicKey extends Fake implements Bip32Ed25519XPublicKey {
  @override
  final List<int> bytes;

  _FakeBip32Ed25519XPublicKey({required this.bytes});
}

class _FakeCatalystKeyDerivation extends Fake implements CatalystKeyDerivation {
  @override
  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required String mnemonic,
  }) async {
    return _FakeBip32Ed25519XPrivateKey(bytes: mnemonic.codeUnits);
  }
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey({required this.bytes});

  @override
  Future<CatalystPrivateKey> derivePrivateKey({
    required String path,
  }) async {
    return _FakeCatalystPrivateKey(bytes: Uint8List.fromList(path.codeUnits));
  }

  @override
  Future<CatalystPublicKey> derivePublicKey() async {
    return _FakeCatalystPublicKey(bytes: bytes);
  }
}

class _FakeCatalystPublicKey extends Fake implements CatalystPublicKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPublicKey({required this.bytes});
}
