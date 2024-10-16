import 'dart:convert';

import 'package:catalyst_voices_models/catalyst_voices_models.dart';
import 'package:catalyst_voices_services/catalyst_voices_services.dart';
import 'package:catalyst_voices_services/src/storage/vault/vault_crypto_service.dart';
import 'package:flutter/foundation.dart';
import 'package:test/test.dart';

void main() {
  final cryptoService = VaultCryptoService();

  group('key derivation', () {
    test(
      'derived key matches when verifying with same seed',
      () async {
        // Given
        const lockFactor = PasswordLockFactor('admin');

        // When
        final seed = lockFactor.seed;
        final key = await cryptoService.deriveKey(seed);

        // Then
        final isVerified = await cryptoService.verifyKey(seed, key: key);

        expect(isVerified, isTrue);
      },
    );

    test(
      'derived key does not matches when verifying with different seed',
      () async {
        // Given
        const lockFactor = PasswordLockFactor('admin');
        const otherLockFactor = PasswordLockFactor('1234');

        // When
        final seed = lockFactor.seed;
        final otherSeed = otherLockFactor.seed;

        final key = await cryptoService.deriveKey(seed);

        // Then
        final isVerified = await cryptoService.verifyKey(otherSeed, key: key);

        expect(isVerified, isFalse);
      },
    );

    test(
      'verifying key against too short seed returns false',
      () async {
        // Given
        const lockFactor = PasswordLockFactor('admin');
        final invalidSeed = Uint8List.fromList([]);

        // When
        final seed = lockFactor.seed;
        final key = await cryptoService.deriveKey(seed);

        // Then
        final isVerified = await cryptoService.verifyKey(invalidSeed, key: key);

        expect(isVerified, isFalse);
      },
    );
  });

  group('crypto', () {
    test('encrypted and later decrypted data with same key matches', () async {
      // Given
      const lockFactor = PasswordLockFactor('admin');
      const data = 'Hello Catalyst!';

      // When
      final key = await cryptoService.deriveKey(lockFactor.seed);

      // Then
      final encoded = utf8.encode(data);
      final encrypted = await cryptoService.encrypt(encoded, key: key);

      expect(encrypted, isNot(equals(encoded)));

      final decrypted = await cryptoService.decrypt(encrypted, key: key);
      final decoded = utf8.decode(decrypted);

      expect(decoded, equals(data));
    });

    test(
        'encrypted and later decrypted data with '
        'different key gives throws exception', () async {
      // Given
      const lockFactor = PasswordLockFactor('admin');
      const unlockFactor = PasswordLockFactor('1234');

      const data = 'Hello Catalyst!';

      // When
      final encryptKey = await cryptoService.deriveKey(lockFactor.seed);
      final decryptKey = await cryptoService.deriveKey(unlockFactor.seed);

      // Then
      final encoded = utf8.encode(data);
      final encrypted = await cryptoService.encrypt(encoded, key: encryptKey);

      expect(encrypted, isNot(equals(encoded)));

      expect(
        () => cryptoService.decrypt(encrypted, key: decryptKey),
        throwsA(isA<CryptoAuthenticationException>()),
      );
    });
  });
}
