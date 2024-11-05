import 'dart:async';

import 'package:catalyst_voices_services/src/storage/secure_storage.dart';

abstract interface class DummyAuthStorage {
  FutureOr<String?> readEmail();

  FutureOr<void> writeEmail(String? value);

  FutureOr<String?> readPassword();

  FutureOr<void> writePassword(String? value);

  Future<void> clear();
}

final class SecureDummyAuthStorage extends SecureStorage
    implements DummyAuthStorage {
  static const _emailKey = 'email';
  static const _passwordKey = 'password';

  const SecureDummyAuthStorage({
    super.secureStorage,
  });

  @override
  FutureOr<String?> readEmail() => readString(key: _emailKey);

  @override
  FutureOr<void> writeEmail(String? value) {
    return writeString(value, key: _emailKey);
  }

  @override
  FutureOr<String?> readPassword() => readString(key: _passwordKey);

  @override
  FutureOr<void> writePassword(String? value) {
    return writeString(value, key: _passwordKey);
  }

  @override
  Future<void> clear() async {
    await writeEmail(null);
    await writePassword(null);
  }
}
