import 'dart:typed_data';

import 'package:catalyst_voices_models/src/crypto/catalyst_private_key.dart';
import 'package:catalyst_voices_models/src/crypto/catalyst_signature.dart';
import 'package:catalyst_voices_models/src/user/account_role.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class Keychain implements Lockable, ActiveAware {
  String get id;

  Future<bool> get isEmpty;

  Future<void> erase();

  Future<CatalystPrivateKey?> getMasterKey();

  Future<void> setMasterKey(CatalystPrivateKey key);

  Future<CatalystSignature> sign(Uint8List message, {required AccountRole role});
}
