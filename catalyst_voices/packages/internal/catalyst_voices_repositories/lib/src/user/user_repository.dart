import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
import 'package:catalyst_voices_repositories/src/user/user_storage.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

abstract interface class UserRepository {
  factory UserRepository(
    UserStorage storage,
    KeychainProvider keychainProvider,
  ) {
    return UserRepositoryImpl(
      storage,
      keychainProvider,
    );
  }

  Future<User> getUser();

  Future<void> saveUser(User user);
}

final class UserRepositoryImpl implements UserRepository {
  final UserStorage _storage;
  final KeychainProvider _keychainProvider;

  UserRepositoryImpl(
    this._storage,
    this._keychainProvider,
  );

  @override
  Future<User> getUser() async {
    final dto = await _storage.readUser();

    final user = await dto?.toModel(keychainProvider: _keychainProvider);

    return user ?? const User.empty();
  }

  @override
  Future<void> saveUser(User user) {
    final dto = UserDto.fromModel(user);

    return _storage.writeUser(dto);
  }
}
