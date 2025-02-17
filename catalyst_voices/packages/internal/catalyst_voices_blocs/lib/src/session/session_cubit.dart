import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

bool _alwaysAllowRegistration = kDebugMode;

@visibleForTesting
// ignore: avoid_positional_boolean_parameters
set alwaysAllowRegistration(bool newValue) {
  _alwaysAllowRegistration = newValue;
}

/// Manages the user session.
final class SessionCubit extends Cubit<SessionState>
    with BlocErrorEmitterMixin {
  final UserService _userService;
  final RegistrationService _registrationService;
  final RegistrationProgressNotifier _registrationProgressNotifier;
  final AccessControl _accessControl;
  final AdminTools _adminTools;

  final _logger = Logger('SessionCubit');

  UserSettings? _userSettings;
  Account? _account;
  AdminToolsState _adminToolsState;
  bool _hasWallets = false;

  StreamSubscription<UserSettings>? _userSettingsSub;
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
        super(const SessionState.initial()) {
    _userSettingsSub = _userService.watchUser
        .map((user) => user.settings)
        .distinct()
        .listen(_handleUserSettings);

    _keychainUnlockedSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .switchMap((account) {
          return account?.keychain.watchIsUnlocked ?? Stream.value(false);
        })
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);

    _registrationProgressNotifier.addListener(_onRegistrationProgressChanged);

    _accountSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .listen(_onActiveAccountChanged);

    _adminToolsSub = _adminTools.stream.listen(_onAdminToolsChanged);

    if (!_alwaysAllowRegistration) {
      unawaited(_checkAvailableWallets());
    }
  }

  Future<bool> unlock(LockFactor lockFactor) async {
    final keychain = _userService.user.activeAccount?.keychain;
    if (keychain == null) {
      return false;
    }

    return keychain.unlock(lockFactor);
  }

  Future<void> lock() async {
    await _userService.user.activeAccount?.keychain.lock();
  }

  Future<void> removeKeychain() async {
    final account = _userService.user.activeAccount;
    if (account != null) {
      await _userService.removeAccount(account);
    }
  }

  Future<void> switchToDummyAccount() async {
    final account = _userService.user.activeAccount;
    if (account?.isDummy ?? false) {
      return;
    }

    final dummyAccount = await _getDummyAccount();

    await _userService.useAccount(dummyAccount);
  }

  void updateTimezone(TimezonePreferences value) {
    final settings = _userService.user.settings;

    final updatedSettings = settings.copyWith(timezone: Optional.of(value));

    unawaited(_userService.updateSettings(updatedSettings));
  }

  void updateTheme(ThemePreferences value) {
    final settings = _userService.user.settings;

    final updatedSettings = settings.copyWith(theme: Optional.of(value));

    unawaited(_userService.updateSettings(updatedSettings));
  }

  @override
  Future<void> close() async {
    await _userSettingsSub?.cancel();
    _userSettingsSub = null;

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

  void _handleUserSettings(UserSettings settings) {
    _userSettings = settings;

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

  Future<void> _checkAvailableWallets() async {
    final wallets = await _registrationService
        .getCardanoWallets()
        .onError((_, __) => const []);

    _hasWallets = wallets.isNotEmpty;

    if (!isClosed) {
      _updateState();
    }
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
    final userSettings = _userSettings;
    final isUnlocked = _account?.keychain.lastIsUnlocked ?? false;
    final canCreateAccount = _alwaysAllowRegistration || _hasWallets;

    final sessionSettings = userSettings != null
        ? SessionSettings.fromUser(userSettings)
        : const SessionSettings.fallback();

    if (account == null) {
      final isEmpty = _registrationProgressNotifier.value.isEmpty;
      return SessionState.visitor(
        canCreateAccount: canCreateAccount,
        isRegistrationInProgress: !isEmpty,
        settings: sessionSettings,
      );
    }

    if (!isUnlocked) {
      return SessionState.guest(
        canCreateAccount: canCreateAccount,
        settings: sessionSettings,
      );
    }

    final sessionAccount = SessionAccount.fromAccount(account);
    final spaces = _accessControl.spacesAccess(account);
    final overallSpaces = _accessControl.overallSpaces(account);
    final spacesShortcuts = _accessControl.spacesShortcutsActivators(account);

    return SessionState(
      status: SessionStatus.actor,
      account: sessionAccount,
      spaces: spaces,
      overallSpaces: overallSpaces,
      spacesShortcuts: spacesShortcuts,
      canCreateAccount: canCreateAccount,
      settings: sessionSettings,
    );
  }

  SessionState _createMockedSessionState() {
    switch (_adminToolsState.sessionStatus) {
      case SessionStatus.actor:
        return SessionState(
          status: SessionStatus.actor,
          account: const SessionAccount.mocked(),
          spaces: Space.values,
          overallSpaces: Space.values,
          spacesShortcuts: AccessControl.allSpacesShortcutsActivators,
          canCreateAccount: true,
          settings: const SessionSettings.fallback(),
        );
      case SessionStatus.guest:
        return const SessionState.guest(
          canCreateAccount: true,
          settings: SessionSettings.fallback(),
        );
      case SessionStatus.visitor:
        return const SessionState.visitor(
          settings: SessionSettings.fallback(),
          isRegistrationInProgress: false,
          canCreateAccount: true,
        );
    }
  }

  Future<Account> _getDummyAccount() async {
    final dummyAccount =
        _userService.user.accounts.firstWhereOrNull((e) => e.isDummy);

    return dummyAccount ??
        await _registrationService.registerTestAccount(
          keychainId: Account.dummyKeychainId,
          seedPhrase: Account.dummySeedPhrase,
          lockFactor: Account.dummyUnlockFactor,
        );
  }
}
