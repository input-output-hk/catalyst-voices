import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';

final class AccountCubit extends Cubit<AccountState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<AccountSignal, AccountState> {
  final _logger = Logger('AccountCubit');
  final UserService _userService;

  StreamSubscription<Account?>? _accountSub;

  AccountCubit(
    this._userService,
  ) : super(_buildState(from: _userService.user.activeAccount)) {
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

  Future<void> deleteActiveKeychain() async {
    final account = _userService.user.activeAccount;
    if (account != null) {
      await _userService.removeAccount(account);
    }
  }

  Future<void> resendVerification() async {
    final activeAccount = _userService.user.activeAccount;
    final email = activeAccount?.email;
    if (email == null) {
      return;
    }

    try {
      await _userService.resendActiveAccountVerificationEmail();

      emitSignal(const AccountVerificationEmailSendSignal());
    } on EmailAlreadyUsedException catch (error, stackTrace) {
      _logger.severe('Re-send verification email - already used', error, stackTrace);
      emitError(const LocalizedEmailAlreadyUsedException());
    } catch (error, stackTrace) {
      _logger.severe('Re-send verification email', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  Future<void> updateAccountDetails() async {
    try {
      await _userService.updateActiveAccountDetails();
    } catch (error, stackTrace) {
      _logger.severe('Updating active account failed', error, stackTrace);
      emitError(LocalizedException.create(error));
    }
  }

  /// Returns true if updated, false otherwise.
  Future<bool> updateEmail(Email email) async {
    try {
      if (email.isNotValid) {
        return false;
      }

      final activeAccount = _userService.user.activeAccount;
      if (activeAccount != null) {
        await _userService.updateAccount(
          id: activeAccount.catalystId,
          email: email.value.isNotEmpty ? Optional(email.value) : const Optional.empty(),
        );
      }

      emit(state.copyWith(email: email));
      emitSignal(const AccountVerificationEmailSendSignal());

      return true;
    } on EmailAlreadyUsedException {
      _logger.info('Email already used');
      emitError(const LocalizedEmailAlreadyUsedException());
      return false;
    } catch (error, stackTrace) {
      _logger.severe('Update email', error, stackTrace);
      emitError(LocalizedException.create(error));
      return false;
    }
  }

  /// Returns true if updated, false otherwise.
  Future<bool> updateUsername(Username username) async {
    try {
      if (username.isNotValid) {
        return false;
      }

      final activeAccount = _userService.user.activeAccount;
      if (activeAccount != null) {
        final value = username.value;

        await _userService.updateAccount(
          id: activeAccount.catalystId,
          username: value.isNotEmpty ? Optional(value) : const Optional.empty(),
        );
      }

      emit(state.copyWith(username: username));
      return true;
    } catch (error, stackTrace) {
      _logger.severe('Update username', error, stackTrace);
      emitError(LocalizedException.create(error));
      return false;
    }
  }

  void _handleActiveAccountChange(Account? account) {
    emit(_buildState(from: account));
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
      catalystId: catalystId,
      username: Username.pure(catalystId?.username ?? ''),
      email: Email.pure(from?.email ?? ''),
      roles: AccountRolesState(
        items: accountRolesItems,
        canAddRole: accountRolesItems.any((item) => !item.isSelected),
      ),
      walletConnected: from?.address?.toBech32() ?? '',
      accountPublicStatus: from?.publicStatus ?? AccountPublicStatus.unknown,
    );
  }
}
