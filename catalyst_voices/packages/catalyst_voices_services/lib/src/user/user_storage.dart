import 'package:catalyst_voices_services/catalyst_voices_services.dart';

const _activeKeychainIdKey = 'activeKeychainId';

abstract interface class UserStorage {
  Future<String?> getLastKeychainId();

  Future<void> setUsedKeychainId(String? id);
}

final class SecureUserStorage extends SecureStorage implements UserStorage {
  SecureUserStorage({
    super.secureStorage,
  });

  @override
  Future<String?> getLastKeychainId() {
    return readString(key: _activeKeychainIdKey);
  }

  @override
  Future<void> setUsedKeychainId(String? id) {
    return writeString(id, key: _activeKeychainIdKey);
  }
}
