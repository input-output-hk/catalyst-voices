import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/lockable.dart';
import 'package:catalyst_voices_services/src/storage/storage.dart';

/// Secure version of [Storage] where any read/write methods can take
/// effect only when [isUnlocked] returns true.
///
/// In order to unlock [Vault] sufficient [LockFactor] have to be
/// set via [unlock] that can unlock [LockFactor] from [setLock].
abstract interface class Vault implements Storage, Lockable {
  String get id;
}
