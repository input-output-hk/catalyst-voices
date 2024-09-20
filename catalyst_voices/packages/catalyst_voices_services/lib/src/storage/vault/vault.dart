import 'package:catalyst_voices_services/src/storage/storage.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';

/// Secure version of [Storage] where any read/write methods can take
/// effect only when [isUnlocked] returns true.
///
/// In order to unlock [Vault] sufficient [LockFactor] have to be
/// set via [unlock] that can unlock [LockFactor] from [setLockFactor].
///
/// See [LockFactor.unlocks] for more details.
abstract interface class Vault implements Storage {
  /// Returns true when have sufficient [LockFactor] from [unlock].
  Future<bool> get isUnlocked;

  /// Deletes unlockFactor if have any.
  Future<void> lock();

  /// Changes [isUnlocked] when [lockFactor] can unlock [LockFactor]
  /// from [setLockFactor].
  Future<bool> unlock(LockFactor lockFactor);

  /// Sets [LockFactor] that which prevents read/write on this [Vault]
  /// unless unlocked with matching [LockFactor] via [unlock].
  Future<void> setLockFactor(LockFactor lockFactor);
}
