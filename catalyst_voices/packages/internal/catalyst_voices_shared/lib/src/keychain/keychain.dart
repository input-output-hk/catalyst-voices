import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class Keychain implements Lockable, ActiveAware {
  String get id;

  Future<bool> get isEmpty;

  Future<Bip32Ed25519XPrivateKey?> getMasterKey();

  Future<void> setMasterKey(Bip32Ed25519XPrivateKey key);

  Future<void> clear();
}
