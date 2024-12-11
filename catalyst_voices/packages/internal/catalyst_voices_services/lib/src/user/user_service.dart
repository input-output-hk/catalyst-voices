import 'dart:async';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserService implements ActiveAware {
  factory UserService({
    required KeychainProvider keychainProvider,
    required UserStorage userStorage,
  }) {
    return UserServiceImpl(
      keychainProvider,
      userStorage,
    );
  }

  Account? get account;

  Stream<Account?> get watchAccount;

  Keychain? get keychain;

  Future<List<Keychain>> get keychains;

  Stream<Keychain?> get watchKeychain;

  Future<void> useLastAccount();

  Future<void> useAccount(Account account);

  Future<void> useKeychain(String id);

  Future<void> removeCurrentKeychain();

  Future<void> removeKeychain(String id);

  Future<void> dispose();
}

final class UserServiceImpl implements UserService {
  final KeychainProvider _keychainProvider;
  final UserStorage _userStorage;

  final _logger = Logger('UserService');

  User? _user;
  final _userSC = StreamController<User?>.broadcast();

  Keychain? _keychain;
  final _keychainSC = StreamController<Keychain?>.broadcast();
  StreamSubscription<bool>? _keychainUnlockSub;

  bool _isActive = true;

  UserServiceImpl(
    this._keychainProvider,
    this._userStorage,
  );

  @override
  Account? get account => _user?.activeAccount;

  @override
  Stream<Account?> get watchAccount async* {
    yield account;
    yield* _userSC.stream.map((user) => user?.activeAccount).distinct();
  }

  @override
  Keychain? get keychain => _keychain;

  @override
  Future<List<Keychain>> get keychains => _keychainProvider.getAll();

  @override
  Stream<Keychain?> get watchKeychain async* {
    yield _keychain;
    yield* _keychainSC.stream;
  }

  @override
  bool get isActive => _isActive;

  @override
  set isActive(bool value) {
    if (_isActive != value) {
      _isActive = value;
      _keychain?.isActive = value;
    }
  }

  @override
  Future<void> useLastAccount() async {
    final keychainId = await _userStorage.getLastKeychainId();
    if (keychainId == null) {
      await _clearUser();
      await _useKeychain(null);
      return;
    }

    final keychain = await _findKeychain(keychainId);
    if (keychain == null) {
      _logger.severe('Active keychain[$keychainId] was not found!');
    }

    await _clearUser();
    await _useKeychain(keychain);
  }

  @override
  Future<void> useAccount(Account account) async {
    await useKeychain(account.keychainId);
    _updateUser(User(accounts: [account]));
  }

  @override
  Future<void> useKeychain(String id) async {
    final keychain = await _findKeychain(id);
    if (keychain == null) {
      _logger.severe('Account keychain[$id] was not found!');
    }
    await _useKeychain(keychain);
  }

  @override
  Future<void> removeCurrentKeychain() async {
    final keychain = _keychain;
    if (keychain == null) {
      _logger.warning('Called remove keychain but no active found');
      return;
    }

    await removeKeychain(keychain.id);
  }

  @override
  Future<void> removeKeychain(String id) async {
    if (!await _keychainProvider.exists(id)) {
      _logger.warning(
        'Called remove keychain[$id] but no such keychain was found',
      );
      return;
    }

    final isCurrentKeychain = id == _keychain?.id;

    final keychain = await _keychainProvider.get(id);
    await keychain.clear();

    if (isCurrentKeychain) {
      await _clearUser();
      await _useKeychain(null);
    }
  }

  @override
  Future<void> dispose() async {
    await _keychainUnlockSub?.cancel();
    _keychainUnlockSub = null;

    _keychain = null;
    await _keychainSC.close();
  }

  Future<void> _useKeychain(Keychain? keychain) async {
    await _userStorage.setUsedKeychainId(keychain?.id);

    await _keychainUnlockSub?.cancel();
    _keychainUnlockSub = null;

    _updateActiveKeychain(keychain);

    if (keychain != null) {
      _keychainUnlockSub =
          keychain.watchIsUnlocked.listen(_onKeychainUnlockChanged);
    }
  }

  Future<void> _onKeychainUnlockChanged(bool isUnlocked) async {
    final keychain = _keychain;

    _logger.finest('$keychain unlock changed[$isUnlocked]');

    assert(
      keychain != null,
      'Keychain unlock stage changed but keychain is null',
    );

    if (!isUnlocked) {
      await _clearUser();
      return;
    }

    await _fetchUserDetails(keychain!);
  }

  // TODO(damian-molinski): fetch user details from backend with root key.
  Future<void> _fetchUserDetails(Keychain keychain) async {
    await Future<void>.delayed(const Duration(milliseconds: 100));

    final user = _user?.account.keychainId == keychain.id
        ? _user
        : _dummyUser(keychainId: keychain.id);

    _updateUser(user);
  }

  Future<void> _clearUser() async {
    _updateUser(null);
  }

  Future<Keychain?> _findKeychain(String id) async {
    final exists = await _keychainProvider.exists(id);

    return exists ? await _keychainProvider.get(id) : null;
  }

  void _updateActiveKeychain(Keychain? keychain) {
    if (_keychain?.id != keychain?.id) {
      _logger.finest('Keychain changed to $keychain');

      _keychain?.isActive = false;
      _keychain = keychain;
      _keychain?.isActive = _isActive;

      _keychainSC.add(keychain);
    }
  }

  void _updateUser(User? user) {
    if (_user != user) {
      _logger.finest('User changed to $user');
      _user = user;
      _userSC.add(user);
    }
  }
}

/// Temporary implementation for testing purposes.
User _dummyUser({
  required String keychainId,
}) {
  /* cSpell:disable */
  final account = Account(
    keychainId: keychainId,
    roles: {
      AccountRole.root,
    },
    walletInfo: WalletInfo(
      metadata: const WalletMetadata(
        name: 'Dummy Wallet',
        icon: null,
      ),
      balance: Coin.fromAda(10),
      address: ShelleyAddress.fromBech32(
        'addr_test1vzpwq95z3xyum8vqndgdd'
        '9mdnmafh3djcxnc6jemlgdmswcve6tkw',
      ),
    ),
  );

  return User(accounts: [account]);
  /* cSpell:enable */
}
