import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/keychain/key_derivation.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault.dart';
import 'package:logging/logging.dart';

const _seedPhraseKey = 'keychain_seed_phrase';

/// The keychain which holds the user's [SeedPhrase] and allows
/// to derive the [Ed25519KeyPair] related to the [AccountRole].
///
// TODO(dtscalac): in the future when key derivation algorithm spec
// will become stable consider to store derived keys instead of deriving
// them each time they are needed.
final class Keychain {
  final _logger = Logger('Keychain');

  final KeyDerivation _keyDerivation;
  final Vault _vault;

  Keychain(this._keyDerivation, this._vault);

  /// Returns true if the keychain is unlocked, false otherwise.
  Future<bool> get isUnlocked => _vault.isUnlocked;

  /// Returns true if the keychain contains the seed phrase, false otherwise.
  Future<bool> get hasSeedPhrase async => _hasSeedPhrase;

  /// Initializes the keychain with [seedPhrase] and the [unlockFactor].
  ///
  /// In most cases the [unlockFactor] is going to be
  /// an instance of a [PasswordLockFactor].
  Future<void> setLockAndBeginWith({
    required SeedPhrase seedPhrase,
    required LockFactor unlockFactor,
    bool unlocked = true,
  }) async {
    _logger.info('setLockAndBeginWith, unlocked: $unlocked');
    await _changeLock(unlockFactor, unlocked: unlocked);
    await _beginWith(seedPhrase: seedPhrase);
  }

  /// Clears the keychain and all associated data.
  ///
  /// Locks the keychain and removes the lock factor
  /// from the underlying storage.
  Future<void> clearAndLock() async {
    _logger.info('clearAndLock');
    await _ensureUnlocked();
    await _vault.clear();
  }

  /// Unlocks the keychain.
  ///
  /// The [unlock] factor must be the same [LockFactor]
  /// as provided to the [setLockAndBeginWith].
  ///
  /// In most cases the [unlock] is going to be
  /// an instance of a [PasswordLockFactor].
  Future<bool> unlock(LockFactor unlock) async {
    _logger.info('unlock');
    return _vault.unlock(unlock);
  }

  /// Locks the keychain.
  Future<void> lock() async {
    _logger.info('lock');
    await _vault.lock();
  }

  /// Derives an [Ed25519KeyPair] related to the [role].
  ///
  /// The method can only be called when [isUnlocked] returns true.
  Future<Ed25519KeyPair> deriveKeyPair(AccountRole role) async {
    _logger.info('deriveKeyPair: $role');
    await _ensureUnlocked();

    final seedPhrase = await _readSeedPhrase();
    if (seedPhrase != null) {
      return _keyDerivation.deriveAccountRoleKeyPair(
        seedPhrase: seedPhrase,
        role: role,
      );
    } else {
      throw StateError('Cannot derive key pair without a seed phrase');
    }
  }

  Future<void> _ensureUnlocked() async {
    if (!await isUnlocked) {
      throw StateError('Keychain is locked, cannot proceed');
    }
  }

  Future<void> _changeLock(
    LockFactor lockFactor, {
    bool unlocked = false,
  }) async {
    await _vault.setLock(lockFactor);
    if (unlocked) {
      await _vault.unlock(lockFactor);
    } else {
      await _vault.lock();
    }
  }

  Future<void> _beginWith({
    required SeedPhrase seedPhrase,
  }) async {
    await _writeSeedPhrase(seedPhrase);
  }

  Future<bool> get _hasSeedPhrase async {
    return _vault.contains(key: _seedPhraseKey);
  }

  Future<SeedPhrase?> _readSeedPhrase() async {
    final hexEntropy = await _vault.readString(key: _seedPhraseKey);
    if (hexEntropy != null) {
      return SeedPhrase.fromHexEntropy(hexEntropy);
    } else {
      return null;
    }
  }

  // TODO(dtscalac): in the future when key derivation spec is more stable
  // the seed phrase should not be stored but only the master key that
  // is derived from the seed phrase
  Future<void> _writeSeedPhrase(SeedPhrase seedPhrase) async {
    await _vault.writeString(seedPhrase.hexEntropy, key: _seedPhraseKey);
  }
}
