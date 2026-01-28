import 'dart:async';

import 'package:catalyst_voices_blocs/catalyst_voices_blocs.dart';
import 'package:catalyst_voices_blocs/src/session/session_cubit_cache.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:catalyst_voices_view_models/catalyst_voices_view_models.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

bool _alwaysAllowRegistration = kDebugMode;

@visibleForTesting
// ignore: avoid_positional_boolean_parameters
set alwaysAllowRegistration(bool newValue) {
  _alwaysAllowRegistration = newValue;
}

/// Manages the user session and provides access to the user settings, account, and admin tools.
final class SessionCubit extends Cubit<SessionState>
    with BlocErrorEmitterMixin, BlocSignalEmitterMixin<SessionSignal, SessionState> {
  final UserService _userService;
  final RegistrationService _registrationService;
  final RegistrationProgressNotifier _registrationProgressNotifier;
  final AccessControl _accessControl;
  final AdminTools _adminTools;
  final FeatureFlagsService _featureFlagsService;
  final ProposalService _proposalService;

  final _logger = Logger('SessionCubit');

  SessionCubitCache _cache = const SessionCubitCache();

  StreamSubscription<UserSettings>? _userSettingsSub;
  StreamSubscription<bool>? _keychainUnlockedSub;
  StreamSubscription<Account?>? _accountSub;
  StreamSubscription<AdminToolsState>? _adminToolsSub;
  StreamSubscription<bool>? _votingFeatureFlagValueSub;
  StreamSubscription<bool>? _hasProposalActionsSub;

  SessionCubit(
    this._userService,
    this._registrationService,
    this._registrationProgressNotifier,
    this._accessControl,
    this._adminTools,
    this._featureFlagsService,
    this._proposalService,
  ) : super(const SessionState.initial());

  Future<bool> checkAvailableWallets() async {
    final wallets = await _registrationService.getCardanoWallets().onError((_, __) => const []);

    _cache = _cache.copyWith(hasWallets: wallets.isNotEmpty);

    if (!isClosed) {
      _updateState();
    }

    return _alwaysAllowRegistration || _cache.hasWallets;
  }

  @override
  Future<void> close() async {
    await _userSettingsSub?.cancel();
    _userSettingsSub = null;

    await _keychainUnlockedSub?.cancel();
    _keychainUnlockedSub = null;

    _registrationProgressNotifier.removeListener(_onRegistrationProgressChanged);

    await _accountSub?.cancel();
    _accountSub = null;

    await _adminToolsSub?.cancel();
    _adminToolsSub = null;

    await _votingFeatureFlagValueSub?.cancel();
    _votingFeatureFlagValueSub = null;

    await _hasProposalActionsSub?.cancel();
    _hasProposalActionsSub = null;

    return super.close();
  }

  /// Initializes all stream subscriptions for the session cubit.
  /// This should be called once when the app starts, after dependencies are initialized.
  void init() {
    _userSettingsSub = _userService.watchUser
        .map((user) => user.settings)
        .distinct()
        .listen(_handleUserSettings);

    _keychainUnlockedSub = _userService.watchUnlockedActiveAccount
        .map((account) => account != null)
        .distinct()
        .listen(_onActiveKeychainUnlockChanged);

    _registrationProgressNotifier.addListener(_onRegistrationProgressChanged);

    _accountSub = _userService.watchUser
        .map((user) => user.activeAccount)
        .listen(_onActiveAccountChanged);

    _adminToolsSub = _adminTools.stream.listen(_onAdminToolsChanged);

    _votingFeatureFlagValueSub = _featureFlagsService
        .watchFeatureFlag(Features.voting)
        .listen(_onVotingFeatureFlagChanged);

    _initProposalActionsSubscription();

    if (!_alwaysAllowRegistration) {
      unawaited(checkAvailableWallets());
    }

    _cache = _cache.copyWith(adminToolsState: _adminTools.state);
  }

  Future<void> lock() async {
    await _userService.user.activeAccount?.keychain.lock();
  }

  @override
  void onChange(Change<SessionState> change) {
    super.onChange(change);
    _shouldEmitKeychainSignals(change);
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

  Future<bool> unlock(LockFactor lockFactor) async {
    final keychain = _userService.user.activeAccount?.keychain;
    if (keychain == null) {
      return false;
    }

    return keychain.unlock(lockFactor);
  }

  void updateShowSubmissionClosingWarning({required bool value}) {
    final settings = _userService.user.settings;

    final updatedSettings = settings.copyWith(showSubmissionClosingWarning: Optional.of(value));

    unawaited(_userService.updateSettings(updatedSettings));
  }

  void updateTheme(ThemePreferences value) {
    final settings = _userService.user.settings;

    final updatedSettings = settings.copyWith(theme: Optional.of(value));

    unawaited(_userService.updateSettings(updatedSettings));
  }

  void updateTimezone(TimezonePreferences value) {
    final settings = _userService.user.settings;

    final updatedSettings = settings.copyWith(timezone: Optional.of(value));

    unawaited(_userService.updateSettings(updatedSettings));
  }

  SessionState _createMockedSessionState() {
    final sessionStatus = _cache.adminToolsState?.sessionStatus ?? SessionStatus.visitor;
    final isVotingFeatureFlagEnabled = _cache.isVotingFeatureFlagEnabled;
    final hasProposalsActions = _cache.hasProposalsActions;

    switch (sessionStatus) {
      case SessionStatus.actor:
        final spaces = isVotingFeatureFlagEnabled
            ? Space.values
            : (List.of(Space.values)..remove(Space.voting));
        final spacesShortcuts = isVotingFeatureFlagEnabled
            ? AccessControl.allSpacesShortcutsActivators
            : (Map.of(AccessControl.allSpacesShortcutsActivators)..remove(Space.voting));
        return SessionState(
          status: SessionStatus.actor,
          account: SessionAccount.mocked(),
          spaces: spaces,
          overallSpaces: spaces,
          spacesShortcuts: spacesShortcuts,
          canCreateAccount: true,
          hasProposalsActions: hasProposalsActions,
        );
      case SessionStatus.guest:
        return SessionState.guest(
          canCreateAccount: true,
          hasProposalsActions: hasProposalsActions,
        );
      case SessionStatus.visitor:
        return SessionState.visitor(
          isRegistrationInProgress: false,
          canCreateAccount: true,
          hasProposalActions: hasProposalsActions,
        );
    }
  }

  SessionState _createSessionState() {
    final account = _cache.account;
    final userSettings = _cache.userSettings;
    final isUnlocked = _cache.account?.keychain.lastIsUnlocked ?? false;
    final canCreateAccount = _alwaysAllowRegistration || _cache.hasWallets;

    final sessionSettings = userSettings != null
        ? SessionSettings.fromUser(userSettings)
        : const SessionSettings.fallback();

    if (account == null) {
      final isEmpty = _registrationProgressNotifier.value.isEmpty;
      return SessionState.visitor(
        canCreateAccount: canCreateAccount,
        isRegistrationInProgress: !isEmpty,
        settings: sessionSettings,
        hasProposalActions: _cache.hasProposalsActions,
      );
    }

    if (!isUnlocked) {
      return SessionState.guest(
        canCreateAccount: canCreateAccount,
        settings: sessionSettings,
        hasProposalsActions: _cache.hasProposalsActions,
      );
    }

    final sessionAccount = SessionAccount.fromAccount(account);
    final isVotingFeatureFlagEnabled = _cache.isVotingFeatureFlagEnabled;

    final spaces = isVotingFeatureFlagEnabled
        ? _accessControl.spacesAccess(account)
        : (List.of(_accessControl.spacesAccess(account))..remove(Space.voting));
    final overallSpaces = isVotingFeatureFlagEnabled
        ? _accessControl.overallSpaces(account)
        : (List.of(_accessControl.overallSpaces(account))..remove(Space.voting));
    final spacesShortcuts = isVotingFeatureFlagEnabled
        ? _accessControl.spacesShortcutsActivators(account)
        : (Map.of(_accessControl.spacesShortcutsActivators(account))..remove(Space.voting));

    return SessionState(
      status: SessionStatus.actor,
      account: sessionAccount,
      spaces: spaces,
      overallSpaces: overallSpaces,
      spacesShortcuts: spacesShortcuts,
      canCreateAccount: canCreateAccount,
      settings: sessionSettings,
      hasProposalsActions: _cache.hasProposalsActions,
    );
  }

  void _emitAccountBasedSignal() {
    final account = _cache.account;

    if (account == null || !account.keychain.lastIsUnlocked) {
      emitSignal(const CancelAccountNeedsVerificationSignal());
      return;
    }

    if (account.email != null && !account.publicStatus.isVerified) {
      final isProposer = account.hasRole(AccountRole.proposer);
      emitSignal(AccountNeedsVerificationSignal(isProposer: isProposer));
    }
  }

  Future<Account> _getDummyAccount() async {
    final dummyAccount = _userService.user.accounts.firstWhereOrNull((e) => e.isDummy);

    return dummyAccount ?? await _registrationService.createDummyAccount();
  }

  void _handleUserSettings(UserSettings settings) {
    _cache = _cache.copyWith(userSettings: Optional(settings));

    _updateState();
  }

  void _initProposalActionsSubscription() {
    unawaited(_hasProposalActionsSub?.cancel());
    _hasProposalActionsSub = null;

    final account = _cache.account;
    if (account == null) {
      _cache = _cache.copyWith(hasProposalsActions: false);
      return;
    }

    _hasProposalActionsSub = _proposalService
        .watchInvitesApprovalsCount(id: account.catalystId)
        .map((count) => count.hasActions)
        .distinct()
        .listen(_onHasProposalActionsChanged);
  }

  void _onActiveAccountChanged(Account? account) {
    _logger.fine('Active account changed [$account]');

    _cache = _cache.copyWith(account: Optional(account));

    _initProposalActionsSubscription();
    _emitAccountBasedSignal();
    _updateState();
  }

  void _onActiveKeychainUnlockChanged(bool isUnlocked) {
    _logger.fine('Keychain unlock changed [$isUnlocked]');

    _emitAccountBasedSignal();
    _updateState();
  }

  void _onAdminToolsChanged(AdminToolsState adminTools) {
    _logger.fine('Admin tools changed: $adminTools');

    _cache = _cache.copyWith(adminToolsState: adminTools);
    _updateState();
  }

  void _onHasProposalActionsChanged(bool hasActions) {
    _logger.fine('Has proposal actions changed: $hasActions');

    _cache = _cache.copyWith(hasProposalsActions: hasActions);
    _updateState();
  }

  void _onRegistrationProgressChanged() {
    _updateState();
  }

  void _onVotingFeatureFlagChanged(bool isEnabled) {
    _logger.fine('Voting feature flag changed: $isEnabled');

    _cache = _cache.copyWith(isVotingFeatureFlagEnabled: isEnabled);
    _updateState();
  }

  void _shouldEmitKeychainSignals(Change<SessionState> change) {
    // Emit keychain lock/unlock signals based on state transitions
    // We deliberately check if previous was guest because we don't
    // want to show the snackbar after the registration is completed.
    final prevStatus = change.currentState.status;
    final nextStatus = change.nextState.status;

    final keychainUnlocked = prevStatus == SessionStatus.guest && nextStatus == SessionStatus.actor;
    final keychainLocked = prevStatus == SessionStatus.actor && nextStatus == SessionStatus.guest;

    if (keychainUnlocked) {
      emitSignal(const KeychainUnlockedSignal());
    } else if (keychainLocked) {
      emitSignal(const KeychainLockedSignal());
    }
  }

  void _updateState() {
    final adminToolsState = _cache.adminToolsState;
    if (adminToolsState?.enabled ?? false) {
      emit(_createMockedSessionState());
    } else {
      emit(_createSessionState());
    }
  }
}
