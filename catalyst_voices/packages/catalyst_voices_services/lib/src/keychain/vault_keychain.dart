import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _seedPhraseKey = 'seed_phrase_key';
const _accountRolesKey = 'account_roles_key';

final class VaultKeychain extends SecureStorageVault implements Keychain {
  final KeyDerivation _keyDerivation;

  /// See [SecureStorageVault.isStorageKey].
  static bool isKeychainKey(String value) {
    return SecureStorageVault.isStorageKey(value);
  }

  /// See [SecureStorageVault.getStorageId].
  static String getStorageId(String value) {
    return SecureStorageVault.getStorageId(value);
  }

  VaultKeychain({
    required super.id,
    super.secureStorage,
    required KeyDerivation keyDerivation,
  }) : _keyDerivation = keyDerivation;

  @override
  Future<bool> get isValid {
    return Future.wait([
      hasLock,
      hasSeed,
      hasProfile,
    ]).then((value) => value.every((element) => element == true));
  }

  @override
  Future<bool> get hasSeed => _readSeedPhrase().then((value) => value != null);

  @override
  Future<bool> get hasProfile => _readProfile().then((value) => value != null);

  @override
  Future<void> seed(SeedPhrase seedPhrase) {
    return _writeSeedPhrase(seedPhrase);
  }

  @override
  Future<void> setProfile(Profile profile) {
    return _writeProfile(profile);
  }

  // TODO(dtscalac): in the future when key derivation algorithm spec
  // will become stable consider to store derived keys instead of deriving
  // them each time they are needed.
  @override
  Future<Ed25519KeyPair> key() async {
    final seedPhrase = await _readSeedPhrase();
    final profile = await _readProfile();

    if (seedPhrase == null || profile == null) {
      throw StateError('Keychain is not valid');
    }

    final role = profile.roles.first;

    return _keyDerivation.deriveAccountRoleKeyPair(
      seedPhrase: seedPhrase,
      role: role,
    );
  }

  Future<SeedPhrase?> _readSeedPhrase() async {
    final hexEntropy = await readString(key: _seedPhraseKey);

    return hexEntropy != null ? SeedPhrase.fromHexEntropy(hexEntropy) : null;
  }

  Future<void> _writeSeedPhrase(SeedPhrase? seedPhrase) {
    final hexEntropy = seedPhrase?.hexEntropy;

    return writeString(hexEntropy, key: _seedPhraseKey);
  }

  /// Note. in future this method will need proper serialization.
  Future<void> _writeProfile(Profile? profile) {
    final roles = profile?.roles.map((e) => e.name).join(' ');

    return writeString(roles, key: _accountRolesKey);
  }

  /// Note. in future this method will need proper deserialization.
  Future<Profile?> _readProfile() async {
    final rawRoles = await readString(key: _accountRolesKey);
    if (rawRoles == null) {
      return null;
    }

    final roles = rawRoles.split(' ').map(AccountRole.values.byName).toSet();

    return Profile(roles: roles);
  }

  @override
  String toString() => 'VaultKeychain[$id]';
}
