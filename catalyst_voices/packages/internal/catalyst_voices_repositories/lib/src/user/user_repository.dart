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
  Future<User> getUser() {
    // TODO: implement getUser
    throw UnimplementedError();
  }

  @override
  Future<void> saveUser(User user) {
    // TODO: implement saveUser
    throw UnimplementedError();
  }
}
