import 'package:catalyst_voices_models/catalyst_voices_models.dart';

abstract interface class Lockable {
  /// Returns true when have sufficient [LockFactor] from [unlock].
  Future<bool> get isUnlocked;

  /// Returns last known state of unlock. Effectively synchronous getter for
  /// [watchIsUnlocked].
  bool get lastIsUnlocked;

  /// Emits current value on when starts and any updates.
  Stream<bool> get watchIsUnlocked;

  /// Deletes unlockFactor if have any.
  Future<void> lock();

  /// Sets [LockFactor] that which prevents read/write on this [Lockable]
  /// unless unlocked with matching [LockFactor] via [unlock].
  Future<void> setLock(LockFactor lock);

  /// Changes [isUnlocked] when [unlock] can unlock [LockFactor]
  /// from [setLock].
  ///
  /// When [dryRun] is true then it will not change [isUnlocked] and will
  /// act as verification if [LockFactor] is valid. Use case would be to verify if
  /// user can unlock [Lockable].
  Future<bool> unlock(LockFactor unlock, {bool dryRun = false});
}
