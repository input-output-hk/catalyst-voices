import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

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
  Future<void> registerAccount(Account account);

  Future<void> removeAccount(Account account);

  Future<void> resendActiveAccountVerificationEmail();

  Future<void> updateAccount({
    required CatalystId id,
    Optional<String>? username,
    Optional<String>? email,
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
    final status = await _userRepository.getAccountPublicStatus();
    if (status != activeAccount.publicStatus) {
      final updatedAccount = activeAccount.copyWith(publicStatus: status);
      final updatedUser = user.updateAccount(updatedAccount);
      await _updateUser(updatedUser);
    }

    return status.isVerified;
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
      unawaited(
        _userRepository.publishUserProfile(
          catalystId: account.catalystId,
          email: email,
        ),
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
  Future<void> updateAccount({
    required CatalystId id,
    Optional<String>? username,
    Optional<String>? email,
    Set<AccountRole>? roles,
  }) async {
    final user = await getUser();
    if (!user.hasAccount(id: id)) {
      return;
    }
    final account = user.getAccount(id);

    var updatedAccount = account.copyWith();

    if (username != null) {
      final catalystId = updatedAccount.catalystId.copyWith(username: username);
      updatedAccount = updatedAccount.copyWith(catalystId: catalystId);
    }

    if (email != null) {
      updatedAccount = updatedAccount.copyWith(
        email: email,
        publicStatus: email.isEmpty ? AccountPublicStatus.notSetup : AccountPublicStatus.verifying,
      );
    }

    if (roles != null) {
      updatedAccount = updatedAccount.copyWith(roles: roles);
    }

    if (username != null || email != null) {
      final accountEmail = updatedAccount.email;
      if (accountEmail != null) {
        await _userRepository.publishUserProfile(
          catalystId: updatedAccount.catalystId,
          email: accountEmail,
        );
      }
    }

    final updatedUser = user.updateAccount(updatedAccount);

    await _updateUser(updatedUser);
  }

  @override
  Future<void> updateActiveAccountDetails() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return;
    }

    final publicStatus = await _userRepository.getAccountPublicStatus();
    final updatedAccount = activeAccount.copyWith(publicStatus: publicStatus);
    final updatedUser = user.updateAccount(updatedAccount);

    await _updateUser(updatedUser);
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
