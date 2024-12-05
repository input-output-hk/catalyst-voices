import 'dart:async';
import 'dart:typed_data';

import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:test/test.dart';

void main() {
  const key = 'key';

  final storage = _TestStorage();

  setUp(storage.clear);

  group('int', () {
    test('read returns null when no value found', () async {
      // Given

      // When
      final value = await storage.readInt(key: key);

      // Then
      expect(value, isNull);
    });

    test('read returns non-null when value found', () async {
      // Given
      const expected = 1;

      // When
      storage._data[key] = '$expected';
      final value = await storage.readInt(key: key);

      // Then
      expect(value, expected);
    });

    test('internally keeps correct String', () async {
      // Given
      const expected = 1;
      storage._data[key] = '$expected';

      // When
      await storage.writeInt(expected, key: key);
      final value = storage.readString(key: key);

      // Then
      expect(value, '$expected');
    });
  });

  group('bool', () {
    test('read returns null when no value found', () async {
      // Given

      // When
      final value = await storage.readBool(key: key);

      // Then
      expect(value, isNull);
    });

    test('read stores false as 0', () async {
      // Given
      const expected = false;
      const expectedString = '0';

      // When
      await storage.writeBool(expected, key: key);
      final value = await storage.readString(key: key);

      // Then
      expect(value, expectedString);
    });

    test('read stores true as 1', () async {
      // Given
      const expected = true;
      const expectedString = '1';

      // When
      await storage.writeBool(expected, key: key);
      final value = await storage.readString(key: key);

      // Then
      expect(value, expectedString);
    });

    test('write and read values matches', () async {
      // Given
      const expected = true;

      // When
      await storage.writeBool(expected, key: key);
      final value = await storage.readBool(key: key);

      // Then
      expect(value, expected);
    });
  });

  group('bytes', () {
    test('read returns null when no value found', () async {
      // Given

      // When
      final value = await storage.readBytes(key: key);

      // Then
      expect(value, isNull);
    });

    test('can write and read value correctly', () async {
      // Given
      final bytes = Uint8List.fromList([0, 0, 0, 0, 0, 1]);

      // When
      await storage.writeBytes(bytes, key: key);
      final value = await storage.readBytes(key: key);

      // Then
      expect(value, bytes);
    });
  });

  test('delete writes null string', () async {
    // Given
    const randomValue = 'D';

    // When
    await storage.writeString(randomValue, key: key);
    await storage.delete(key: key);
    final value = await storage.readString(key: key);

    // Then
    expect(value, isNull);
  });
}

class _TestStorage with StorageAsStringMixin implements Storage {
  final _data = <String, String>{};

  @override
  FutureOr<void> clear() {
    _data.clear();
  }

  @override
  Future<bool> contains({required String key}) async {
    return _data[key] != null;
  }

  @override
  FutureOr<String?> readString({required String key}) => _data[key];

  @override
  FutureOr<void> writeString(
    String? value, {
    required String key,
  }) {
    if (value != null) {
      _data[key] = value;
    } else {
      _data.remove(key);
    }
  }
}
