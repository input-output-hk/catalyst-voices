import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:collection/collection.dart';

abstract interface class UserService implements ActiveAware {
  const factory UserService(
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

  Future<User> getUser();

  Future<bool> isActiveAccountPubliclyVerified();

  /// Fetches info about recovered account.
  ///
  /// This does not recover the account,
  /// it only does the lookup if there's an account to recover.
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required RbacToken rbacToken,
  });

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

  Future<void> removeAccount(Account account);

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
  });

  Future<void> updateActiveAccountDetails();

  Future<void> updateSettings(UserSettings newValue);

  /// Make the [account] active one. If it doesn't exist then it'll be created.
  Future<void> useAccount(Account account);

  Future<void> useLastAccount();
}

// TODO(damian-molinski): Refactor to move most logic to UserRepository
final class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final UserObserver _userObserver;

  const UserServiceImpl(
    this._userRepository,
    this._userObserver,
  );

  @override
  bool get isActive => _userObserver.isActive;

  @override
  set isActive(bool value) => _userObserver.isActive = value;

  @override
  User get user => _userObserver.user;

  @override
  Stream<User> get watchUser => _userObserver.watchUser;

  @override
  Future<void> dispose() async {}

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

    // If already verified just return true.
    if (activeAccount.publicStatus.isVerified) {
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
        final publicProfile = await _userRepository.publishUserProfile(
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
  Future<void> updateActiveAccountDetails() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return;
    }

    if (!activeAccount.publicStatus.isNotSetup) {
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
  Future<void> useLastAccount() async {
    final user = await _userRepository.getUser();

    await _updateUser(user);
  }

  Future<void> _updateUser(User user) async {
    await _userRepository.saveUser(user);
    _userObserver.user = user;
  }
}
