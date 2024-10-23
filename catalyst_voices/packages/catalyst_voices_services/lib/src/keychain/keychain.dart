import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/lockable.dart';
import 'package:flutter/foundation.dart';

abstract interface class Keychain implements Lockable {
  String get id;

  Future<bool> get isEmpty;

  Future<KeychainMetadata> get metadata;

  Future<Uint8List?> getRootKey();

  Future<void> setRootKey(Uint8List data);

  Future<void> clear();
}
