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
  late final CatalystPrivateKeyFactory keyFactory;
  late final VaultKeychainProvider provider;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});

    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;

    keyFactory = _FakeCatalystKeyFactory();

    provider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: const CacheConfig(),
    );
  });

  tearDown(() async {
    await const FlutterSecureStorage().deleteAll();
    await SharedPreferencesAsync().clear();
  });

  group(VaultKeychainProvider, () {
    test('create returns empty keychain', () async {
      // Given
      final id = const Uuid().v4();

      // When
      final keychain = await provider.create(id);

      // Then
      expect(await provider.exists(id), isTrue);
      expect(
        [keychain.id],
        await provider.getAll().then((value) => value.map((e) => e.id)),
      );
    });

    test('calling create twice on keychain will empty previous data', () async {
      // Given
      final id = const Uuid().v4();
      const lockFactor = PasswordLockFactor('Test1234');
      final key = keyFactory.createPrivateKey(
        Uint8List.fromList(
          hex.decode(
            '8a88e3dd7409f195fd52db2d3cba5d72ca6709bf1d94121bf3748801b40f6f5c',
          ),
        ),
      );

      // When
      var keychain = await provider.create(id);
      await keychain.setLock(lockFactor);
      await keychain.unlock(lockFactor);
      await keychain.setMasterKey(key);

      // Then
      expect(await keychain.isUnlocked, isTrue);
      expect(await keychain.isEmpty, isFalse);

      keychain = await provider.create(id);

      expect(await keychain.isUnlocked, isFalse);
      expect(await keychain.isEmpty, isTrue);
    });

    test('exists returns false when storage is empty', () async {
      // Given
      final id = const Uuid().v4();

      // When

      // Then
      expect(await provider.exists(id), isFalse);
    });

    test('exists returns true for existing keychain', () async {
      // Given
      final id = const Uuid().v4();

      // When
      await provider.create(id);

      // Then
      expect(await provider.exists(id), isTrue);
    });

    test(
      'exists returns false when multiple keychains exits but none matches id',
      () async {
        // Given
        final id = const Uuid().v4();
        final existsIds = List.generate(2, (_) => const Uuid().v4());

        // When
        for (final id in existsIds) {
          await provider.create(id);
        }

        // Then
        expect(await provider.exists(id), isFalse);
      },
    );

    test('getAll returns keychains without duplicates', () async {
      // Given
      final ids = List.generate(2, (_) => const Uuid().v4());

      // When
      for (final id in ids) {
        await provider.create(id);
      }

      // Then
      final keychains = await provider.getAll();
      expect(keychains.length, ids.length);
      expect(keychains.map((e) => e.id), containsAll(ids));
    });
  });
}

class _FakeCatalystKeyFactory extends Fake
    implements CatalystPrivateKeyFactory {
  @override
  CatalystPrivateKey createPrivateKey(Uint8List bytes) {
    return _FakeCatalystPrivateKey(bytes: bytes);
  }
}

class _FakeCatalystPrivateKey extends Fake implements CatalystPrivateKey {
  @override
  final Uint8List bytes;

  _FakeCatalystPrivateKey({required this.bytes});
}
