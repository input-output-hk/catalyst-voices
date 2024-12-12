import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/src/user/user_storage.dart';

abstract interface class UserRepository {
  factory UserRepository(UserStorage storage) {
    return UserRepositoryImpl(storage);
  }

  Future<void> saveUser(User user);

  Future<User> getUser();
}

final class UserRepositoryImpl implements UserRepository {
  final UserStorage _storage;

  UserRepositoryImpl(
    this._storage,
  );

  @override
  Future<User> getUser() async {
    final localUser = await _storage.readUser();

    final user = localUser ?? const User.empty();

    return user;
  }

  @override
  Future<void> saveUser(User user) {
    return _storage.writeUser(user);
  }
}
