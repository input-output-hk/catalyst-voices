import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class Lockable {
  /// Returns true when have sufficient [LockFactor] from [unlock].
  Future<bool> get isUnlocked;

  /// Emits current value on when starts and any updates.
  Stream<bool> get watchIsUnlocked;

  /// Deletes unlockFactor if have any.
  Future<void> lock();

  /// Changes [isUnlocked] when [unlock] can unlock [LockFactor]
  /// from [setLock].
  Future<bool> unlock(LockFactor unlock);

  /// Sets [LockFactor] that which prevents read/write on this [Vault]
  /// unless unlocked with matching [LockFactor] via [unlock].
  Future<void> setLock(LockFactor lock);
}
