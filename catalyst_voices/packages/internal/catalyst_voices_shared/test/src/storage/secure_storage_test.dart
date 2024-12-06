import 'package:catalyst_voices_shared/src/storage/secure_storage.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';

void main() {
  late final FlutterSecureStorage flutterSecureStorage;
  late final SecureStorage secureStorage;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});

    flutterSecureStorage = const FlutterSecureStorage();
    secureStorage = SecureStorage(secureStorage: flutterSecureStorage);
  });

  tearDown(() async {
    await secureStorage.clear();
  });

  test('read returns null when no value found for key', () async {
    // Given
    const key = 'key';

    // When
    final value = await secureStorage.readString(key: key);

    // Then
    expect(value, isNull);
  });

  test('read returns stored value when has one', () async {
    // Given
    const key = 'key';
    const expectedValue = 'qqqq';

    // When
    await secureStorage.writeString(expectedValue, key: key);
    final value = await secureStorage.readString(key: key);

    // Then
    expect(value, expectedValue);
  });

  test('writing null deletes value', () async {
    // Given
    const key = 'key';
    const expectedValue = 'qqqq';

    // When
    await secureStorage.writeString(expectedValue, key: key);
    await secureStorage.writeString(null, key: key);
    final value = await secureStorage.readString(key: key);

    // Then
    expect(value, isNull);
  });

  test('clear removes all values for this storage', () async {
    // Given
    const keyValues = <String, String>{
      'one': 'qqq',
      'two': 'qqq',
    };

    // When
    for (final entity in keyValues.entries) {
      await secureStorage.writeString(entity.value, key: entity.key);
    }

    await secureStorage.clear();

    final futures =
        keyValues.keys.map((e) => secureStorage.readString(key: e)).toList();

    final values = await Future.wait(futures);

    // Then
    expect(values, everyElement(isNull));
  });
}
