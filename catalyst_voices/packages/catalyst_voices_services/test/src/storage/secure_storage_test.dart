import 'package:catalyst_voices_services/src/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';

void main() {
  late final FlutterSecureStorage flutterSecureStorage;
  late final SecureStorage secureStorage;

  setUpAll(
    () {
      FlutterSecureStorage.setMockInitialValues({});

      flutterSecureStorage = const FlutterSecureStorage();
      secureStorage = SecureStorage(secureStorage: flutterSecureStorage);
    },
  );

  tearDown(
    () async {
      await secureStorage.clear();
    },
  );

  test('read returns null when no value found for key', () async {
    // Given
    const key = 'key';

    // When
    final value = await secureStorage.readString(key: key);

    // Then
    expect(value, isNull);
  });
}
