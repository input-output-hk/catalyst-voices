import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _userKey = 'User';

abstract interface class UserStorage {
  Future<User?> readUser();

  Future<void> writeUser(User user);

  Future<void> deleteUser();
}

final class SecureUserStorage extends SecureStorage implements UserStorage {
  SecureUserStorage({
    super.secureStorage,
  });

  @override
  Future<User?> readUser() async {
    final encoded = await readString(key: _userKey);
    if (encoded == null) {
      return null;
    }

    final decoded = json.decode(encoded) as Map<String, dynamic>;

    return User.fromJson(decoded);
  }

  @override
  Future<void> writeUser(User user) async {
    final encoded = json.encode(user.toJson());
    await writeString(encoded, key: _userKey);
  }

  @override
  Future<void> deleteUser() async {
    await delete(key: _userKey);
  }
}
