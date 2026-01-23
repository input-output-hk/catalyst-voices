import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:rxdart/rxdart.dart';

extension UnlockedActiveAccountTransformer on Stream<User> {
  /// Transforms a stream of [User] into a stream of the active [Account]
  /// only when that account's keychain is unlocked.
  Stream<Account?> toUnlockedActiveAccount() {
    return map((user) => user.activeAccount).switchMap((account) {
      if (account == null) return Stream.value(null);

      final isUnlockedStream = account.keychain.watchIsUnlocked;
      return isUnlockedStream.map((isUnlocked) => isUnlocked ? account : null);
    }).distinct();
  }
}
