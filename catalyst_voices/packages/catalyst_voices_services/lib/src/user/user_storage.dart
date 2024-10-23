import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _activeKeychainIdKey = 'activeKeychainId';

abstract interface class UserStorage {
  Future<String?> getActiveKeychainId();

  Future<void> changeActiveKeychainId(String id);

  Future<void> clearActiveKeychain();
}

final class SecureUserStorage extends SecureStorage implements UserStorage {
  SecureUserStorage({
    super.secureStorage,
  });

  @override
  Future<String?> getActiveKeychainId() {
    return readString(key: _activeKeychainIdKey);
  }

  @override
  Future<void> changeActiveKeychainId(String id) {
    return writeString(id, key: _activeKeychainIdKey);
  }

  @override
  Future<void> clearActiveKeychain() {
    return writeString(null, key: _activeKeychainIdKey);
  }
}
