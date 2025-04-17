import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
import 'package:catalyst_voices_repositories/src/user/source/user_data_source.dart';
import 'package:catalyst_voices_repositories/src/user/source/user_storage.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserRepository {
  factory UserRepository(
    UserStorage storage,
    UserDataSource dataSource,
    KeychainProvider keychainProvider,
  ) {
    return UserRepositoryImpl(
      storage,
      dataSource,
      keychainProvider,
    );
  }

  Future<User> getUser();

  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  });

  Future<void> saveUser(User user);

  Future<void> updateEmail(String email);
}

final class UserRepositoryImpl implements UserRepository {
  final UserStorage _storage;
  final UserDataSource _dataSource;
  final KeychainProvider _keychainProvider;

  UserRepositoryImpl(
    this._storage,
    this._dataSource,
    this._keychainProvider,
  );

  @override
  Future<User> getUser() async {
    final dto = await _storage.readUser();

    final user = await dto?.toModel(keychainProvider: _keychainProvider);

    return user ?? const User.empty();
  }

  @override
  Future<RecoveredAccount> recoverAccount({
    required CatalystId catalystId,
    required String rbacToken,
  }) {
    return _dataSource.recoverAccount(
      catalystId: catalystId,
      rbacToken: rbacToken,
    );
  }

  @override
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
  }

  @override
  Future<void> updateEmail(String email) async {
    await _dataSource.updateEmail(email);
  }
}
