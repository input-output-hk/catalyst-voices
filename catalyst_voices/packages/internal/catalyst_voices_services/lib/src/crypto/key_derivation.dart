import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';

/// Derives key pairs from a seed phrase.
final class KeyDerivation {
  /// See: https://github.com/input-output-hk/catalyst-voices/pull/1300
  static const int _purpose = 508;
  static const int _type = 139;
static const int _account = 0; // Future Use
  final CatalystKeyDerivation _keyDerivation;

  const KeyDerivation(this._keyDerivation);

  Future<Bip32Ed25519XPrivateKey> deriveMasterKey({
    required SeedPhrase seedPhrase,
  }) {
    return _keyDerivation.deriveMasterKey(
      mnemonic: seedPhrase.mnemonic,
    );
  }

  /// Derives an [Ed25519KeyPair] from a [masterKey] and [path].
  ///
  /// Example [path]: m/0'/2147483647'
  Future<Bip32Ed25519XKeyPair> deriveKeyPair({
    required Bip32Ed25519XPrivateKey masterKey,
    required String path,
  }) async {
    final privateKey = await masterKey.derivePrivateKey(path: path);
    final publicKey = await privateKey.derivePublicKey();

    return Bip32Ed25519XKeyPair(
      publicKey: publicKey,
      privateKey: privateKey,
    );
  }

  /// Derives the [Ed25519KeyPair] for the [role] from a [masterKey].
  Future<Bip32Ed25519XKeyPair> deriveAccountRoleKeyPair({
    required Bip32Ed25519XPrivateKey masterKey,
    required AccountRole role,
  }) async {
    return deriveKeyPair(
      masterKey: masterKey,
      path: _roleKeyDerivationPath(role),
    );
  }

  /// The path feed into key derivation algorithm
  /// to generate a key pair from a seed phrase.
  String _roleKeyDerivationPath(AccountRole role) {
    return "m/$_purpose'/$_type'/$_account'/${role.number}/0";
  }
}
