import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class Keychain implements Lockable, ActiveAware {
  String get id;

  Future<bool> get isEmpty;

  Future<void> erase();

  Future<CatalystPrivateKey?> getMasterKey();

  Future<void> setMasterKey(CatalystPrivateKey key);
}
