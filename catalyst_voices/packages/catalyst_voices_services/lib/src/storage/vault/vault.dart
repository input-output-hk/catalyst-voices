import 'package:catalyst_voices_services/src/storage/storage.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';

/// Secure version of [Storage] where any read/write methods can take
/// effect only when [isUnlocked] returns true.
///
/// In order to unlock [Vault] sufficient [LockFactor] have to be
/// set via [unlock] that can unlock [LockFactor] from [setLock].
abstract interface class Vault implements Storage {
  /// Returns true when have sufficient [LockFactor] from [unlock].
  Future<bool> get isUnlocked;

  /// Returns whether currently have active lock from [setLock].
  Future<bool> get hasLock;

  /// Deletes unlockFactor if have any.
  Future<void> lock();

  /// Changes [isUnlocked] when [unlock] can unlock [LockFactor]
  /// from [setLock].
  Future<bool> unlock(LockFactor unlock);

  /// Sets [LockFactor] that which prevents read/write on this [Vault]
  /// unless unlocked with matching [LockFactor] via [unlock].
  Future<void> setLock(LockFactor lock);
}
