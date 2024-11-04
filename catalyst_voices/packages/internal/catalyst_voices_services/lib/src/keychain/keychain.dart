import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/lockable.dart';

abstract interface class Keychain implements Lockable {
  String get id;

  Future<bool> get isEmpty;

  Future<KeychainMetadata> get metadata;

  Future<Ed25519PrivateKey?> getMasterKey();

  Future<void> setMasterKey(Ed25519PrivateKey key);

  Future<void> clear();
}
