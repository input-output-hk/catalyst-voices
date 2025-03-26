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

  Future<void> removeAccount(Account account);

  Future<void> updateActiveAccount({
    Optional<String>? username,
    String? email,
  });

  Future<void> updateSettings(UserSettings newValue);

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
  Future<void> updateActiveAccount({
    Optional<String>? username,
    String? email,
  }) async {
    final user = await getUser();
    final activeAccount = user.activeAccount;
    if (activeAccount == null) {
      return;
    }

    var updatedAccount = activeAccount.copyWith();

    if (username != null) {
      final catalystId = activeAccount.catalystId.copyWith(username: username);
      updatedAccount = activeAccount.copyWith(catalystId: catalystId);
    }

    // TODO(damian-molinski): post it to cat-reviews
    if (email != null) {
      // updatedAccount = activeAccount.copyWith(email: email);
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

    if (!user.hasAccount(id: account.catalystId)) {
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
