import 'dart:typed_data';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/catalyst_voices_shared.dart';
import 'package:convert/convert.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:test/test.dart';
import 'package:uuid/uuid.dart';

void main() {
  group(VaultKeychain, () {
    late final FlutterSecureStorage secureStorage;
    late final SharedPreferencesAsync sharedPreferences;
    late final CatalystKeyFactory privateKeyFactory;

    setUpAll(() {
      FlutterSecureStorage.setMockInitialValues({});

      final store = InMemorySharedPreferencesAsync.empty();
      SharedPreferencesAsyncPlatform.instance = store;

      secureStorage = const FlutterSecureStorage();
      sharedPreferences = SharedPreferencesAsync();
      privateKeyFactory = _FakeCatalystPrivateKeyFactory();
    });

    tearDown(() async {
      await secureStorage.deleteAll();
      await sharedPreferences.clear();
    });

    VaultKeychain buildKeychain(String id) {
      return VaultKeychain(
        id: id,
        secureStorage: secureStorage,
        sharedPreferences: sharedPreferences,
        privateKeyFactory: privateKeyFactory,
      );
    }

    test('is considered empty even with metadata in it', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final vault = buildKeychain(id);

      // Then
      expect(await vault.isEmpty, isTrue);
    });

    test('is not empty when master key is written', () async {
      // Given
      final id = const Uuid().v4();
      const lock = PasswordLockFactor('Test1234');
      final key = privateKeyFactory.createPrivateKey(
        Uint8List.fromList(
          hex.decode(
            '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
          ),
        ),
      );

      // When
      final vault = buildKeychain(id);
      await vault.setLock(lock);
      await vault.unlock(lock);

      // Then
      await vault.setMasterKey(key);
      expect(await vault.isEmpty, isFalse);
    });

    test('are not equal when id is matching', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final vaultOne = buildKeychain(id);
      final vaultTwo = buildKeychain(id);

      // Then
      expect(vaultOne, isNot(equals(vaultTwo)));
    });
  });
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey({required this.bytes});
}

class _FakeCatalystPrivateKeyFactory extends Fake
    implements CatalystKeyFactory {
  @override
  CatalystPrivateKey createPrivateKey(Uint8List bytes) {
    return _FakeCatalystPrivateKey(bytes: bytes);
  }
}
