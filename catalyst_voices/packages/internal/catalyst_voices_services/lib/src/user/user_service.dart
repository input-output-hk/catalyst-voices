import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';

/// [UserService] allows to manage user accounts.
/// [watchUser] returns a stream of user changes which allows to react to user changes.
abstract interface class UserService implements ActiveAware {
  factory UserService(
    UserRepository userRepository,
    UserObserver userObserver,
  ) = UserServiceImpl;

  User get user;

  Stream<User> get watchUser;

  Future<void> dispose();

  /// If updating a registration the new registration must be
  /// linked via the transaction hash to the last one.
  ///
  /// The method returns the last known transaction ID.
  Future<TransactionHash> getPreviousRegistrationTransactionId();

  /// Simple [User] getter.
  Future<User> getUser();

  /// Checks if active account is verified in reviews API.
  Future<bool> isActiveAccountPubliclyVerified();

  /// Fetches info about recovered account.
  ///
  /// This does not recover the account,
  /// it only does the lookup if there's an account to recover.
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  });

  /// Refreshes the active account with the latest profile from the server.
  Future<void> refreshActiveAccountProfile();

  /// Refreshes the active account with the voting power from the server.
  Future<void> refreshActiveAccountVotingPower();

  /// Registers a new [account] and makes it active.
  ///
  /// It can invoke some one-time registration logic,
  /// contrary to [useAccount] which doesn't have such logic.
  ///
  /// Throws [EmailAlreadyUsedException] if [Account.email] already taken.
  ///
  /// Due to impossibility to validate the email before registering
  /// the account will be still registered and afterwards
  /// the [EmailAlreadyUsedException] thrown in case of non-unique email.
  Future<void> registerAccount(Account account);

  /// Removes [account] from current [User] (if such account found).
  Future<void> removeAccount(Account account);

  /// Removes all accounts from current [User].
  @visibleForTesting
  Future<void> removeAllAccounts();

  /// Throws [EmailAlreadyUsedException] if email already taken.
  Future<void> resendActiveAccountVerificationEmail();

  /// Throws [EmailAlreadyUsedException] if [email] already taken.
  ///
  /// Returns true if updated, false otherwise.
  Future<AccountUpdateResult> updateAccount({
    required CatalystId id,
    Optional<String>? username,
    String? email,
    Set<AccountRole>? roles,
    AccountRegistrationStatus? registrationStatus,
  });

  /// Updates [User]'s settings.
  Future<void> updateSettings(UserSettings newValue);

  /// Make the [account] active one. If it doesn't exist then it'll be created.
  Future<void> useAccount(Account account);

  /// Tries to lookup user locally and stores it in [UserObserver].
  Future<void> useLocalUser();
}

final class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final UserObserver _userObserver;
  final RegistrationStatusPoller _registrationStatusPoller;

  UserServiceImpl(
    this._userRepository,
    this._userObserver,
  ) : _registrationStatusPoller = RegistrationStatusPoller(_userRepository);

  @override
  bool get isActive => _userObserver.isActive;

  @override
  set isActive(bool value) => _userObserver.isActive = value;

  @override
  User get user => _userObserver.user;

  @override
  Stream<User> get watchUser => _userObserver.watchUser;

  @override
  Future<void> dispose() async {
    _registrationStatusPoller.stop();
  }

  @override
  Future<TransactionHash> getPreviousRegistrationTransactionId() {
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      throw ArgumentError.notNull('activeAccount');
    }

    return _userRepository.getPreviousRegistrationTransactionId(
      catalystId: activeAccount.catalystId,
    );
  }

  @override
  Future<User> getUser() => _userRepository.getUser();

  @override
  Future<bool> isActiveAccountPubliclyVerified() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return false;
    }

    if (!activeAccount.registrationStatus.isIndexed) {
      return false;
    }

    // If already verified just return true.
    if (activeAccount.publicStatus.isVerified || activeAccount.isDummy) {
      return true;
    }

    // Ask backend if status changed.
    final publicProfile = await _userRepository.getAccountPublicProfile();
    if (publicProfile == null) {
      return false;
    }

    if (publicProfile.status != activeAccount.publicStatus) {
      final updatedAccount = activeAccount.copyWith(publicStatus: publicProfile.status);
      final updatedUser = user.updateAccount(updatedAccount);
      await _updateUser(updatedUser);
    }

    return publicProfile.status.isVerified;
  }

  @override
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  }) {
    return _userRepository.recoverAccount(
      catalystId: catalystId,
      rbacToken: rbacToken,
    );
  }

  @override
  Future<void> refreshActiveAccountProfile() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return;
    }

    if (!activeAccount.publicStatus.isNotSetup && activeAccount.registrationStatus.isIndexed) {
      final publicProfile = await _userRepository.getAccountPublicProfile();
      final publicProfileStatus = publicProfile?.status ?? AccountPublicStatus.unknown;
      final updatedAccount = activeAccount.copyWith(
        email: Optional(publicProfile?.email),
        publicStatus: publicProfileStatus,
      );
      final updatedUser = user.updateAccount(updatedAccount);

      await _updateUser(updatedUser);
    }
  }

  @override
  Future<void> refreshActiveAccountVotingPower() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return;
    }

    final votingPower = await _userRepository.getVotingPower();
    if (votingPower != activeAccount.votingPower) {
      final updatedAccount = activeAccount.copyWith(votingPower: Optional(votingPower));
      final updatedUser = user.updateAccount(updatedAccount);
      await _updateUser(updatedUser);
    }
  }

  @override
  Future<void> registerAccount(Account account) async {
    var user = await getUser();

    if (user.hasAccount(id: account.catalystId)) {
      throw StateError(
        'The account must not be registered, id: ${account.catalystId}',
      );
    }

    user = user.addAccount(account);
    user = user.useAccount(id: account.catalystId);

    await _updateUser(user);

    final email = account.email;
    if (email != null) {
      // updating user profile must be after updating user so that
      // the request is sent with correct access token
      await _userRepository.publishUserProfile(
        catalystId: account.catalystId,
        email: email,
      );
    }
  }

  @override
  Future<void> removeAccount(Account account) async {
    var user = await getUser();

    if (user.hasAccount(id: account.catalystId)) {
      user = user.removeAccount(id: account.catalystId);
    }

    if (user.activeAccount == null) {
      final firstAccount = user.accounts.firstOrNull;
      if (firstAccount != null) {
        user = user.useAccount(id: firstAccount.catalystId);
      }
    }

    await _updateUser(user);

    await account.keychain.erase();
  }

  @override
  Future<void> removeAllAccounts() async {
    var user = await getUser();

    for (final account in user.accounts) {
      await account.keychain.erase();
    }

    user = user.copyWith(accounts: []);

    await _updateUser(user);
  }

  @override
  Future<void> resendActiveAccountVerificationEmail() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    final email = activeAccount?.email;
    if (activeAccount == null || email == null || email.isEmpty) {
      return;
    }

    await _userRepository.publishUserProfile(
      catalystId: activeAccount.catalystId,
      email: email,
    );

    final updatedAccount = activeAccount.copyWith(
      publicStatus: AccountPublicStatus.verifying,
    );
    final updatedUser = user.updateAccount(updatedAccount);

    await _updateUser(updatedUser);
  }

  @override
  Future<AccountUpdateResult> updateAccount({
    required CatalystId id,
    Optional<String>? username,
    String? email,
    Set<AccountRole>? roles,
    AccountRegistrationStatus? registrationStatus,
  }) async {
    final user = await getUser();
    if (!user.hasAccount(id: id)) {
      return const AccountUpdateResult();
    }
    final account = user.getAccount(id);
    final didEmailChange = email != null && account.email != email;
    final didUsernameChange = username != null && account.username != username.data;

    var didChanged = false;
    var hasPendingEmailChange = false;

    var updatedAccount = account.copyWith();

    if (didUsernameChange) {
      final catalystId = updatedAccount.catalystId.copyWith(username: username);
      updatedAccount = updatedAccount.copyWith(catalystId: catalystId);
    }

    if (roles != null) {
      updatedAccount = updatedAccount.copyWith(roles: roles);
    }

    // username is part of catalystId
    if (didUsernameChange || didEmailChange) {
      final currentEmail = email ?? updatedAccount.email;
      final wasVerified = account.publicStatus.isVerified;

      if (currentEmail != null) {
        final publicProfile = account.isDummy
            ? AccountPublicProfile(
                email: currentEmail,
                username: updatedAccount.username,
                status: AccountPublicStatus.verified,
              )
            : await _userRepository.publishUserProfile(
                catalystId: updatedAccount.catalystId,
                email: currentEmail,
              );

        final isVerified = publicProfile.status.isVerified;
        final didEffectiveChangeEmail = account.email != publicProfile.email;

        // when account was verified and changing email, the change won't be applied until
        // new email is verified. We can't downgrade verification.
        if (didEmailChange && (!didEffectiveChangeEmail || (wasVerified && !isVerified))) {
          hasPendingEmailChange = true;
        } else {
          updatedAccount = updatedAccount.copyWith(
            email: Optional(publicProfile.email),
            publicStatus: publicProfile.status,
          );
        }
      }
    }

    if (registrationStatus != null) {
      updatedAccount = updatedAccount.copyWith(registrationStatus: registrationStatus);
    }

    if (updatedAccount != account) {
      didChanged = true;

      final updatedUser = user.updateAccount(updatedAccount);

      await _updateUser(updatedUser);
    }

    return AccountUpdateResult(
      didChanged: didChanged,
      hasPendingEmailChange: hasPendingEmailChange,
    );
  }

  @override
  Future<void> updateSettings(UserSettings newValue) async {
    final user = await getUser();

    final updatedUser = user.copyWith(settings: newValue);

    await _updateUser(updatedUser);
  }

  @override
  Future<void> useAccount(Account account) async {
    var user = await getUser();

    if (user.hasAccount(id: account.catalystId)) {
      user = user.updateAccount(account);
    } else {
      user = user.addAccount(account);
    }

    user = user.useAccount(id: account.catalystId);

    await _updateUser(user);
  }

  @override
  Future<void> useLocalUser() async {
    final user = await _userRepository.getUser();

    await _updateUser(user);
  }

  void _updateRegistrationStatusPoller({
    Account? current,
    Account? previous,
  }) {
    if (current == null || current.registrationStatus.isIndexed) {
      _registrationStatusPoller.stop();
      return;
    }

    // Same account
    if (previous != null && current.isSameRef(previous)) {
      return;
    }

    _registrationStatusPoller.start(
      current,
      onChanged: (registrationStatus) {
        unawaited(updateAccount(id: current.catalystId, registrationStatus: registrationStatus));

        // At the moment this is all we need to know
        if (registrationStatus.isIndexed) _registrationStatusPoller.stop();
      },
    );
  }

  Future<void> _updateUser(User user) async {
    final previousActiveAccount = _userObserver.user.activeAccount;
    final currentActiveAccount = user.activeAccount;

    await _userRepository.saveUser(user);
    _userObserver.user = user;
    _updateRegistrationStatusPoller(current: currentActiveAccount, previous: previousActiveAccount);
  }
}
