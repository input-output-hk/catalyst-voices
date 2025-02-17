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

  Future<User> getUser();

  Future<void> useLastAccount();

  Future<void> useAccount(Account account);

  Future<void> removeAccount(Account account);

  Future<void> updateSettings(UserSettings newValue);

  Future<void> dispose();
}

final class UserServiceImpl implements UserService {
  final UserRepository _userRepository;
  final UserObserver _userObserver;

  UserServiceImpl(
    this._userRepository,
    this._userObserver,
  );

  @override
  User get user => _userObserver.user;

  @override
  Stream<User> get watchUser => _userObserver.watchUser;

  @override
  bool get isActive => _userObserver.isActive;

  @override
  set isActive(bool value) => _userObserver.isActive = value;

  @override
  Future<User> getUser() => _userRepository.getUser();

  @override
  Future<void> useLastAccount() async {
    final user = await _userRepository.getUser();

    await _updateUser(user);
  }

  @override
  Future<void> useAccount(Account account) async {
    var user = await getUser();

    if (!user.hasAccount(catalystId: account.catalystId)) {
      user = user.addAccount(account);
    }

    user = user.useAccount(catalystId: account.catalystId);

    await _updateUser(user);
  }

  @override
  Future<void> removeAccount(Account account) async {
    var user = await getUser();

    if (user.hasAccount(catalystId: account.catalystId)) {
      user = user.removeAccount(catalystId: account.catalystId);
    }

    if (user.activeAccount == null) {
      final firstAccount = user.accounts.firstOrNull;
      if (firstAccount != null) {
        user = user.useAccount(catalystId: firstAccount.catalystId);
      }
    }

    await _updateUser(user);

    await account.keychain.erase();
  }

  @override
  Future<void> updateSettings(UserSettings newValue) async {
    final user = await getUser();

    final updatedUser = user.copyWith(settings: newValue);

    await _updateUser(updatedUser);
  }

  Future<void> _updateUser(User user) async {
    await _userRepository.saveUser(user);
    _userObserver.user = user;
  }

  @override
  Future<void> dispose() async {}
}
