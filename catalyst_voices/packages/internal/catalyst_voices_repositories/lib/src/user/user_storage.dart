import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dtos/user_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _userKey = 'User';

abstract interface class UserStorage {
  Future<UserDto?> readUser();

  Future<void> writeUser(UserDto user);

  Future<void> deleteUser();
}

final class SecureUserStorage extends SecureStorage implements UserStorage {
  SecureUserStorage({
    super.secureStorage,
  });

  @override
  Future<UserDto?> readUser() async {
    final encoded = await readString(key: _userKey);
    if (encoded == null) {
      return null;
    }

    final decoded = json.decode(encoded) as Map<String, dynamic>;

    return UserDto.fromJson(decoded);
  }

  @override
  Future<void> writeUser(UserDto user) async {
    final encoded = json.encode(user.toJson());
    await writeString(encoded, key: _userKey);
  }

  @override
  Future<void> deleteUser() async {
    await delete(key: _userKey);
  }
}
