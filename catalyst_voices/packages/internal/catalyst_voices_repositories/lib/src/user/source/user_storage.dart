import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/user/user_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _key = 'UserStorage';
const _userKey = 'User';
const _version = 3;

final class SecureUserStorage extends SecureStorage implements UserStorage {
  SecureUserStorage({
    super.secureStorage,
  }) : super(
          key: _key,
          version: _version,
        );

  SecureUserStorage._versioned({
    super.version,
  }) : super(key: _key);

  @override
  Future<void> clear() async {
    await deleteUser();
  }

  @override
  Future<void> deleteUser() async {
    await delete(key: _userKey);
  }

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

  static Future<void> clearPreviousVersions() async {
    for (var i = 0; i < _version; i++) {
      final versionedStorage = SecureUserStorage._versioned(version: i);

      await versionedStorage.clear();
    }
  }
}

abstract interface class UserStorage {
  Future<void> clear();

  Future<void> deleteUser();

  Future<UserDto?> readUser();

  Future<void> writeUser(UserDto user);
}
