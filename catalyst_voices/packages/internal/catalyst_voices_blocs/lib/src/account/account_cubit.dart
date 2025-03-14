import 'dart:async';

import 'package:catalyst_voices_blocs/src/account/account_state.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

final class AccountCubit extends Cubit<AccountState> {
  final UserService _userService;

  AccountCubit(
    this._userService,
  ) : super(_buildState(from: _userService.user.activeAccount)) {
    // TODO(damian-molinski): watch active account from _userService
  }

  @override
  Future<void> close() {
    // TODO(damian-molinski): cancel user subscription to _userService
    return super.close();
  }

  Future<void> deleteActiveKeychain() async {
    final account = _userService.user.activeAccount;
    if (account != null) {
      await _userService.removeAccount(account);
    }
  }

  Future<void> loadAccountDetails() async {
    // TODO(damian-molinski): Integration
  }

  Future<void> updateEmail(Email value) async {
    // TODO(damian-molinski): Integration
  }

  static AccountState _buildState({Account? from}) {
    final roles = from?.roles ?? const {};
    final catalystId = from?.catalystId;

    final accountRolesItems = AccountRole.values
        .where((role) => !role.isHidden)
        .map(
          (role) => MyAccountRoleItem(
            type: role,
            isSelected: roles.contains(role),
          ),
        )
        .toList();

    return AccountState(
      status: const AccountFinalized(),
      catalystId: catalystId,
      displayName: DisplayName.pure(catalystId?.username ?? ''),
      email: Email.pure(from?.email ?? ''),
      roles: AccountRolesState(
        items: accountRolesItems,
        canAddRole: accountRolesItems.any((item) => !item.isSelected),
      ),
      walletConnected: from?.stakeAddress ?? '',
    );
  }
}
