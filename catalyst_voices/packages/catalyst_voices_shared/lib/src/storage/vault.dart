import 'package:catalyst_voices_shared/src/storage/lock_factor.dart';
import 'package:catalyst_voices_shared/src/storage/storage.dart';

/// allows to read / write only when unlocked
abstract interface class Vault implements Storage {
  Future<bool> get isLocked;

  Future<void> lock();

  Future<bool> unlock(LockFactor lockFactor);

  Future<void> updateLockFactor(LockFactor lockFactor);
}
