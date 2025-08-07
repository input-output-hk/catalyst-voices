import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:rxdart/rxdart.dart';

/// Manages the email status of the active account.
final class PublicProfileEmailStatusCubit extends Cubit<PublicProfileEmailStatusState> {
  final _logger = Logger('PublicProfileEmailStatusCubit');
  final UserService _userService;

  StreamSubscription<Account?>? _accountSub;
  StreamSubscription<bool>? _keychainUnlockedSub;

  PublicProfileEmailStatusCubit(this._userService) : super(const PublicProfileEmailStatusState()) {
    _accountSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .distinct()
        .listen(_handleActiveAccountChange);

    _keychainUnlockedSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .switchMap((account) {
          return account?.keychain.watchIsUnlocked ?? Stream.value(false);
        })
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);
  }

  @override
  Future<void> close() async {
    await _accountSub?.cancel();
    _accountSub = null;
    await _keychainUnlockedSub?.cancel();
    _keychainUnlockedSub = null;

    return super.close();
  }

  void _handleActiveAccountChange(Account? account) {
    _logger.fine('Active account changed [$account]');
    emit(
      state.copyWith(
        email: Optional(account?.email),
        isEmailVerified: account?.publicStatus.isVerified ?? false,
        isProposer: account?.hasRole(AccountRole.proposer) ?? false,
        isVisible: account != null,
      ),
    );
  }

  void _onActiveKeychainUnlockChanged(bool isUnlocked) {
    _logger.fine('Keychain unlock changed [$isUnlocked]');
    emit(
      state.copyWith(
        isUnlock: isUnlocked,
      ),
    );
  }
}
