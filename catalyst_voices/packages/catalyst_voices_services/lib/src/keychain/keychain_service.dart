import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/keychain/key_derivation_service.dart';
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
class KeychainService {
  final _logger = Logger('KeychainService');

  final KeyDerivationService _keyDerivationService;
  final Vault _vault;

  KeychainService(this._keyDerivationService, this._vault);

  /// Returns true if the keychain is unlocked, false otherwise.
  Future<bool> get isUnlocked => _vault.isUnlocked;

  /// Returns true if the keychain contains the seed phrase, false otherwise.
  Future<bool> get hasSeedPhrase async => _hasSeedPhrase;

  /// Initializes the keychain with [seedPhrase] and the [unlockFactor].
  ///
  /// In most cases the [unlockFactor] is going to be
  /// an instance of a [PasswordLockFactor].
  Future<void> init({
    required SeedPhrase seedPhrase,
    required LockFactor unlockFactor,
  }) async {
    _logger.info('init');
    await _vault.setLock(unlockFactor);
    await _vault.unlock(unlockFactor);
    await _writeSeedPhrase(seedPhrase);
  }

  /// Removes the keychain and all associated data.
  Future<void> remove() async {
    _logger.info('remove');
    await _ensureUnlocked();
    await _vault.delete(key: _seedPhraseKey);
    await _vault.setLock(const VoidLockFactor());
    await _vault.lock();
  }

  /// Unlocks the keychain.
  ///
  /// The [unlock] factor must be the same [LockFactor]
  /// as provided to the [init].
  ///
  /// In most cases the [unlock] is going to be
  /// an instance of a [PasswordLockFactor].
  Future<void> unlock(LockFactor unlock) async {
    _logger.info('unlock');
    await _vault.unlock(unlock);
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
      return _keyDerivationService.deriveAccountRoleKeyPair(
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

  Future<bool> get _hasSeedPhrase async {
    return _vault.containsString(key: _seedPhraseKey);
  }

  Future<SeedPhrase?> _readSeedPhrase() async {
    final hexEntropy = await _vault.readString(key: _seedPhraseKey);
    if (hexEntropy != null) {
      return SeedPhrase.fromHexEntropy(hexEntropy);
    } else {
      return null;
    }
  }

  Future<void> _writeSeedPhrase(SeedPhrase seedPhrase) async {
    await _vault.writeString(seedPhrase.hexEntropy, key: _seedPhraseKey);
  }
}
