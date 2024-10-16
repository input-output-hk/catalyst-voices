import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/src/storage/vault/lock_factor.dart';
import 'package:catalyst_voices_services/src/storage/vault/secure_storage_vault.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:test/test.dart';

void main() {
  late final FlutterSecureStorage flutterSecureStorage;
  late final SecureStorageVault vault;

  setUpAll(() {
    FlutterSecureStorage.setMockInitialValues({});

    flutterSecureStorage = const FlutterSecureStorage();
    vault = SecureStorageVault(secureStorage: flutterSecureStorage);
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
}
