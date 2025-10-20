import 'dart:typed_data';

import 'package:catalyst_cardano_serialization/catalyst_cardano_serialization.dart';
import 'package:catalyst_voices_dev/catalyst_voices_dev.dart';
import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_repositories/catalyst_voices_repositories.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/in_memory_shared_preferences_async.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_async_platform_interface.dart';
import 'package:uuid_plus/uuid_plus.dart';

void main() {
  late final CatalystPrivateKeyFactory keyFactory;
  late final VaultKeychainProvider provider;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});

    final store = InMemorySharedPreferencesAsync.empty();
    SharedPreferencesAsyncPlatform.instance = store;

    keyFactory = FakeCatalystPrivateKeyFactory();

    provider = VaultKeychainProvider(
      secureStorage: const FlutterSecureStorage(),
      sharedPreferences: SharedPreferencesAsync(),
      cacheConfig: AppConfig.dev().cache,
      keychainSigner: FakeKeychainSigner(),
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
      final key = keyFactory.create(
        Uint8List.fromList(
          hexDecode(
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

    test('calling get for same keychain returns same instance', () async {
      // Given
      final id = const Uuid().v4();

      // When
      await provider.create(id);
      final keychainOne = await provider.get(id);
      final keychainTwo = await provider.get(id);

      // Then
      expect(keychainOne, same(keychainTwo));
    });
  });
}
