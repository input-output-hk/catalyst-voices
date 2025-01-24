import 'dart:async';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserService implements ActiveAware {
  factory UserService({
    required UserRepository userRepository,
  }) {
    return UserServiceImpl(
      userRepository,
    );
  }

  User get user;

  Stream<User> get watchUser;

  Account? get account;

  List<Account> get accounts;

  Stream<Account?> get watchAccount;

  Future<User> getUser();

  Future<void> useLastAccount();

  Future<void> useAccount(Account account);

  Future<void> removeAccount(Account account);

  Future<void> updateSettings(UserSettings newValue);

  Future<void> dispose();
}

final class UserServiceImpl implements UserService {
  final UserRepository _userRepository;

  final _logger = Logger('UserService');

  User _user = const User.empty();
  final _userSC = StreamController<User>.broadcast();

  bool _isActive = true;

  UserServiceImpl(
    this._userRepository,
  );

  @override
  User get user => _user;

  @override
  Stream<User> get watchUser async* {
    yield user;
    yield* _userSC.stream;
  }

  @override
  Account? get account => _user.activeAccount;

  @override
  List<Account> get accounts => List.unmodifiable(_user.accounts);

  @override
  Stream<Account?> get watchAccount async* {
    yield account;
    yield* _userSC.stream.map((user) => user.activeAccount).distinct();
  }

  @override
  bool get isActive => _isActive;

  @override
  set isActive(bool value) {
    if (_isActive != value) {
      _isActive = value;
      _user.activeAccount?.keychain.isActive = value;
    }
  }

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

    if (!user.hasAccount(id: account.id)) {
      user = user.addAccount(account);
    }

    user = user.useAccount(id: account.id);

    await _updateUser(user);
  }

  @override
  Future<void> removeAccount(Account account) async {
    var user = await getUser();

    if (user.hasAccount(id: account.id)) {
      user = user.removeAccount(id: account.id);
    }

    if (user.activeAccount == null) {
      final firstAccount = user.accounts.firstOrNull;
      if (firstAccount != null) {
        user = user.useAccount(id: firstAccount.id);
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
    if (_user != user) {
      _logger.info('Changing user to [$user]');

      if (_user.activeAccount?.keychain.id != user.activeAccount?.keychain.id) {
        _user.activeAccount?.keychain.isActive = false;
        user.activeAccount?.keychain.isActive = _isActive;
      }

      await _userRepository.saveUser(user);

      _user = user;
      _userSC.add(user);
    }
  }

  @override
  Future<void> dispose() async {
    await _userSC.close();
  }
}
