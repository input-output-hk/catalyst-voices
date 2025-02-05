import 'dart:convert';

import 'package:catalyst_voices_repositories/src/dto/user_dto.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';

const _key = 'UserStorage';
const _version = 2;
const _userKey = 'User';

abstract interface class UserStorage {
  Future<UserDto?> readUser();

  Future<void> writeUser(UserDto user);

  Future<void> deleteUser();

  Future<void> clear();
}

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

  static Future<void> clearPreviousVersions() async {
    for (var i = 0; i < _version; i++) {
      final versionedStorage = SecureUserStorage._versioned(version: i);

      await versionedStorage.clear();
    }
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

  @override
  Future<void> deleteUser() async {
    await delete(key: _userKey);
  }

  @override
  Future<void> clear() async {
    await deleteUser();
  }
}
