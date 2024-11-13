import 'package:catalyst_key_derivation/catalyst_key_derivation.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/lockable.dart';

abstract interface class Keychain implements Lockable {
  String get id;

  Future<bool> get isEmpty;

  Future<KeychainMetadata> get metadata;

  Future<Bip32Ed25519XPrivateKey?> getMasterKey();

  Future<void> setMasterKey(Bip32Ed25519XPrivateKey key);

  Future<void> clear();
}
