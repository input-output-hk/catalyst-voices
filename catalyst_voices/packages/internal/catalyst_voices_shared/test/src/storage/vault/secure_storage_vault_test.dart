import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_shared/src/storage/vault/secure_storage_vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';

void main() {
  late final FlutterSecureStorage flutterSecureStorage;
  late final SecureStorageVault vault;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});

    flutterSecureStorage = const FlutterSecureStorage();
    vault = SecureStorageVault(
      id: 'id',
      secureStorage: flutterSecureStorage,
    );
  });

  tearDown(() async {
    await flutterSecureStorage.deleteAll();
  });

  test('lock and unlock factor fallbacks to lock state', () async {
    // Given

    // When
    final isUnlocked = await vault.isUnlocked;

    // Then
    expect(isUnlocked, isFalse);
  });

  test('read when not unlocked throws exception', () async {
    // Given
    const key = 'SecureStorageVault.key';
    const value = 'username';

    // When
    await flutterSecureStorage.write(key: key, value: value);

    // Then
    expect(
      () => vault.readString(key: key),
      throwsA(isA<VaultLockedException>()),
    );
  });

  test('write throws exception when is locked', () async {
    // Given
    const key = 'key';
    const value = 'username';

    // When
    await vault.lock();

    // Then
    expect(
      () => vault.writeString(value, key: key),
      throwsA(isA<VaultLockedException>()),
    );
  });

  test('unlock update lock and returns null when locked', () async {
    // Given
    const lock = PasswordLockFactor('pass1234');
    const key = 'key';
    const value = 'username';

    // When
    await vault.setLock(lock);
    final isUnlocked = await vault.unlock(lock);
    await vault.writeString(value, key: key);
    final readValue = await vault.readString(key: key);

    // Then
    expect(isUnlocked, isTrue);
    expect(readValue, value);
  });

  test('lock makes vault locked', () async {
    // Given
    const lock = PasswordLockFactor('pass1234');

    // When
    await vault.setLock(lock);
    await vault.unlock(lock);
    await vault.lock();

    final isUnlocked = await vault.isUnlocked;

    // Then
    expect(isUnlocked, isFalse);
  });

  test('clear removes all vault keys', () async {
    // Given
    const lock = PasswordLockFactor('pass1234');
    final vaultKeyValues = <String, String>{
      'one': utf8.fuse(base64).encode('qqq'),
      'two': utf8.fuse(base64).encode('qqq'),
    };
    const nonVaultKeyValues = <String, String>{
      'three': 'qqq',
    };

    // When
    await vault.setLock(lock);
    await vault.unlock(lock);

    for (final entity in vaultKeyValues.entries) {
      await vault.writeString(entity.value, key: entity.key);
    }

    for (final entity in nonVaultKeyValues.entries) {
      await flutterSecureStorage.write(key: entity.key, value: entity.value);
    }

    await vault.clear();

    final futures =
        vaultKeyValues.keys.map((e) => vault.readString(key: e)).toList();

    final values = await Future.wait(futures);
    final fValues = await flutterSecureStorage.readAll();

    // Then
    expect(values, everyElement(isNull));
    expect(fValues, nonVaultKeyValues);
  });

  group('Get storage id', () {
    test('returns correctly extracted value', () {
      // Given
      const storageId = 'UUID';
      const key = 'SecureStorageVault.$storageId.rootKey';

      // When
      final id = SecureStorageVault.getStorageId(key);

      // Then
      expect(id, storageId);
    });

    test('throws exception when too many dots', () {
      // Given
      const storageId = 'UUID';
      const key = 'Secure.Storage.Vault.$storageId.rootKey';

      // When

      // Then
      expect(
        () => SecureStorageVault.getStorageId(key),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception when empty', () {
      // Given
      const key = '';

      // When

      // Then
      expect(
        () => SecureStorageVault.getStorageId(key),
        throwsA(isA<ArgumentError>()),
      );
    });

    test('throws exception when invalid value', () {
      // Given
      const key = 'Secure.rootKey';

      // When

      // Then
      expect(
        () => SecureStorageVault.getStorageId(key),
        throwsA(isA<ArgumentError>()),
      );
    });
  });

  group('Is storage key', () {
    test('returns true for valid key', () {
      // Given
      const storageId = 'UUID';
      const key = 'SecureStorageVault.$storageId.rootKey';

      // When
      final isValid = SecureStorageVault.isStorageKey(key);

      // Then
      expect(isValid, isTrue);
    });

    test('returns false for invalid key', () {
      // Given
      const key = 'SecureStorageVault.rootKey';

      // When
      final isValid = SecureStorageVault.isStorageKey(key);

      // Then
      expect(isValid, isFalse);
    });

    test('uuid keychain id is valid', () {
      // Given
      const key =
          'SecureStorageVault.274f6ab9-39f7-4120-b705-274fea95598e.metadata';

      // When
      final isValid = SecureStorageVault.isStorageKey(key);

      // Then
      expect(isValid, isTrue);
    });
  });
}
