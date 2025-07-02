import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

/// A secure storage that holds the user master key in an encrypted form.
/// 
/// To access the data the keychain must be unlocked by calling [unlock].
/// Attempting to access the data when the keychain has been [lock]ed will trigger an error.
abstract interface class Keychain implements Lockable, ActiveAware {
  String get id;

  Future<bool> get isEmpty;

  Future<void> erase();

  Future<CatalystPrivateKey?> getMasterKey();

  Future<void> setMasterKey(CatalystPrivateKey key);
}
