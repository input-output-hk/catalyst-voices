import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/crypto/bip32_ed25519_catalyst_private_key.dart';

/// Derives key pairs from a seed phrase.
abstract interface class KeyDerivationService {
  const factory KeyDerivationService(CatalystKeyDerivation keyDerivation) =
      KeyDerivationServiceImpl;

  /// Derives the [CatalystKeyPair] for the [role] from a [masterKey].
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  });

  /// Derives an [CatalystKeyPair] from a [masterKey] and [path].
  ///
  /// Example [path]: m/0'/2147483647'
  Future<CatalystKeyPair> deriveKeyPair({
    required CatalystPrivateKey masterKey,
    required String path,
  });

  Future<CatalystPrivateKey> deriveMasterKey({
    required SeedPhrase seedPhrase,
  });
}

final class KeyDerivationServiceImpl implements KeyDerivationService {
  /// See: https://github.com/input-output-hk/catalyst-voices/pull/1300
  static const int _purpose = 508;
  static const int _type = 139;
  static const int _account = 0; // Future Use
  final CatalystKeyDerivation _keyDerivation;

  const KeyDerivationServiceImpl(this._keyDerivation);

  @override
  Future<CatalystKeyPair> deriveAccountRoleKeyPair({
    required CatalystPrivateKey masterKey,
    required AccountRole role,
  }) async {
    return deriveKeyPair(
      masterKey: masterKey,
      path: _roleKeyDerivationPath(role),
    );
  }

  @override
  Future<CatalystKeyPair> deriveKeyPair({
    required CatalystPrivateKey masterKey,
    required String path,
  }) async {
    final privateKey = await masterKey.derivePrivateKey(path: path);
    final publicKey = await privateKey.derivePublicKey();

    return CatalystKeyPair(
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }

  @override
  Future<CatalystPrivateKey> deriveMasterKey({
    required SeedPhrase seedPhrase,
  }) async {
    final privateKey = await _keyDerivation.deriveMasterKey(
      mnemonic: seedPhrase.mnemonic,
    );

    return Bip32Ed25519XCatalystPrivateKey(privateKey);
  }

  /// The path feed into key derivation algorithm
  /// to generate a key pair from a seed phrase.
  String _roleKeyDerivationPath(AccountRole role) {
    return "m/$_purpose'/$_type'/$_account'/${role.number}/0";
  }
}
