import 'package:catalyst_voices_services/catalyst_voices_services.dart';

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
    // TODO: implement activeKeychainId
    throw UnimplementedError();
  }

  @override
  Future<void> changeActiveKeychainId(String id) {
    // TODO: implement changeActiveKeychainId
    throw UnimplementedError();
  }

  @override
  Future<void> clearActiveKeychain() {
    // TODO: implement clearActiveKeychain
    throw UnimplementedError();
  }
}
