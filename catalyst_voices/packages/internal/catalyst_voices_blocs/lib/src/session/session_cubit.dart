import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Manages the user session.
final class SessionCubit extends Cubit<SessionState>
    with BlocErrorEmitterMixin {
  final UserService _userService;
  final RegistrationService _registrationService;
  final RegistrationProgressNotifier _registrationProgressNotifier;
  final AccessControl _accessControl;
  final AdminTools _adminTools;

  final _logger = Logger('SessionCubit');

  Account? _account;
  AdminToolsState _adminToolsState;

  StreamSubscription<bool>? _keychainUnlockedSub;
  StreamSubscription<Account?>? _accountSub;
  StreamSubscription<AdminToolsState>? _adminToolsSub;

  SessionCubit(
    this._userService,
    this._registrationService,
    this._registrationProgressNotifier,
    this._accessControl,
    this._adminTools,
  )   : _adminToolsState = _adminTools.state,
        super(const VisitorSessionState(isRegistrationInProgress: false)) {
    _keychainUnlockedSub = _userService.watchAccount
        .transform(AccountToKeychainUnlockTransformer())
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);

    _registrationProgressNotifier.addListener(_onRegistrationProgressChanged);

    _accountSub = _userService.watchAccount.listen(_onActiveAccountChanged);

    _adminToolsSub = _adminTools.stream.listen(_onAdminToolsChanged);
  }

  Future<bool> unlock(LockFactor lockFactor) async {
    final keychain = _userService.account?.keychain;
    if (keychain == null) {
      return false;
    }

    return keychain.unlock(lockFactor);
  }

  Future<void> lock() async {
    await _userService.account?.keychain.lock();
  }

  Future<void> removeKeychain() async {
    final account = _userService.account;
    if (account != null) {
      await _userService.removeAccount(account);
    }
  }

  Future<void> switchToDummyAccount() async {
    final account = _userService.account;
    if (account?.isDummy ?? false) {
      return;
    }

    final dummyAccount = await _getDummyAccount();

    await _userService.useAccount(dummyAccount);
  }

  @override
  Future<void> close() async {
    await _keychainUnlockedSub?.cancel();
    _keychainUnlockedSub = null;

    _registrationProgressNotifier
        .removeListener(_onRegistrationProgressChanged);

    await _accountSub?.cancel();
    _accountSub = null;

    await _adminToolsSub?.cancel();
    _adminToolsSub = null;

    return super.close();
  }

  void _onActiveAccountChanged(Account? account) {
    _logger.fine('Active account changed [$account]');

    _account = account;

    _updateState();
  }

  void _onActiveKeychainUnlockChanged(bool isUnlocked) {
    _logger.fine('Keychain unlock changed [$isUnlocked]');

    _updateState();
  }

  void _onRegistrationProgressChanged() {
    _updateState();
  }

  void _onAdminToolsChanged(AdminToolsState adminTools) {
    _logger.fine('Admin tools changed: $adminTools');

    _adminToolsState = adminTools;
    _updateState();
  }

  void _updateState() {
    if (_adminToolsState.enabled) {
      emit(_createMockedSessionState());
    } else {
      emit(_createSessionState());
    }
  }

  SessionState _createSessionState() {
    final account = _account;
    final isUnlocked = _account?.keychain.lastIsUnlocked ?? false;

    if (account == null) {
      final isEmpty = _registrationProgressNotifier.value.isEmpty;
      return VisitorSessionState(isRegistrationInProgress: !isEmpty);
    }

    if (!isUnlocked) {
      return const GuestSessionState();
    }

    final sessionAccount = SessionAccount.fromAccount(account);
    final spaces = _accessControl.spacesAccess(account);
    final overallSpaces = _accessControl.overallSpaces(account);
    final spacesShortcuts = _accessControl.spacesShortcutsActivators(account);

    return ActiveAccountSessionState(
      account: sessionAccount,
      spaces: spaces,
      overallSpaces: overallSpaces,
      spacesShortcuts: spacesShortcuts,
    );
  }

  SessionState _createMockedSessionState() {
    switch (_adminToolsState.sessionStatus) {
      case SessionStatus.actor:
        return ActiveAccountSessionState(
          account: const SessionAccount.mocked(),
          spaces: Space.values,
          overallSpaces: Space.values,
          spacesShortcuts: AccessControl.allSpacesShortcutsActivators,
        );
      case SessionStatus.guest:
        return const GuestSessionState();
      case SessionStatus.visitor:
        return const VisitorSessionState(isRegistrationInProgress: false);
    }
  }

  Future<Account> _getDummyAccount() async {
    final dummyAccount =
        _userService.accounts.firstWhereOrNull((e) => e.isDummy);

    return dummyAccount ??
        await _registrationService.registerTestAccount(
          keychainId: Account.dummyKeychainId,
          seedPhrase: Account.dummySeedPhrase,
          lockFactor: Account.dummyUnlockFactor,
        );
  }
}
