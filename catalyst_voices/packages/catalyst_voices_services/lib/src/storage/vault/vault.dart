import 'package:catalyst_voices_services/src/storage/storage.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';

/// allows to read / write only when unlocked
abstract interface class Vault implements Storage {
  Future<bool> get isUnlocked;

  Future<void> lock();

  Future<bool> unlock(LockFactor lockFactor);

  Future<void> updateLockFactor(LockFactor lockFactor);
}
