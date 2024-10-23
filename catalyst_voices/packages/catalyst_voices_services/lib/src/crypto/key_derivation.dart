import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:ed25519_hd_key/ed25519_hd_key.dart';

/// Derives key pairs from a seed phrase.
final class KeyDerivation {
  const KeyDerivation();

  /// Derives an [Ed25519KeyPair] from a [seedPhrase] and [path].
  ///
  /// Example [path]: m/0'/2147483647'
  ///
  // TODO(dtscalac): this takes around 2.5s to execute, optimize it
  // or move to a JS web worker.
  Future<Ed25519KeyPair> deriveKeyPair({
    required SeedPhrase seedPhrase,
    required String path,
  }) async {
    final masterKey = await ED25519_HD_KEY.derivePath(
      path,
      seedPhrase.uint8ListSeed,
    );

    final privateKey = masterKey.key;
    final publicKey = await ED25519_HD_KEY.getPublicKey(privateKey, false);

    return Ed25519KeyPair(
      publicKey: Ed25519PublicKey.fromBytes(publicKey),
      privateKey: Ed25519PrivateKey.fromBytes(privateKey),
    );
  }

  /// Derives the [Ed25519KeyPair] for the [role] from a [seedPhrase].
  Future<Ed25519KeyPair> deriveAccountRoleKeyPair({
    required SeedPhrase seedPhrase,
    required AccountRole role,
  }) async {
    return deriveKeyPair(
      seedPhrase: seedPhrase,
      path: _roleKeyDerivationPath(role),
    );
  }

  /// The path feed into key derivation algorithm
  /// to generate a key pair from a seed phrase.
  ///
  // TODO(dtscalac): update when RBAC specifies it
  String _roleKeyDerivationPath(AccountRole role) {
    return "m/${role.roleNumber}'/1234'";
  }
}
