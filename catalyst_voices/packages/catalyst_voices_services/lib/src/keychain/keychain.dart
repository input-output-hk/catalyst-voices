import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';

abstract interface class Keychain {
  Future<bool> get isUnlocked;

  Future<void> setLock(LockFactor lockFactor);

  Future<bool> unlock(LockFactor lockFactor);

  Future<void> lock();

  Future<void> setRootKey(List<int> key);

  Future<Ed25519KeyPair?> getRootKey();

  Future<void> clear();
}
