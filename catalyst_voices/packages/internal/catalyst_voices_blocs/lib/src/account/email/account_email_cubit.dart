import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

final class AccountEmailCubit extends Cubit<AccountEmailState> {
  final _logger = Logger('AccountEmailCubit');
  final UserService _userService;

  StreamSubscription<Account?>? _accountSub;

  AccountEmailCubit(this._userService) : super(const AccountEmailState()) {
    _accountSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .distinct()
        .listen(_handleActiveAccountChange);
  }

  @override
  Future<void> close() async {
    await _accountSub?.cancel();
    _accountSub = null;

    return super.close();
  }

  void _handleActiveAccountChange(Account? account) {
    _logger.fine('Active account changed [$account]');
    emit(state.copyWith(account: Optional(account)));
  }
}
