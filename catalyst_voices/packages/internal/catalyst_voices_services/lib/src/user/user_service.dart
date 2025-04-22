import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserService implements ActiveAware {
  factory UserService(
    UserRepository userRepository,
    UserObserver userObserver,
  ) = UserServiceImpl;

  User get user;

  Stream<User> get watchUser;

  Future<void> dispose();

  Future<User> getUser();

  Future<bool> isActiveAccountEmailVerified();

  /// Registers a new [account] and makes it active.
  ///
  /// It can invoke some one-time registration logic,
  /// contrary to [useAccount] which doesn't have such logic.
  Future<void> registerAccount(Account account);

  Future<void> removeAccount(Account account);

  Future<void> updateAccount({
    required CatalystId id,
    Optional<String>? username,
    Optional<String>? email,
    Set<AccountRole>? roles,
  });

  Future<void> updateSettings(UserSettings newValue);

  /// Make the [account] active one. If it doesn't exist then it'll be created.
  Future<void> useAccount(Account account);

  Future<void> useLastAccount();
}

// TODO(damian-molinski): Refactor to move most logic to UserRepository
final class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final UserObserver _userObserver;

  UserServiceImpl(
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
  Future<User> getUser() => _userRepository.getUser();

  @override
  Future<bool> isActiveAccountEmailVerified() async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    final email = activeAccount?.email;
    if (activeAccount == null || email == null) {
      return false;
    }

    // If already verified just return true.
    if (email.status == AccountEmailVerificationStatus.verified) {
      return true;
    }

    // Ask backend if status changed.
    final status = await _userRepository.getEmailStatus();
    if (status != email.status) {
      final updatedEmail = email.copyWith(status: status);
      final updatedAccount = activeAccount.copyWith(
        email: Optional(updatedEmail),
      );

      final updatedUser = user.updateAccount(updatedAccount);

      await _updateUser(updatedUser);
    }

    return status == AccountEmailVerificationStatus.verified;
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

    // updating email must be after updating user so that
    // the request is sent with correct access token
    final accountEmail = account.email;
    if (accountEmail != null) {
      unawaited(_userRepository.updateEmail(accountEmail.email));
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
      final emailData = email.data;

      if (emailData != null) {
        await _userRepository.updateEmail(emailData);
      }

      final accountEmail =
          emailData != null ? AccountEmail.pending(emailData) : null;
      updatedAccount = updatedAccount.copyWith(email: Optional(accountEmail));
    }

    if (roles != null) {
      updatedAccount = updatedAccount.copyWith(roles: roles);
    }

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
