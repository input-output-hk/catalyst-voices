import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:flutter/foundation.dart';

// TODO(damian-molinski): Extract lockable interface.
// TODO(damian-molinski): UserService / UserStorage.
// TODO(damian-molinski): RegistrationProgressStorage.
abstract interface class Keychain {
  String get id;

  Future<bool> get isEmpty;

  Future<bool> get isUnlocked;

  Future<KeychainMetadata> get metadata;

  Future<void> setLock(LockFactor lockFactor);

  Future<bool> unlock(LockFactor lockFactor);

  Future<void> lock();

  Future<Uint8List?> getRootKey();

  Future<void> setRootKey(Uint8List data);

  Future<void> clear();
}
