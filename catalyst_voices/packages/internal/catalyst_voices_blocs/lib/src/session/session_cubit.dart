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
  final DummyUserService _dummyUserService;
  final RegistrationService _registrationService;
  final RegistrationProgressNotifier _registrationProgressNotifier;
  final AccessControl _accessControl;
  final AdminToolsCubit _adminToolsCubit;

  final _logger = Logger('SessionCubit');

  bool _hasKeychain = false;
  bool _isUnlocked = false;
  Account? _account;
  AdminToolsState _adminToolsState;

  StreamSubscription<bool>? _keychainSub;
  StreamSubscription<bool>? _keychainUnlockedSub;
  StreamSubscription<Account?>? _accountSub;
  StreamSubscription<AdminToolsState>? _adminToolsSub;

  SessionCubit(
    this._userService,
    this._dummyUserService,
    this._registrationService,
    this._registrationProgressNotifier,
    this._accessControl,
    this._adminToolsCubit,
  )   : _adminToolsState = _adminToolsCubit.state,
        super(const VisitorSessionState(isRegistrationInProgress: false)) {
    _keychainSub = _userService.watchKeychain
        .map((keychain) => keychain != null)
        .distinct()
        .listen(_onHasKeychainChanged);

    _keychainUnlockedSub = _userService.watchKeychain
        .transform(KeychainToUnlockTransformer())
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);

    _registrationProgressNotifier.addListener(_onRegistrationProgressChanged);

    _accountSub = _userService.watchAccount.listen(_onActiveAccountChanged);

    _adminToolsSub = _adminToolsCubit.stream.listen(_onAdminToolsChanged);
  }

  Future<bool> unlock(LockFactor lockFactor) {
    return _userService.keychain!.unlock(lockFactor);
  }

  Future<void> lock() async {
    await _userService.keychain!.lock();
  }

  Future<void> removeKeychain() {
    return _userService.removeCurrentKeychain();
  }

  Future<void> switchToDummyAccount() async {
    final keychains = await _userService.keychains;
    final dummyKeychain = keychains.firstWhereOrNull(
      (keychain) => keychain.id == DummyUserService.dummyKeychainId,
    );

    if (dummyKeychain != null) {
      await _userService.useKeychain(dummyKeychain.id);
      return;
    }

    final account = await _registrationService.registerTestAccount(
      keychainId: DummyUserService.dummyKeychainId,
      seedPhrase: DummyUserService.dummySeedPhrase,
      lockFactor: DummyUserService.dummyUnlockFactor,
    );

    await _userService.useAccount(account);
  }

  @override
  Future<void> close() async {
    await _keychainSub?.cancel();
    _keychainSub = null;

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

  void _onHasKeychainChanged(bool hasKeychain) {
    _logger.fine('Has keychain changed [$hasKeychain]');

    _hasKeychain = hasKeychain;
    _updateState();
  }

  void _onActiveKeychainUnlockChanged(bool isUnlocked) {
    _logger.fine('Keychain unlock changed [$isUnlocked]');

    _isUnlocked = isUnlocked;
    _updateState();
  }

  void _onActiveAccountChanged(Account? account) {
    _logger.fine('Active account changed [$account]');

    _account = account;
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
    final hasKeychain = _hasKeychain;
    final isUnlocked = _isUnlocked;
    final account = _account;

    if (!hasKeychain) {
      final isEmpty = _registrationProgressNotifier.value.isEmpty;
      return VisitorSessionState(isRegistrationInProgress: !isEmpty);
    }

    if (!isUnlocked) {
      return const GuestSessionState();
    }

    final spaces = _accessControl.spacesAccess(account);
    final overallSpaces = _accessControl.overallSpaces(account);
    final spacesShortcuts = _accessControl.spacesShortcutsActivators(account);

    return ActiveAccountSessionState(
      account: account,
      spaces: spaces,
      overallSpaces: overallSpaces,
      spacesShortcuts: spacesShortcuts,
    );
  }

  SessionState _createMockedSessionState() {
    switch (_adminToolsState.sessionStatus) {
      case SessionStatus.actor:
        return ActiveAccountSessionState(
          account: _dummyUserService.getDummyAccount(),
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
}
